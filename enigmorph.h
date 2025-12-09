#ifndef ENIGMORPH_H
#define ENIGMORPH_H

#include <QObject>
#include <QString>
#include <QVector>

class EnigmaMachine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString pin READ pin WRITE setPin NOTIFY pinChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(bool isPinValid READ isPinValid NOTIFY pinChanged)

public:
    explicit EnigmaMachine(QObject *parent = nullptr);

    QString pin() const;
    QString password() const;
    bool isPinValid() const;

    void setPin(const QString &pin);
    void setPassword(const QString &pwd);

    Q_INVOKABLE QString encrypt(const QString &message);
    Q_INVOKABLE QString decrypt(const QString &cipherText);
    Q_INVOKABLE void reset();

    // --- FITUR STEGANOGRAFI ---
    // Menyisipkan pesan (ciphertext) ke dalam gambar
    Q_INVOKABLE bool embedSecret(const QString &imagePath, const QString &outputPath, const QString &secretData);
    
    // Mengambil pesan rahasia dari gambar
    Q_INVOKABLE QString extractSecret(const QString &imagePath);

signals:
    void pinChanged();
    void passwordChanged();
    void processingStarted();
    void processingFinished();

private:
    QVector<int> m_pin;
    QString m_password;

    // Konstanta ASCII
    static const int ASCII_START = 32;
    static const int ASCII_END = 126;
    static const int RANGE = 95;

    // Helper functions
    QVector<int> parsePin(const QString &pinStr) const;
    unsigned long long generateInitialSeed() const;
    QString runCipherOperation(const QString &input, bool isEncrypt);
    
    // Helper untuk path file QML
    QString cleanPath(const QString &path);
};

#endif // ENIGMORPH_H