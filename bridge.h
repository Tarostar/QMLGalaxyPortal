/* Bridge Class
 *
 * QML cannot be be connected to a class running on a different thread,
 * so this class bridges QML and the ticker thread.
 *
 */

#ifndef BRIDGE_H
#define BRIDGE_H

class Ticker;
#include <QObject>

class Bridge : public QObject
{
    Q_OBJECT

public:
    explicit Bridge(QObject *parent = 0);
    void setTicker(Ticker* ticker);

private:
    Ticker *    m_ticker;
    bool        m_bTickerShutdown;

signals:
    // void countChanged();
    void doWork();

public slots:
    void setTickInterval(const int seconds);
    void tick();
    void killTicker();
    void tickerStopped();

};

#endif // BRIDGE_H
