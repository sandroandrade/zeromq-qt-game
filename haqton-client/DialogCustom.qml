import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.1
import "FontAwesome"
import "HaqtonStyle"

Dialog {
    id: control
    x: Math.round((window.width - width) / 2)
    y: Math.round(window.height / 6)
    width: Math.round(Math.min(window.width, window.height) / 3 * 2)
    modal: true
    focus: true

    property alias textTitle: textTitle.text
    property alias textMessage: textMessage.text

    contentItem: ColumnLayout {
        id: columnSettings
        spacing: HaqtonStyle.largeMargin

        Label{
            id: textTitle
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            font { family: gameFontText.name; pixelSize: 18; bold: true;}
        }

        Label{
            id: textMessage
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            font { family: gameFontText.name; pixelSize: 14;}
        }

        RowLayout {
            spacing: HaqtonStyle.mediumMargin
            //width: parent.width
            Layout.fillWidth: true

            GameButton{
                Layout.fillWidth: true;
                text: "Cancel"
                state: HaqtonStyle.buttonYellow
                textColor: "#ffffff"
                size: HaqtonStyle.buttonSizeS
                onClicked: control.rejected()
            }
            GameButton{
                Layout.fillWidth: true;
                text: "Accept"
                state: HaqtonStyle.buttonGreen
                textColor: "#ffffff"
                size: HaqtonStyle.buttonSizeS
                onClicked: control.accepted()
            }

        }
    }
}
