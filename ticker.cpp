#include "ticker.h"
#include <chrono>
#include <thread>
#include <QDebug>

Ticker::Ticker(QObject *parent) :
    QObject(parent)
{
}

void Ticker::mainThread()
{
    int secondsCounter = 0;
    int tickInterval = 0;

    // Loops every SLEEP_INTERVAL and checks if the tickInterval has elapsed (zero means disabled).
    while(true)
    {
        if (tickInterval > 0 && secondsCounter >= tickInterval)
        {
            secondsCounter = 0;
            emit tick();
        }

        std::this_thread::sleep_for(std::chrono::seconds(sleep_interval));

        // Update the tickInerval.
        tickInterval = emit getTickInterval();

        // Interval can have changed, so ensure counter stays at zero if tick interval is set to zero.
        if (tickInterval == 0)
        {
            secondsCounter = 0;
        }
        else
        {
            secondsCounter += sleep_interval;
        }

        // qDebug("Count: " + QString::number(secondsCounter).toLatin1() + " / " + QString::number(tickInterval).toLatin1());
    }

    // Terminate thread and signal for any cleanup.
    emit finished();
}
