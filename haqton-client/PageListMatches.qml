import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import haqton 1.0
import "HaqtonStyle"
Item {

    property var matchList: Core.requestController.context.matchList
    property var playersList: Core.requestController.context.playersList
    //
    property var selectedMatchData;

    onPlayersListChanged: {
        console.log("CHEGOU")
        if(typeof playersList !== "undefined"){ //TODO check this
            console.log("POP 7")
            stackView.pop()
            console.log("PUSH")
            stackView.push("PageApprovalCompetitor_Competitor.qml", { matchData: selectedMatchData,
                               competitorData: playersList[playersList.length-1]})
        }
        console.log("TERMINOU")
    }

    Rectangle{
        color: "#4cd5a9"; anchors.fill: parent;
        Image {
            anchors.centerIn: parent
            opacity: 0.6
            source: "assets/images/background_menu.png"
            fillMode: Image.PreserveAspectFit
            sourceSize.height: parent.height
        }
    }

    ColumnLayout{
        anchors.fill: parent
        Layout.alignment: Qt.AlignHCenter
        Layout.margins: HaqtonStyle.mediumMargin

        ListView {
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            Layout.margins: HaqtonStyle.mediumMargin
            Layout.bottomMargin: HaqtonStyle.smallMargin
            spacing: HaqtonStyle.smallMargin
            clip: true
            model: matchList
            delegate: matchDelegate
        }

        GameButton{
            Layout.fillWidth: true;
            Layout.leftMargin: HaqtonStyle.largeMargin
            Layout.rightMargin: HaqtonStyle.largeMargin
            text: "VOLTAR"
            size: HaqtonStyle.buttonSizeS
            state: HaqtonStyle.buttonWhite
            textColor: "#34a796"
            onClicked: {
                console.log("POP 7")
                stackView.pop()
            }
        }

        Text {
            id: messageStatus
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true;
            Layout.bottomMargin: HaqtonStyle.smallMargin
            text: qsTr("Select match.")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            color: "#ffffff"
        }
    }


    Component {
        id: matchDelegate

        Rectangle {
            color: mouseArea.containsMouse ? "#ffffff":"#ccffffff"
            width: ListView.view.width
            height: titleElement.implicitHeight + subTitleElement.implicitHeight + HaqtonStyle.largeMargin
            radius : 5
            ColumnLayout{
                anchors{
                    fill: parent
                    leftMargin: HaqtonStyle.mediumMargin
                    rightMargin: HaqtonStyle.mediumMargin
                    verticalCenter: parent.verticalCenter
                }
                spacing: 0

                Item {Layout.fillHeight: true}

                Label {
                    id: titleElement
                    Layout.fillWidth: true
                    text: "<b> "+ modelData.creator_name + "</b>"
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                    font { family: gameFontText.name;}
                    color: "#303030"
                }

                Label {
                    id: subTitleElement
                    Layout.fillWidth: true
                    text: "<i>Description:</i>  " + modelData.description || ""
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                    font { family: gameFontText.name;}
                    color: "#303030"
                }
                Item {Layout.fillHeight: true}
            }


            MouseArea{
                id: mouseArea
                anchors.fill: parent;
                cursorShape: Qt.PointingHandCursor;
                onClicked: {
                    selectedMatchData = { "id": modelData.id,
                        "topic": modelData.topic,
                        "description": modelData.description
                    }
                    Core.requestController.post("matches/"+ modelData.id + "/players", {   "nickname": settings.competitorNickname,
                                                    "email": settings.competitorEmail}, "playersList")
                }
                hoverEnabled: true
            }

        }
    }

    Connections{
        target: Core.messagingController
        function onNewMessage(message){
            var jmessage = JSON.parse(message)
            if(jmessage.message === "matches_update"){
                matchList = jmessage.data//.reverse()
            }
        }
    }

    StackView.onActivated: {
        Core.messagingController.setTopic("matches");
        Core.requestController.get("matches","matchList")
        window.headerTitle = "Matches List"
        window.headerColor = "#34a796"
    }
}
