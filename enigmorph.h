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

    static const int ASCII_START = 32;
    static const int ASCII_END = 126;
    static const int RANGE = 95;

    // Helper functions
    int calculateShift(int msgIndex) const;
    QVector<int> parsePin(const QString &pinStr) const;
    QString processText(const QString &text, bool isEncrypt) const;

    // Centralizes the common logic for both encrypt/decrypt
    QString runCipherOperation(const QString &input, bool isEncrypt);
};

#endif // ENIGMORPH_H
