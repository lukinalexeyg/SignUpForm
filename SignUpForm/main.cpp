#include "core.h"

#include <lukqmlplugin.h>

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

    Core core;

    const QString errorString = core.init();
    if (!errorString.isEmpty())
        error(errorString);

    LukQmlPlugin lukQmlPlugin;
    lukQmlPlugin.registerTypes("LukQml");

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    context->setContextProperty(QStringLiteral("Core"), &core);
    engine.addImportPath(QStringLiteral("qrc:/"));
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
