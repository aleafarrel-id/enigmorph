#include "enigmorph.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QUrl>

// Signature unik untuk menandai bahwa gambar ini mengandung pesan Enigmorph
const QByteArray APP_SIGNATURE = "||ENIGMORPH_DATA||";

EnigmaMachine::EnigmaMachine(QObject *parent)
    : QObject(parent)
    , m_pin{0, 0, 0, 0}
    , m_password("default")
{
    qDebug() << "EnigmaMachine initialized";
}

QString EnigmaMachine::pin() const
{
    QString result;
    for (int digit : m_pin) {
        result += QString::number(digit);
    }
    return result;
}

QString EnigmaMachine::password() const
{
    return m_password;
}

bool EnigmaMachine::isPinValid() const
{
    return m_pin.size() == 4;
}

void EnigmaMachine::setPin(const QString &pinStr)
{
    QVector<int> newPin = parsePin(pinStr);
    if (newPin != m_pin) {
        m_pin = newPin;
        emit pinChanged();
    }
}

void EnigmaMachine::setPassword(const QString &pwd)
{
    QString newPassword = pwd.isEmpty() ? "default" : pwd;
    if (newPassword != m_password) {
        m_password = newPassword;
        emit passwordChanged();
    }
}

void EnigmaMachine::reset()
{
    m_pin = {0, 0, 0, 0};
    m_password = "default";
    emit pinChanged();
    emit passwordChanged();
    qDebug() << "Reset to defaults";
}

QString EnigmaMachine::encrypt(const QString &message)
{
    return runCipherOperation(message, true);
}

QString EnigmaMachine::decrypt(const QString &cipherText)
{
    return runCipherOperation(cipherText, false);
}

// ---------------------------------------------------------
// STEGANOGRAPHY IMPLEMENTATION
// ---------------------------------------------------------

QString EnigmaMachine::cleanPath(const QString &path) {
    // Membersihkan path file:// dari QML
    QUrl url(path);
    if (url.isLocalFile()) {
        return url.toLocalFile();
    }
    return path;
}

bool EnigmaMachine::embedSecret(const QString &imagePath, const QString &outputPath, const QString &secretData)
{
    QString cleanImg = cleanPath(imagePath);
    QString cleanOut = cleanPath(outputPath);

    // Baca gambar asli
    QFile srcFile(cleanImg);
    if (!srcFile.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open source image:" << cleanImg;
        return false;
    }
    QByteArray imgData = srcFile.readAll();
    srcFile.close();

    // Persiapkan file output
    QFile destFile(cleanOut);
    if (!destFile.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open output file:" << cleanOut;
        return false;
    }

    // Tulis data gambar asli + Signature + Data Rahasia
    destFile.write(imgData);
    destFile.write(APP_SIGNATURE);
    destFile.write(secretData.toUtf8());
    
    destFile.close();
    return true;
}

QString EnigmaMachine::extractSecret(const QString &imagePath)
{
    QString cleanImg = cleanPath(imagePath);
    QFile file(cleanImg);

    if (!file.open(QIODevice::ReadOnly)) {
        return "";
    }

    QByteArray allData = file.readAll();
    file.close();

    // Cari posisi signature dari belakang file
    qsizetype sigPos = allData.lastIndexOf(APP_SIGNATURE);

    if (sigPos == -1) {
        return ""; // Tidak ada pesan rahasia
    }

    // Ambil semua data SETELAH signature
    QByteArray secretBytes = allData.mid(sigPos + APP_SIGNATURE.length());
    return QString::fromUtf8(secretBytes);
}

// ---------------------------------------------------------
// CORE ALGORITHM
// ---------------------------------------------------------

unsigned long long EnigmaMachine::generateInitialSeed() const
{
    unsigned long long seed = 0;
    for (int i = 0; i < m_pin.size(); ++i) {
        seed = seed * 10 + (m_pin[i] * (i + 1));
    }
    if (!m_password.isEmpty()) {
        for (int i = 0; i < m_password.length(); ++i) {
            unsigned int charVal = m_password[i].unicode();
            seed += charVal * (i + 1337);
            seed ^= (seed << 5);
        }
    }
    if (seed == 0) seed = 123456789;
    return seed;
}

QString EnigmaMachine::runCipherOperation(const QString &input, bool isEncrypt)
{
    if (input.isEmpty()) return QString();
    if (!isPinValid()) return QString();

    emit processingStarted();

    unsigned long long currentSeed = generateInitialSeed();
    QString result;
    result.reserve(input.length());

    for (int i = 0; i < input.length(); ++i) {
        QChar currentChar = input[i];
        int charCode = currentChar.unicode();

        if (charCode >= ASCII_START && charCode <= ASCII_END) {
            currentSeed = (currentSeed * 1103515245 + 12345);
            int randomShift = (currentSeed / 65536) % RANGE;
            int originalVal = charCode - ASCII_START;
            int processedVal;

            if (isEncrypt) {
                processedVal = (originalVal + randomShift) % RANGE;
            } else {
                processedVal = (originalVal - randomShift) % RANGE;
                if (processedVal < 0) processedVal += RANGE;
            }
            result += QChar(processedVal + ASCII_START);
        } else {
            result += currentChar;
        }
    }

    emit processingFinished();
    return result;
}

QVector<int> EnigmaMachine::parsePin(const QString &pinStr) const
{
    QVector<int> result;
    for (const QChar &c : pinStr) {
        if (c.isDigit()) {
            result.append(c.digitValue());
            if (result.size() >= 4) break;
        }
    }
    while (result.size() < 4) result.append(0);
    return result;
}