#include "core.h"

#include "messagingcontroller.h"
#include "requestcontroller.h"

Q_LOGGING_CATEGORY(core, "haqton.core")

Core *Core::_instance = nullptr;

Core::Core(QObject *parent)
    : QObject(parent),
      _messagingController(new MessagingController(this)),
      _requestController(new RequestController(this))
{
}

Core::~Core()
{
    delete _messagingController;
    delete _requestController;
}

Core *Core::instance()
{
    if (!_instance) {
        _instance = new Core;
    }
    return _instance;
}

MessagingController *Core::messagingController() const
{
    return _messagingController;
}
RequestController *Core::requestController() const
{
    return _requestController;
}
