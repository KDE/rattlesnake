// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#include "note.h"

#include <QDebug>

Note::Note(QObject *parent)
    : QObject(parent)
    , m_sound(0)
    , m_volume(50)
{

}

int Note::sound() const
{
    return m_sound;
}

void Note::setSound(const int sound)
{
    m_sound = sound;
    Q_EMIT soundChanged();

    setSoundFile(QUrl(QStringLiteral("qrc:/media/sounds/clicker%1.ogg").arg(sound + 1)));
    qDebug() << soundFile();
}

QUrl Note::soundFile() const
{
    return m_soundFile;
}

void Note::setSoundFile(const QUrl &soundFile)
{
    m_soundFile = soundFile;
}

int Note::volume() const
{
    return m_volume;
}

void Note::setVolume(int volume)
{
    m_volume = volume;
    Q_EMIT volumeChanged();
}
