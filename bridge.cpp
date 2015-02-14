#include "bridge.h"
#include "ticker.h"

Bridge::Bridge(QObject *parent) :
    QObject(parent)
{
    m_bTickerShutdown = false;
}

void Bridge::setTickInterval(const int seconds)
{
    if (m_ticker && seconds >= 0)
    {
        m_ticker->setTickInterval(seconds);
    }
}

void Bridge::killTicker()
{
    if (m_ticker)
    {
        // Set ticker to stop.
        m_ticker->setTickInterval(-1);
    }
}

void Bridge::setTicker(Ticker* ticker)
{
    m_ticker = ticker;
}

void Bridge::tick()
{
    emit doWork();
}

void Bridge::tickerStopped()
{
    m_bTickerShutdown = true;
}
