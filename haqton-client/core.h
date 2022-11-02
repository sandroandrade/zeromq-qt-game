#ifndef CORE_H_
#define CORE_H_

#include <QObject>

class MessagingController;
class RequestController;

class Core : public QObject
{
    Q_OBJECT
    Q_PROPERTY(MessagingController * messagingController READ messagingController CONSTANT)
    Q_PROPERTY(RequestController * requestController READ requestController CONSTANT)

public:
    ~Core() Q_DECL_OVERRIDE;

    static Core *instance();

    MessagingController *messagingController() const;
    RequestController *requestController() const;

private:
    explicit Core(QObject *parent = nullptr);

    static Core *_instance;
    MessagingController *_messagingController;
    RequestController *_requestController;
};

#endif	// CORE_H_
