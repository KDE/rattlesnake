#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "metronome.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Metronome metronome;
    qmlRegisterSingletonInstance<Metronome>("org.kde.rattlesnake", 1, 0, "Metronome", & metronome);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
