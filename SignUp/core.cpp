#include "core.h"
#include "log.h"

#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJSValueIterator>



Core::Core(QObject *parent) :
    QObject(parent)
{
}



bool Core::init()
{
    if (readCountriesJson()) {
        m_clipboardAdapter = new ClipboardAdapter(this);
        return true;
    }

    return false;
}



bool Core::readCountriesJson()
{
    QFile file(s_countriesFileName);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        WARNING_LOG "failure to open file:" << s_countriesFileName;
        return false;
    }

    const QByteArray data = file.readAll();
    file.close();

    const QJsonDocument jsonDocument = QJsonDocument::fromJson(data);
    const QJsonObject rootJsonObject = jsonDocument.object();
    const QJsonValue jsonValue = rootJsonObject.value(QLatin1String("countries"));

    if (!jsonValue.isArray())
        return false;

    QJsonArray jsonArray = jsonValue.toArray();
    if (jsonArray.isEmpty())
        return false;

    for (int i = 0; i < jsonArray.count(); ++i) {
        const QJsonObject countryJsonObject = jsonArray.at(i).toObject();
        if (!countryJsonObject.contains(QLatin1String("code"))
                || !countryJsonObject.contains(QLatin1String("name"))) {
            jsonArray.removeAt(i);
            --i;
        }
    }

    m_countries = QVariant::fromValue(jsonArray.toVariantList());

    return !jsonArray.isEmpty();
}



bool Core::signUp(const QVariant &data) const
{
    jsToVariantMap(data);
    /*
    For this test version it is all correct,
    but in release version registration actions will be requared here
    */
    return true;
}



QVariantMap Core::jsToVariantMap(const QVariant &data) const
{
    QVariantMap map;
    const QJSValue jsValue = data.value<QJSValue>();
    QJSValueIterator it(jsValue);

    while (it.next()) {
        const QString name = it.name();

        if (name != QLatin1String("length")) {
            const QJSValue jsValue2 = it.value();
            QJSValueIterator it2(jsValue2);

            while (it2.next()) {
                const QString name = it2.name();
                const QVariant value = it2.value().toVariant();
                DEBUG_LOG name << value;
                map.insert(name, value);
            }
        }
    }

    return map;
}
