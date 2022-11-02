#ifndef REQUESTCONTROLLER_H
#define REQUESTCONTROLLER_H

#include <QJsonArray>
#include <QJsonObject>
#include <QQmlPropertyMap>
#include <QNetworkAccessManager>
#include <QLoggingCategory>
#include <QObject>

class RESTReply : public QObject
{
    Q_OBJECT
public:
    explicit RESTReply(QNetworkReply *networkReply);

Q_SIGNALS:
    void finished(const QJsonValue &jsonValue);
    void errorStringChanged(const QString &errorString);
};


class RequestController: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorStringChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QQmlPropertyMap * context READ context CONSTANT)

public:
    explicit RequestController(QObject *parent = nullptr);
    ~RequestController() Q_DECL_OVERRIDE = default;

    Q_INVOKABLE void get(const QString &endpoint, const QString &resourceName = QStringLiteral(""));
    Q_INVOKABLE void post(const QString &endpoint, const QJsonObject &resourceData, const QString &resourceName = QStringLiteral(""));
    Q_INVOKABLE void put(const QString &endpoint, const QJsonObject &resourceData, const QString &resourceName = QStringLiteral(""));
    Q_INVOKABLE void del(const QString &endpoint, const QString &resourceName = QStringLiteral(""));

    enum class Status { LOADING = 0, READY};
    Q_ENUM(Status)
    Status status() const;
    QString errorString() const;
    QQmlPropertyMap *context();

Q_SIGNALS:
    void errorStringChanged(const QString &errorString);
    void statusChanged(RequestController::Status);
private:

    QString _RESTFULSERVERURL = QStringLiteral("http://localhost:4001");
    enum class RequestType { GET = 0, POST, PUT, DELETE };
    RESTReply *request(const QString &url, RequestType requestType = RequestType::GET, const QJsonValue &jsonValue = QJsonValue{});
    void setStatus(Status status);
    void setErrorString(const QString &errorString);
    QNetworkAccessManager _networkAccessManager;
    QNetworkRequest _request;
    QQmlPropertyMap _qmlPropertyMap;
    QString _errorString;
    Status _status ;

};

#endif // REQUESTCONTROLLER_H
