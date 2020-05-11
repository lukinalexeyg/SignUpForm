#ifndef CORE_H
#define CORE_H

#include <QObject>
#include <QMap>
#include <QVariant>
#include "clipboardadapter.h"

static const char* COUNTRIES_FILE_NAME = "countries.json";

class Core : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ClipboardAdapter *clipboardAdapter MEMBER m_clipboardAdapter CONSTANT)
    Q_PROPERTY(QVariant countries MEMBER m_countries CONSTANT)

public:
    explicit Core(QObject *parent = nullptr);
    bool init();
    Q_INVOKABLE bool signUp(const QVariant &data);

private:
    ClipboardAdapter *m_clipboardAdapter;
    QVariant m_countries;

private:
    bool readCountriesJson();
    QVariantMap jsToVariantMap(const QVariant &data);
};

#endif // CORE_H
