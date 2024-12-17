// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#include "metronome.h"
#include "tapin.h"
#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

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
