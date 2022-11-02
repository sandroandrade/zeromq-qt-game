import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import haqton 1.0

Popup {
    id: control
    visible: Core.requestController.status !== 1// Todo: fix enumeration 2 levels (Core.requestController.READY)
    anchors.centerIn: Overlay.overlay

    background: Rectangle {
                anchors.fill: parent
                color: "transparent"
        }
    //ColumnLayout {
        Image {
            id: backgroundImage
            Layout.alignment: Qt.AlignHCenter;
            //anchors.centerIn: parent
            source: "assets/images/carregando.png"
            fillMode: Image.PreserveAspectFit
            sourceSize.height: window.width * 0.9 > 512 ? 450 : window.width * 0.9
        }
    //}
}
