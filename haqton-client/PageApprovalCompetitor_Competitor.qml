import QtQuick 2.12
import QtQuick.Controls 2.5
import haqton 1.0
import QtQuick.Layouts 1.15
import "HaqtonStyle"
import "FontAwesome"
Item {

    property var playersList: Core.requestController.context.playersList
    property var playerUpdated: Core.requestController.context.playerUpdate
    property var matchData;
    property var competitorData


    onPlayerUpdatedChanged: {
        console.log("POP 1")
//        stackView.pop() // The player left the game
    }

    Rectangle{ color: "#f6f6f6"; anchors.fill: parent;}

    ColumnLayout{
        anchors.fill: parent
        Layout.alignment: Qt.AlignHCenter;
        Layout.margins: HaqtonStyle.mediumMargin

        Label{ // match description
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; Layout.topMargin: HaqtonStyle.mediumMargin; Layout.bottomMargin:  0;
            text: matchData.description
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            color: "#505050"
            wrapMode: Text.WordWrap
        }

        ListView { // list of players
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.margins: HaqtonStyle.mediumMargin;
            spacing: HaqtonStyle.smallMargin
            clip: true
            model: playersList
            delegate: competitorDelegate
        }

        GameButton{ // button to exit the game
            Layout.fillWidth: true;
            Layout.margins: HaqtonStyle.largeMargin
            size: HaqtonStyle.buttonSizeS
            text: "BACK TO MENU"
            state: HaqtonStyle.buttonWhite
            textColor: "#9b59b6"
            onClicked: dialogQuitMatch.open()
        }

        Text { // messageStatus
            Layout.alignment: Qt.AlignHCenter; Layout.fillWidth: true; Layout.bottomMargin: HaqtonStyle.smallMargin;
            text: qsTr("Please wait for creator to start the game!")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 13
            color: "#404040"
        }

    }


    Component {
        id: competitorDelegate
        Rectangle {
            radius: 5
            color: index % 2 ?  "#e6d3ec" : "#ffffff"
            width: ListView.view.width
            height: textNome.implicitHeight*2 + HaqtonStyle.mediumMargin
            RowLayout{
                anchors{
                    fill: parent
                    leftMargin: HaqtonStyle.mediumMargin
                    rightMargin: HaqtonStyle.mediumMargin
                    verticalCenter: parent.verticalCenter
                }
                Label {
                    id: textNome
                    Layout.fillWidth: true;
                    text: modelData.player_name
                    font { family: gameFontText.name; pixelSize: 15;}
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignLeft
                }
                Image {
                    id: button
                    fillMode: Image.PreserveAspectFit
                    source: modelData.approved ? "assets/images/check-svgrepo-com.png" : "assets/images/three-dots-svgrepo-com.png"
                    sourceSize.width: textNome.implicitHeight * 1.5
                }

            }
        }
    }

    DialogCustom {
        id: dialogQuitMatch
        textTitle: "Message"
        textMessage:  "Do you really want to leave the match?"
        onAccepted: Core.requestController.put("matches/"+matchData.id+"/players/"+competitorData.id,{ "approved": false}, "playerUpdate")
        onRejected: dialogQuitMatch.close()
    }

    Connections{
        target: Core.messagingController

        function onNewMessage(message){
            var jmessage = JSON.parse(message)
            if(jmessage.message === "players_update"){
                playersList = jmessage.data
                if(!playersList.some( element => element.id === competitorData.id)){
                    console.log("POP 2")
                    stackView.pop()
                }
                return
            }
            if(jmessage.message === "new_question"){
                console.log("POP 3")
                stackView.pop()
                stackView.push("PageMatch.qml", {isCreator: false, competitorData: competitorData, matchData: matchData, randomQuestion: jmessage.data , playersList: playersList})
                return
            }
        }
    }
    StackView.onActivated: {
        Core.messagingController.setTopic(matchData.topic);

        window.headerTitle = "Match participants"
        window.headerColor = "#8e44ad"

    }

}


