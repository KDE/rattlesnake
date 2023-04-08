// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

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

    if (m_tapCounter == 3) {
        m_tapCounter = 0;
        Q_EMIT tapCounterChanged();

        qDebug() << "recording data";
        m_times.push_back(m_tapTimer.elapsed());

        Q_ASSERT(m_times.size() == 3);

        int average = std::accumulate(m_times.begin(), m_times.end(), 0) / m_times.size();
        m_bpm = 60000 / average;
        Q_EMIT bpmChanged();

        m_times.clear();

        Q_EMIT tapStopped();
        return;
    }

    if (m_tapCounter == 0) {
        qDebug() << "Restart";
        m_tapTimer.restart();
        m_tapCounter++;
        Q_EMIT tapCounterChanged();

        return;
    }

    if (m_tapTimer.elapsed() != 0 && m_tapCounter < 3) {
        qDebug() << "recording data";
        m_times.push_back(m_tapTimer.elapsed());
        m_tapCounter++;
        Q_EMIT tapCounterChanged();
    }

    m_tapTimer.restart();
}

int TapIn::bpm() const
{
    return m_bpm;
}

int TapIn::tapCounter() const
{
    return m_tapCounter;
}
