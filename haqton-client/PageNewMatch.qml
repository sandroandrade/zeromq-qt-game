import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import haqton 1.0
import "HaqtonStyle"
Item {

    id: root
    property var matchInformation: Core.requestController.context.matchInformation || undefined

    signal newMatch(variant competitorData)

    onVisibleChanged:{
        if(visible){ gameDescription.text = ''}
    }

    onMatchInformationChanged: {
        if(typeof matchInformation !== "undefined" && matchInformation !== 'null' ){
            root.newMatch( matchInformation.match_players[0])
        }
    }

    ColumnLayout{
        anchors.fill: parent
        Layout.alignment: Qt.AlignHCenter
        Layout.margins: HaqtonStyle.mediumMargin


        Label {
            text: qsTr("NEW MATCH");
            Layout.alignment: Qt.AlignHCenter;
            color: "#202020"
            font { family: gameFontText.name; pixelSize: 18; bold: true;}

        }
        Label {
            text: "Enter game description";
            Layout.alignment: Qt.AlignHCenter;
            font {
                family: gameFontText.name;
                pixelSize: 15
            }

        }
        TextFieldCustom {
            id: gameDescription;
            text: 'test';
            Layout.fillWidth: true;
            Layout.alignment: Qt.AlignHCenter;
            Layout.margins: 10
            horizontalAlignment: TextInput.AlignHCenter
            onTextChanged: gameDescription.accepted()
        }

        RowLayout{
            Layout.fillWidth: true;
            Layout.alignment: Qt.AlignHCenter;
            GameButton{
                text: "CANCEL"
                size: HaqtonStyle.buttonSizeS
                state: HaqtonStyle.buttonYellow
                textColor: "#ffffff"
                onClicked: popupNewMatch.close()
                Layout.minimumWidth: 120
            }

            GameButton{
                text: "CREATE"
                size: HaqtonStyle.buttonSizeS
                state:   (gameDescription.length !== 0 ) ? HaqtonStyle.buttonGreen : HaqtonStyle.buttonGrey
                enabled: (gameDescription.length !== 0 )
                textColor: gameDescription.length !== 0 ? "#ffffff" : "#909090"
                onClicked: {
                    Core.requestController.post("matches",
                                                {   "description": gameDescription.text,
                                                    "nickname": settings.competitorNickname,
                                                    "email": settings.competitorEmail
                                                }, "matchInformation")
                }
                Layout.minimumWidth: 120
            }
        }
    }
}



