#include "core.h"

#include <QApplication>
#include <QMessageBox>
#include <QtQml>



void error(const QString &text)
{
    qApp->beep();
    QMessageBox::warning(nullptr, APP_PRODUCT, text);
    exit(0);
}



int main(int argc, char *argv[])
{
    qApp->setApplicationName(APP_PRODUCT);
    qApp->setApplicationVersion(APP_VERSION);
    qApp->setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    if (!QFile::exists(s_countriesFileName))
        error(QString("File \"%1\" was not found").arg(s_countriesFileName));

    Core core;

    if (!core.init())
        error(QString("File \"%1\" has no valid data").arg(s_countriesFileName));

    QQmlApplicationEngine engine;
    QQmlContext *qmlContext = engine.rootContext();

    qmlContext->setContextProperty(QStringLiteral("Core"), &core);
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/qml/themes/Theme.qml")), "Theme", 1, 0, "Theme");

    engine.addImportPath(QStringLiteral("qrc:/qml"));
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
