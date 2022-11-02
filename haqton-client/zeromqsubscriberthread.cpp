#include "zeromqsubscriberthread.h"

#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(messagingcontroller)

ZeroMQSubscriberThread::ZeroMQSubscriberThread(QString url, QObject *parent)
    : QThread(parent),
      _url(std::move(url)),
      _context(1),
      _subscriber(_context, ZMQ_SUB)
{
}

void ZeroMQSubscriberThread::run()
{
    qDebug() << "Subscribing to" << _url;
    _subscriber.connect(_url.toStdString());

    qCDebug(messagingcontroller) << "Starting subscriber thread";
    while(true)
    {
        //  Wait for next request from client
        std::string topic = s_recv(_subscriber);
        std::string string = s_recv(_subscriber);
        Q_EMIT newMessage(QString::fromStdString(string));
    }
}

void ZeroMQSubscriberThread::setTopic(QString topic)
{
    if (!_topic.isEmpty()) {
        _subscriber.setsockopt(ZMQ_UNSUBSCRIBE, _topic.toStdString().c_str(), _topic.toStdString().size());
    }
    _topic = std::move(topic);
    _subscriber.setsockopt(ZMQ_SUBSCRIBE, _topic.toStdString().c_str(), _topic.toStdString().size());
    qCDebug(messagingcontroller) << "Subscriber topic changed to" << _topic;
}
