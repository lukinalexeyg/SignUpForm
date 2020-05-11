#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QMessageBox>
#include "core.h"



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

    if (!QFile::exists(COUNTRIES_FILE_NAME))
        error(QString("File \"%1\" was not found").arg(COUNTRIES_FILE_NAME));

    Core core;

    if (!core.init())
        error(QString("File \"%1\" has no valid data").arg(COUNTRIES_FILE_NAME));

    QQmlApplicationEngine engine;
    QQmlContext *qmlContext = engine.rootContext();

    qmlContext->setContextProperty("Core", &core);
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/qml/themes/Theme.qml")), "Theme", 1, 0, "Theme");

    engine.addImportPath(QStringLiteral("qrc:/qml"));
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
