#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDebug>
#include <QQuickStyle> // Tambahkan header ini

#include "enigmorph.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    QQuickStyle::setStyle("Basic");
    
    QGuiApplication app(argc, argv);
    
    app.setApplicationName("Enigmorph");
    app.setOrganizationName("Enigmorph Project");
    app.setOrganizationDomain("enigmorph.app");
    app.setApplicationVersion("2.0.0");
    
    EnigmaMachine enigmorph;
    
    QQmlApplicationEngine engine;
    
    engine.rootContext()->setContextProperty("enigmorph", &enigmorph);
    
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            qCritical() << "Failed to load QML file:" << url;
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    
    engine.load(url);
    
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "No root objects found in QML!";
        return -1;
    }
    
    qDebug() << "Enigmorph application started successfully";
    qDebug() << "Qt version:" << QT_VERSION_STR;
    
    return app.exec();
}