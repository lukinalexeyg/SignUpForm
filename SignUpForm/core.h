#ifndef CORE_H
#define CORE_H

#include "clipboardadapter.h"

#include <QObject>
#include <QMap>
#include <QVariant>

class Core : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ClipboardAdapter *clipboardAdapter MEMBER m_clipboardAdapter CONSTANT)
    Q_PROPERTY(QVariant countries MEMBER m_countries CONSTANT)

public:
    explicit Core(QObject *parent = nullptr);

    QString init();
    Q_INVOKABLE bool signUp(const QVariant &data) const;

private:
    ClipboardAdapter *m_clipboardAdapter;
    QVariant m_countries;

private:
    bool readCountriesJson();
    QVariantMap jsToVariantMap(const QVariant &data) const;
};

#endif // CORE_H
