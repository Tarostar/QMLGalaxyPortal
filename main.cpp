#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QtCore/QUrl>
#include <QQmlEngine>
#include <QUrl>
#include <QtQml>
#include "ticker.h"
#include "bridge.h"
#include <chrono>
#include <thread>

#include <QQuickItem>

int main(int argc, char *argv[])
{
    // Setup main event loop for the GUI.
    QGuiApplication app(argc, argv);
    app.setOrganizationName("UiO Project");
    app.setOrganizationDomain("github.com/Tarostar/QMLGalaxyPortal");
    app.setApplicationName("Galaxy Portal");

    // Setup background thread and bridge interface between thread and QML.
    Bridge* bridge = new Bridge();
    QThread* thread = new QThread;
    Ticker* ticker = new Ticker();
    ticker->moveToThread(thread);

    bridge->setTicker(ticker);

    // Connect signals and slots.
    QObject::connect(ticker, SIGNAL(tick()), bridge, SLOT(tick()), Qt::BlockingQueuedConnection);
    QObject::connect(thread, SIGNAL(started()), ticker, SLOT(mainThread()));
    QObject::connect(&app, SIGNAL(aboutToQuit()), bridge, SLOT(killTicker()));
    QObject::connect(&app, SIGNAL(aboutToQuit()), thread, SLOT(quit()));
    QObject::connect(&app, SIGNAL(aboutToQuit()), ticker, SLOT(deleteLater()));
    QObject::connect(&app, SIGNAL(aboutToQuit()), thread, SLOT(deleteLater()));
    QObject::connect(&app, SIGNAL(aboutToQuit()), bridge, SLOT(deleteLater()));
    thread->start();

    // Setup QQuickView window for displaying Qt Quick GUI and connect with background thread through the bridge interface.
    QtQuick2ApplicationViewer viewer;    
    viewer.rootContext()->setContextProperty("Bridge", bridge);
    viewer.setMainQmlFile(QStringLiteral("qml/QMLGalaxyPortal/main.qml"));
    viewer.showExpanded();

    // Execute main event loop.
    int nResult = app.exec();

    // Exit.
    return nResult;
}
