#include "enigmorph.h"
#include <QDebug>

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
        qDebug() << "PIN updated:" << pin();
    }
}

void EnigmaMachine::setPassword(const QString &pwd)
{
    QString newPassword = pwd.isEmpty() ? "default" : pwd;

    if (newPassword != m_password) {
        m_password = newPassword;
        emit passwordChanged();
        qDebug() << "Password updated (length:" << m_password.length() << ")";
    }
}

void EnigmaMachine::reset()
{
    m_pin = {0, 0, 0, 0};
    m_password = "default";
    emit pinChanged();
    emit passwordChanged();
    qDebug() << "EnigmaMachine reset to defaults";
}

QString EnigmaMachine::encrypt(const QString &message)
{
    // Menggunakan fungsi helper
    return runCipherOperation(message, true);
}

QString EnigmaMachine::decrypt(const QString &cipherText)
{
    // Menggunakan fungsi helper
    return runCipherOperation(cipherText, false);
}

// Fungsi helper
QString EnigmaMachine::runCipherOperation(const QString &input, bool isEncrypt)
{
    QString mode = isEncrypt ? "encryption" : "decryption";

    if (input.isEmpty()) {
        qWarning() << "Cannot perform" << mode << "on empty text";
        return QString();
    }

    if (!isPinValid()) {
        qWarning() << "Invalid PIN for" << mode;
        return QString();
    }

    emit processingStarted();
    qDebug() << (isEncrypt ? "Encrypting" : "Decrypting") << "text of length:" << input.length();

    QString result = processText(input, isEncrypt);

    emit processingFinished();
    qDebug() << mode << "completed";

    return result;
}

QVector<int> EnigmaMachine::parsePin(const QString &pinStr) const
{
    QVector<int> result;

    for (const QChar &c : pinStr) {
        if (c.isDigit()) {
            result.append(c.digitValue());
            if (result.size() >= 4) {
                break;
            }
        }
    }

    while (result.size() < 4) {
        result.append(0);
    }

    return result;
}

int EnigmaMachine::calculateShift(int msgIndex) const
{
    if (m_password.isEmpty()) {
        return 0;
    }

    int passVal = m_password.at(msgIndex % m_password.length()).unicode();
    int pinVal = m_pin[msgIndex % 4];

    return passVal + pinVal + msgIndex;
}

QString EnigmaMachine::processText(const QString &text, bool isEncrypt) const
{
    QString result;
    result.reserve(text.length());

    for (int i = 0; i < text.length(); ++i) {
        QChar currentChar = text[i];
        int charCode = currentChar.unicode();

        if (charCode >= ASCII_START && charCode <= ASCII_END) {
            int originalVal = charCode - ASCII_START;
            int shift = calculateShift(i);

            int processedVal;
            if (isEncrypt) {
                processedVal = (originalVal + shift) % RANGE;
            } else {
                processedVal = (originalVal - shift) % RANGE;
            }

            if (processedVal < 0) {
                processedVal += RANGE;
            }

            result += QChar(processedVal + ASCII_START);
        } else {
            result += currentChar;
        }
    }

    return result;
}
