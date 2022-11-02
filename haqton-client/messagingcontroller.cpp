#include "messagingcontroller.h"

#include <QtQml>

Q_LOGGING_CATEGORY(messagingcontroller, "haqton.messagingcontroller")

MessagingController::MessagingController(QObject *parent) :
    QObject(parent),
    _zeroMQSubscriberThread(QStringLiteral("%1:5560").arg(_ZMQSERVERURL))
{
    connect(&_zeroMQSubscriberThread, &ZeroMQSubscriberThread::newMessage,
            this, &MessagingController::newMessage);
    connectToZeroMQProxy();
    qmlRegisterInterface<MessagingController>("MessagingController", 1);
}

void MessagingController::setTopic(QString topic)
{
    _zeroMQSubscriberThread.setTopic(topic);
}

void MessagingController::connectToZeroMQProxy()
{
    _zeroMQSubscriberThread.start();
}
