#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "metronome.h"
#include "tapin.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Metronome metronome;
    TapIn tapin;
    qmlRegisterSingletonInstance<Metronome>("org.kde.rattlesnake", 1, 0, "Metronome", &metronome);
    qmlRegisterSingletonInstance<TapIn>("org.kde.rattlesnake", 1, 0, "TapIn", &tapin);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
