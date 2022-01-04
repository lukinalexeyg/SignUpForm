#ifndef CORE_H
#define CORE_H

#include <QObject>
#include <QMap>
#include <QVariant>

class Core : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant countries MEMBER m_countries CONSTANT)

public:
    explicit Core(QObject *parent = nullptr);

    QString init();
    Q_INVOKABLE bool signUp(const QVariant &data) const;

private:
    QVariant m_countries;

private:
    bool readCountriesJson();
    QVariantMap jsToVariantMap(const QVariant &data) const;
};

#endif // CORE_H
