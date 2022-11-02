#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "core.h"
#include "requestcontroller.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    app.setOrganizationName("Haqton");
    app.setOrganizationDomain("https://www.kde.org/");
    app.setApplicationName("Haqton Quiz");

    QQmlApplicationEngine engine;

    qmlRegisterSingletonInstance<Core>("haqton",
                                       1, 0, "Core",
                                       Core::instance());

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    engine.load(url);

    return QGuiApplication::exec();
}

