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

signals:
    void pinChanged();
    void passwordChanged();
    void processingStarted();
    void processingFinished();

private:
    QVector<int> m_pin;
    QString m_password;

    // Konstanta ASCII yang bisa dicetak (Space sampai Tilde)
    static const int ASCII_START = 32;
    static const int ASCII_END = 126;
    static const int RANGE = 95;

    // Helper functions
    QVector<int> parsePin(const QString &pinStr) const;

    // Fungsi inti untuk menghasilkan Seed dari PIN + Password
    unsigned long long generateInitialSeed() const;

    // Fungsi utama pemroses teks
    QString runCipherOperation(const QString &input, bool isEncrypt);
};

#endif // ENIGMORPH_H
