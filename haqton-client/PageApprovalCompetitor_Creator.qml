import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.15
import haqton 1.0
import "HaqtonStyle"
Item {

    property var matchInformation: Core.requestController.context.matchInformation
    property var currentMatch: Core.requestController.context.currentMatch
    property var playersList;
    property bool initGame: false
    //
    property var competitorData;

    onCurrentMatchChanged: {
        var matchData  =  { "id": matchInformation.id,
            "topic": matchInformation.topic,
            "description": matchInformation.description
        }
        console.log("POP 4")
        stackView.pop()
        stackView.push("PageMatch.qml",{isCreator: true , competitorData: competitorData, matchData: matchData , playersList: playersList})
    }

    onPlayersListChanged: initGame = !playersList.some(element => element.approved === false)

    //

    Rectangle{ color: "#f6f6f6"; anchors.fill: parent; }

    ColumnLayout{
        anchors.fill: parent
        Layout.alignment: Qt.AlignHCenter
        Layout.margins: HaqtonStyle.mediumMargin

        Label{ // match description
            text: matchInformation.description
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; Layout.topMargin: HaqtonStyle.mediumMargin; Layout.bottomMargin:  0;
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            color: "#505050"
            wrapMode: Text.WordWrap
        }

        ListView { // list of players
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.margins: HaqtonStyle.mediumMargin
            clip: true
            model: playersList
            delegate: competitorDelegate
            spacing: HaqtonStyle.smallMargin
        }

        GameButton{ // button to start the game
            Layout.fillWidth: true; Layout.margins: HaqtonStyle.largeMargin; Layout.bottomMargin: 0
            size: HaqtonStyle.buttonSizeS
            text: "START GAME"
            enabled: initGame
            state: initGame ? HaqtonStyle.buttonWhite : HaqtonStyle.buttonGrey
            textColor:  initGame ? "#9b59b6" : "#fff"
            onClicked: Core.requestController.put("matches/"+matchInformation.id,{ "status": 1 },"currentMatch")
        }

        GameButton{ // button to disapprove participants and delete game
            Layout.fillWidth: true; Layout.margins: HaqtonStyle.largeMargin; Layout.topMargin: HaqtonStyle.mediumMargin
            size: HaqtonStyle.buttonSizeS
            text: "LEAVE MATCH"
            state: HaqtonStyle.buttonRed
            textColor: "#fff"
            onClicked: dialogQuitMatch.open()
        }

        Text { // messageStatus
            text: qsTr("Waiting for other players to join")
            //Responda todas as petições para continuar
            Layout.alignment: Qt.AlignHCenter; Layout.fillWidth: true; Layout.bottomMargin: HaqtonStyle.smallMargin;
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 13
            color: "#404040"
        }
    }


    DialogCustom {
        id: dialogQuitMatch
        textTitle: "Mensagem"
        textMessage:  "Do you really want to leave the match?"
        onAccepted: reprovePlayersAndDeleteMatch()
        onRejected: dialogQuitMatch.close()
    }

    Component {
        id: competitorDelegate
        Rectangle {
            radius: 5
            color: index % 2 ?  "#e6d3ec" : "#ffffff"
            width: ListView.view.width
            height: textNome.implicitHeight*2 + HaqtonStyle.mediumMargin

            RowLayout{
                anchors.fill: parent
                anchors.leftMargin: HaqtonStyle.mediumMargin
                anchors.rightMargin: HaqtonStyle.mediumMargin
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    Layout.fillWidth: true;
                    id: textNome
                    text: modelData.player_name
                    font { family: gameFontText.name; pixelSize: 15;}
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignLeft
                }

                GameButton{
                    id: buttonApprove
                    text: qsTr("Approve")
                    visible: modelData.id !== competitorData.id && !modelData.approved
                    Layout.rightMargin: HaqtonStyle.smallMargin
                    size: HaqtonStyle.buttonSizeX
                    textColor: "#34a796"
                    state: HaqtonStyle.buttonWhite
                    onClicked: Core.requestController.put("matches/"+matchInformation.id+"/players/"+modelData.id,{ "approved": true},"playerUpdate");
                }

                GameButton{
                    id: buttonDisapprove
                    text: "Deny"
                    size: HaqtonStyle.buttonSizeX
                    textColor: "#fff"
                    visible: modelData.id !== competitorData.id
                    state: HaqtonStyle.buttonRed
                    onClicked: Core.requestController.put("matches/"+matchInformation.id+"/players/"+modelData.id,{   "approved": false},"playerUpdate")
                }
            }
        }
    }

    function reprovePlayersAndDeleteMatch(){
        for(var i = 0 ; i < playersList.length ; i++){
            Core.requestController.put("matches/"+matchInformation.id+"/players/"+playersList[i].id,{ "approved": false},"playerUpdate")
        }
        Core.requestController.put("matches/"+matchInformation.id,{ "status": 2 },"currentMatch")
        dialogQuitMatch.close()
        console.log("POP 5")
        stackView.pop();
    }

    Connections{
        target: Core.messagingController

        function onNewMessage(message){
            var jmessage = JSON.parse(message)
            console.log("On new message: " + jmessage)
            if(jmessage.message === "players_update"){              
                playersList = jmessage.data
                return
            }
        }
    }
    StackView.onActivated: {
        Core.messagingController.setTopic(matchInformation.topic);
        playersList = matchInformation.match_players

        window.headerTitle = "Match participants"
        window.headerColor = "#8e44ad"

    }
}


