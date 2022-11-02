import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import haqton 1.0
import "HaqtonStyle"
Popup{
    anchors.centerIn: Overlay.overlay
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    padding: HaqtonStyle.mediumMargin
    visible:  Core.requestController.errorString !== ""
    ColumnLayout {
        anchors.fill: parent
        spacing: HaqtonStyle.mediumMargin
        Label{
            text: "Message"
            wrapMode: Text.Wrap
            Layout.alignment: Qt.AlignHCenter;
            font {
                family: gameFontText.name;
                pixelSize: 18
            }
        }

        Label{
            text: Core.requestController.errorString
            wrapMode: Text.Wrap
            font {
                family: gameFontText.name;
                pixelSize: 18
            }
            color: "#aaaaaa"
        }

        GameButton{
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: HaqtonStyle.largeMargin * 3
            text: "Ok"
            size: HaqtonStyle.buttonSizeS
            state: HaqtonStyle.buttonGreen
            textColor: "#ffffff"
            onClicked: { errorNotification.close() }
        }
    }
}
