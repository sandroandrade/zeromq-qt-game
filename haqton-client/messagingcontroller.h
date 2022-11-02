#ifndef MESSAGINGCONTROLLER_H_
#define MESSAGINGCONTROLLER_H_

#include <QLoggingCategory>
#include <QObject>

#include "zeromqsubscriberthread.h"

class MessagingController : public QObject
{
    Q_OBJECT

public:
    MessagingController(QObject *parent = nullptr);
    ~MessagingController() Q_DECL_OVERRIDE = default;

Q_INVOKABLE void setTopic(QString topic);

Q_SIGNALS:
    void newMessage(const QString &message);

private:
    QString _ZMQSERVERURL = QStringLiteral("tcp://localhost");

    void connectToZeroMQProxy();

    ZeroMQSubscriberThread _zeroMQSubscriberThread;
};

#endif	// MESSAGINGCONTROLLER_H_
