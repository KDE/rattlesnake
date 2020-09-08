#ifndef TAPIN_H
#define TAPIN_H

#include <QObject>
#include <QElapsedTimer>


class TapIn : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int bpm READ bpm WRITE setBpm NOTIFY bpmChanged)

public:
    explicit TapIn(QObject *parent = nullptr);

    Q_INVOKABLE void tap();

    Q_SIGNAL void tapStopped();

    int bpm() const;
    void setBpm(int bpm);
    Q_SIGNAL void bpmChanged();

private:
    QElapsedTimer m_tapTimer;
    QVector<long long> m_times;
    int m_tapCounter = 0;
    int m_bpm = 0;
};


#endif // TAPIN_H
