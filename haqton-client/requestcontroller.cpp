#include "requestcontroller.h"
#include <QtQml>

Q_LOGGING_CATEGORY(requestcontroller, "haqton.requestcontroller")

RESTReply::RESTReply(QNetworkReply *networkReply)
{
    connect(networkReply, &::QNetworkReply::finished, this, [=] () {
        QJsonDocument jsonDocument = QJsonDocument::fromJson(networkReply->readAll());
        qDebug() << jsonDocument.toJson();
        if (jsonDocument.isObject()) {
            if (jsonDocument.object().value("error").isString())
                Q_EMIT errorStringChanged(jsonDocument.object().value("error").toString());
            else
                Q_EMIT finished(QJsonValue(jsonDocument.object()));
        }
        else if (jsonDocument.isArray())
            Q_EMIT finished(QJsonValue(jsonDocument.array()));
        else
            Q_EMIT finished(QJsonValue{});
        networkReply->deleteLater();
    });

    connect(networkReply, &::QNetworkReply::errorOccurred, this, [=] () {
        Q_EMIT errorStringChanged("Ops, ocorreu um erro...");
        networkReply->deleteLater();
    });


}

RequestController::RequestController(QObject *parent) :
    QObject(parent){
    qmlRegisterInterface<RequestController>("RequestController", 1);
    setStatus(Status::READY);
}

void RequestController::setErrorString(const QString &errorString)
{
    _errorString = errorString;
    Q_EMIT errorStringChanged(_errorString);
}
void RequestController::setStatus(RequestController::Status status)
{
    if (_status != status) {
        _status = status;
        Q_EMIT statusChanged(_status);
    }
}
QString RequestController::errorString() const
{
    return _errorString;
}
RequestController::Status RequestController::status() const
{
    return _status;
}
QQmlPropertyMap *RequestController::context()
{
    return &_qmlPropertyMap;
}

RESTReply *RequestController::request(const QString &url, RequestType requestType, const QJsonValue &jsonValue)
{
    _errorString.clear();
    _request.setUrl(QUrl(url));
    _request.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/x-www-form-urlencoded"));
    _request.setRawHeader(QByteArray("Authorization"), QByteArray("Bearer eyJhbGciOiJSUzI1NiJ9.eyJleHAiOjE2MDU5MzQ3ODcsImlhdCI6MTYwMjA0Njc4NywiaXNzIjoiUW1vYiBTb2x1dGlvbnMiLCJ1c2VyIjp7InVzZXJuYW1lIjoibWFyY29zdGVqYWRhY0BnbWFpbC5jb20ifX0.l7tx6XvzHinoRTHwXQr_nnM3Mis9fzSn7B2uK_BUxBknrQXZcOVmkt9ArKTm-7PTxrk3V9JNDgcj889UFXrpGdjKuiq6WQ4qje7xBHOWvvZ-vmSRUrnAMHvvRVjtBquvls9CrndTonQbQvLUCgcT7_pm4XI3rX9fXtNy_92T3HdZs-knGLfq1E19HWk_soIlkX9e0hkCqZYb6A5pfRqC_aXxREkQkImE1y7chWqt-sc5qZos9lfJww8WzBVWBd9_oUmZSupaq7ep8rqHtuNSOiMguzBNUl4jH08JaPDUm0B2jGDENaHaZ5U-4Tgq8nuvlCKWqXuDDEUyv0V5KTNfJqNkueMWAU36_wWgHQfBCznZNrgVBbe-NulngY9FeWz1ehG6yjVGIoKnwiFMqIU9IZAcVdG7QfHqGor2EezuogXmRrfINPQwJR4CkD-36Gi4RiaBYxZ3p33rbM2JyuJc4y_ktdt91lJ7yqUqIWXasx8QDYgKhgF0xr5ob5uLGkqu98oUJEWspdGuoZMGU668dbvbSH4hfJa8nAUH4cnGUQ0apdtKhNIFI6CJLb7ZuEg9PagN4_dx7GTa_Rg8Qmq4TePFpnX7MjkkN-6WexsXJFib-np5ZD71pQ_8QlAAPMwsFD3X_eF8Rwcr1BF3Smt6d3Je3KH_KIif015Ironq-Kw"));

    QNetworkReply *networkReply = nullptr;
    setStatus(Status::LOADING);
    if (requestType == RequestType::GET) {
        networkReply = _networkAccessManager.get(_request);
    } else if (requestType == RequestType::DELETE) {
        networkReply = _networkAccessManager.deleteResource(_request);
    } else {
        if (!jsonValue.isObject()) {
            qDebug() << "Error no request: jsonValue deve ser um objeto!";
            return nullptr;
        }
        if (requestType == RequestType::POST) {
            networkReply = _networkAccessManager.post(_request, QJsonDocument(jsonValue.toObject()).toJson());
        } else if (requestType == RequestType::PUT) {
            networkReply = _networkAccessManager.put(_request, QJsonDocument(jsonValue.toObject()).toJson());
        }
    }

    auto restReply = new RESTReply(networkReply);
    connect(restReply, &RESTReply::finished, this, [=](){
        setStatus(Status::READY);
    });

    connect(restReply, &RESTReply::errorStringChanged, this, [=](const QString &errorString){
        setErrorString(errorString);
        setStatus(Status::READY);
    });
    return restReply;
}

void RequestController::get(const QString &endpoint, const QString &resourceName)
{
    auto reply = request(QString("%1/%2").arg(_RESTFULSERVERURL).arg(endpoint));
    connect(reply, &RESTReply::finished, this, [=](const QJsonValue &jsonValue) {
        reply->deleteLater();
        if (!resourceName.isEmpty())
            _qmlPropertyMap.insert(resourceName, jsonValue);
    });
}
void RequestController::post(const QString &endpoint, const QJsonObject &resourceData, const QString &resourceName)
{
    auto *reply = request(QString("%1/%2").arg(_RESTFULSERVERURL).arg(endpoint), RequestType::POST, resourceData);
    connect(reply, &RESTReply::finished, this, [=](const QJsonValue &jsonValue) {
        reply->deleteLater();

        if (!resourceName.isEmpty())
            _qmlPropertyMap.insert(resourceName, jsonValue);
    });
}

void RequestController::put(const QString &endpoint, const QJsonObject &resourceData, const QString &resourceName)
{
    auto *reply = request(QString("%1/%2").arg(_RESTFULSERVERURL).arg(endpoint), RequestType::PUT, resourceData);
    connect(reply, &RESTReply::finished, this, [=](const QJsonValue &jsonValue) {
        reply->deleteLater();
        if (!resourceName.isEmpty())
            _qmlPropertyMap.insert(resourceName, jsonValue);
    });
}

void RequestController::del(const QString &endpoint, const QString &resourceName)
{
    auto reply = request(QString("%1/%2").arg(_RESTFULSERVERURL).arg(endpoint), RequestType::DELETE);
    connect(reply, &RESTReply::finished, this, [=](const QJsonValue &jsonValue) {
        reply->deleteLater();
        if (!resourceName.isEmpty())
            _qmlPropertyMap.insert(resourceName, jsonValue);
    });
}
