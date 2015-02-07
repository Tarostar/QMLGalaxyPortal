/* Bridge Class
 *
 * QML cannot be be connected to a class running on a different thread,
 * so this class bridges QML and the ticker thread.
 *
 */

#ifndef BRIDGE_H
#define BRIDGE_H

#include <QObject>
#include <QMediaPlayer>

class Bridge : public QObject
{
    Q_OBJECT
    // Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)

public:
    explicit Bridge(QObject *parent = 0);

private:
    int m_tickInterval; // seconds, zero is disabled
    // int m_count;
    // QMediaPlayer * m_player;

/*public:
    void setCount(const int i);
    int count() const;*/

signals:
    // void countChanged();
    void doWork();

public slots:
    void setTickInterval(const int seconds);
    int getTickInterval();
    void tick();

};

#endif // BRIDGE_H
