#include "tapin.h"

#include <QDebug>

#include <algorithm>

TapIn::TapIn(QObject *parent) : QObject(parent)
{
}

void TapIn::tap()
{
    qDebug() << "List" << m_times;
    qDebug() << "Counter" << m_tapCounter;

    if (m_tapCounter == 4) {
        m_tapCounter = 0;

        int average = std::accumulate(m_times.begin(), m_times.end(), 0) / m_times.size();
        m_bpm = 60000 / average;
        Q_EMIT bpmChanged();

        m_times.clear();

        Q_EMIT tapStopped();
    }

    if (m_tapCounter == 0) {
        qDebug() << "Restart";
        m_tapTimer.restart();
        m_tapCounter++;
        return;
    }

    if (m_tapTimer.elapsed() != 0 && m_tapCounter < 4) {
        qDebug() << "recording data";
        m_times.push_back(m_tapTimer.elapsed());
        m_tapCounter++;
    }

    m_tapTimer.restart();
}

int TapIn::bpm() const
{
    return m_bpm;
}

void TapIn::setBpm(int bpm)
{
    m_bpm = bpm;
}
