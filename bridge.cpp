#include "bridge.h"
#include <QDebug>


Bridge::Bridge(QObject *parent) :
    QObject(parent)
{
    //m_player = new QMediaPlayer;
    m_tickInterval = 0;
}

void Bridge::setTickInterval(const int seconds)
{
    if (seconds < 0)
    {
        m_tickInterval = 0;
    }
    else
    {
        m_tickInterval = seconds;
    }

}

int Bridge::getTickInterval()
{
    return m_tickInterval;
}

void Bridge::tick()
{
    emit doWork();

    /*m_count++;
    qDebug("tick:" + QString::number(m_count).toLatin1());
    emit countChanged();*/


   /* m_player->setMedia(QUrl("qrc:/resources/resources/sounds/ping.mp3"));
    m_player->setVolume(50);
    m_player->play();*/
}

/*
void Bridge::setCount(const int i) {
    if (i != m_count) {
        m_count = i;
        emit countChanged();
    }
}

int Bridge::count() const {
    qDebug("count me");
    return m_count;
}
*/
