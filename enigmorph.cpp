#include "enigmorph.h"
#include <QDebug>

EnigmaMachine::EnigmaMachine(QObject *parent)
    : QObject(parent)
    , m_pin{0, 0, 0, 0}
    , m_password("default")
{
    qDebug() << "EnigmaMachine initialized (Enhanced PRNG Version)";
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
    qDebug() << "EnigmaMachine reset to defaults";
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
// LOGIKA "GENERATOR ACAK" (CORE ALGORITHM)
// ---------------------------------------------------------

// Membuat "Seed" (Benih) Unik dari kombinasi PIN dan Password
unsigned long long EnigmaMachine::generateInitialSeed() const
{
    unsigned long long seed = 0;

    // Campurkan PIN ke dalam seed
    // Kalikan dengan (i+1) agar urutan PIN berpengaruh (1234 != 4321)
    for (int i = 0; i < m_pin.size(); ++i) {
        seed = seed * 10 + (m_pin[i] * (i + 1));
    }

    // Campurkan Password ke dalam seed
    // Menggunakan operasi bitwise sederhana untuk mengacak bit
    if (!m_password.isEmpty()) {
        for (int i = 0; i < m_password.length(); ++i) {
            unsigned int charVal = m_password[i].unicode();
            // Kalikan dengan angka prima sembarang (1337) untuk menyebar nilai
            seed += charVal * (i + 1337);
            // Geser bit dan XOR untuk efek pengacakan (mixing)
            seed ^= (seed << 5);
        }
    }

    // Pastikan seed tidak 0 agar perkalian matematika nanti tidak macet
    if (seed == 0) seed = 123456789;

    return seed;
}

// Fungsi Eksekusi Enkripsi/Dekripsi dengan Stream Cipher
QString EnigmaMachine::runCipherOperation(const QString &input, bool isEncrypt)
{
    if (input.isEmpty()) {
        qWarning() << "Cannot perform operation on empty text";
        return QString();
    }

    if (!isPinValid()) {
        qWarning() << "Invalid PIN";
        return QString();
    }

    emit processingStarted();

    // Bangkitkan Seed awal
    unsigned long long currentSeed = generateInitialSeed();

    QString result;
    result.reserve(input.length());

    // Proses setiap karakter
    for (int i = 0; i < input.length(); ++i) {
        QChar currentChar = input[i];
        int charCode = currentChar.unicode();

        // Hanya proses karakter ASCII yang bisa dicetak (32-126)
        if (charCode >= ASCII_START && charCode <= ASCII_END) {

            // --- ALGORITMA PENGACAK (Linear Congruential Generator / LCG) ---
            // Rumus klasik: next = (prev * A + B)
            // Konstanta ini biasa digunakan di library C++ standar (GCC)
            currentSeed = (currentSeed * 1103515245 + 12345);

            // Ambil bit bagian atas sebagai angka acak, lalu modulo RANGE (95)
            // agar hasilnya ada di rentang 0-94 (sesuai jumlah karakter ASCII)
            int randomShift = (currentSeed / 65536) % RANGE;

            // --- PROSES GESER ---
            int originalVal = charCode - ASCII_START;
            int processedVal;

            if (isEncrypt) {
                // Enkripsi: Geser MAJU tambah angka acak
                processedVal = (originalVal + randomShift) % RANGE;
            } else {
                // Dekripsi: Geser MUNDUR kurangi angka acak
                processedVal = (originalVal - randomShift) % RANGE;

                // Koreksi hasil negatif (karena sifat modulo C++ bisa negatif)
                if (processedVal < 0) {
                    processedVal += RANGE;
                }
            }

            result += QChar(processedVal + ASCII_START);
        } else {
            // Jika karakter spesial (emoji, enter, tab), biarkan apa adanya
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
