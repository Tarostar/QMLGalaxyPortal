#include "ticker.h"
#include <chrono>
#include <thread>

Ticker::Ticker(QObject *parent) :
    QObject(parent)
{
    m_tickInterval = 0;
}

void Ticker::mainThread()
{
    int secondsCounter = 0;

    // Loops every SLEEP_INTERVAL and checks if the tickInterval has elapsed (zero means disabled).
    while(true)
    {
        if (m_tickInterval > 0 && secondsCounter >= m_tickInterval)
        {
            secondsCounter = 0;
            emit tick();
        }

        std::this_thread::sleep_for(std::chrono::seconds(sleep_interval));

        if (m_tickInterval < 0)
        {
            // Time to die.
            break;
        }

        // Interval can have changed, so ensure counter stays at zero if tick interval is set to zero.
        if (m_tickInterval == 0)
        {
            secondsCounter = 0;
        }
        else
        {
            secondsCounter += sleep_interval;
        }
    }

    // Terminate thread - cleanup handled by aboutToQuit signal.
}

void Ticker::setTickInterval(int interval)
{
    // This should only ever be set here, and only by the event thread (otherwise we need to start using mutex and so on).
    m_tickInterval = interval;
}
