#ifndef METRONOME_H
#define METRONOME_H

#include <QObject>
#include <QTimer>
#include <QMediaPlayer>

#include "note.h"

class Metronome : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int bpm READ bpm WRITE setBpm NOTIFY bpmChanged)
    Q_PROPERTY(QVector<Note*> notes READ notes NOTIFY notesChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)

public:
    enum Sounds {
        Click,
        HighHead,
        Snare
    };

    Q_ENUM(Sounds)

    explicit Metronome(QObject *parent = nullptr);

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();

    int bpm() const;
    void setBpm(int bpm);
    Q_SIGNAL void bpmChanged();

    QVector<Note *> notes() const;
    Q_SIGNAL void notesChanged();

    Q_INVOKABLE void addNote(const Sounds sound);
    Q_INVOKABLE void removeNote(const int index);

    Q_SIGNAL void hit();
    Q_SLOT void playHitSound();

    int currentIndex() const;
    void setCurrentIndex(int curentIndex);
    Q_SIGNAL void currentIndexChanged();

private:
    int m_bpm;
    QTimer m_hitTimer;
    QMediaPlayer m_mediaPlayer;
    QVector<Note*> m_notes;
    int m_hitCount = 0;
    int m_currentIndex = 0;
};

#endif // METRONOME_H
