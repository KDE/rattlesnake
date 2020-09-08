#include "metronome.h"

#include <QDebug>

Metronome::Metronome(QObject *parent)
    : QObject(parent)
{
    m_hitTimer.setSingleShot(false);
    setBpm(120);

    connect(&m_hitTimer, &QTimer::timeout, this, &Metronome::hit);
    connect(&m_hitTimer, &QTimer::timeout, this, &Metronome::playHitSound);
    connect(&m_hitTimer, &QTimer::timeout, this, [=] {
        m_hitCount++;
    });

    addNote(Sounds::Click);
}

int Metronome::bpm() const
{
    return m_bpm;
}

void Metronome::setBpm(int bpm)
{
    m_bpm = bpm;
    Q_EMIT bpmChanged();

    const int intervalMsecs = (60 / double(m_bpm)) * 1000;
    m_hitTimer.setInterval(int(intervalMsecs));
}

void Metronome::playHitSound()
{
    const int i = m_hitCount % m_notes.size();

    // To display it in the gui
    setCurrentIndex(i);

    qDebug() << "Sound index" << i << m_notes.at(i)->soundFile();
    m_mediaPlayer.setMedia(m_notes.at(i)->soundFile());
    m_mediaPlayer.setVolume(m_notes.at(i)->volume());

    m_mediaPlayer.play();
    m_mediaPlayer.setPosition(0);
}

int Metronome::currentIndex() const
{
    return m_currentIndex;
}

void Metronome::setCurrentIndex(int curentIndex)
{
    qDebug() << "Current index" << currentIndex();
    m_currentIndex = curentIndex;
    Q_EMIT currentIndexChanged();
}

QVector<Note*> Metronome::notes() const
{
    return m_notes;
}

void Metronome::addNote(const Sounds sound)
{
    auto *note = new Note(this);
    note->setSound(sound);
    m_notes.push_back(note);
    Q_EMIT notesChanged();
}

void Metronome::removeNote(const int index)
{
    if (index < 1) {
        return;
    }
    m_notes.removeAt(index);
    Q_EMIT notesChanged();
}

void Metronome::start()
{
    m_hitTimer.start();
}

void Metronome::stop()
{
    m_hitTimer.stop();
}
