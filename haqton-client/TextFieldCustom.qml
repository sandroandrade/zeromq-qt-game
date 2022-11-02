import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: control

    font { family: gameFontText.name;}

    inputMethodHints: Qt.ImhNoPredictiveText
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        color: control.enabled ? "#ccffffff" : "#353637"
        border.color: control.enabled ? "#41CD52" : "transparent"
        radius: 5
    }

}
