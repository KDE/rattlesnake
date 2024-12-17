// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#ifndef NOTE_H
#define NOTE_H

#include <QObject>
#include <QUrl>

class Note : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl soundFile READ soundFile NOTIFY soundFileChanged)
    Q_PROPERTY(int sound READ sound WRITE setSound NOTIFY soundChanged)
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)

public:
    explicit Note(QObject *parent = nullptr);

    int sound() const;
    void setSound(const int sound);
    Q_SIGNAL void soundChanged();

    QUrl soundFile() const;
    void setSoundFile(const QUrl &soundFile);
    Q_SIGNAL void soundFileChanged();

    int volume() const;
    void setVolume(int volume);
    Q_SIGNAL void volumeChanged();

private:
    int m_sound;
    int m_volume;
    QUrl m_soundFile;
};

#endif // NOTE_H
