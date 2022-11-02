#ifndef ZEROMQSUBSCRIBERTHREAD_H
#define ZEROMQSUBSCRIBERTHREAD_H

#include <QThread>

#include "zhelpers.h"

class ZeroMQSubscriberThread : public QThread
{
    Q_OBJECT

public:
    ZeroMQSubscriberThread(QString url, QObject *parent = nullptr);

    void run() Q_DECL_OVERRIDE;
    void setTopic(QString topic);

Q_SIGNALS:
    void newMessage(const QString &message);

private:
    QString _url;
    QString _topic;
    zmq::context_t _context;
    zmq::socket_t _subscriber;
};

#endif // ZEROMQSUBSCRIBERTHREAD_H
