import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import QtMultimedia 5.15
import "HaqtonStyle"
import haqton 1.0
Item {

    property var randomQuestion: []
    property var competitorData
    property var matchData
    property var playersList
    property bool isCreator
    property bool isMatchFinished: false
    //
    property int numPlayers: -1
    property int numPlayersAnswered: 0
    //
    // competitor information
    property bool isQuestionAnswered: false //competitor answered the current question
    property int questionAnswer: -1         //resposta atual do competidor
    property int playerScore: 0

    onPlayerScoreChanged: {
        imageStarAnimation.start()
        if(settings.sounds) soundSuccess.play()
    }

    Rectangle{ color: "#fab1a0"; anchors.fill: parent}

    ColumnLayout{ // main view
        anchors.fill: parent
        Layout.alignment: Qt.AlignHCenter
        Layout.margins: HaqtonStyle.mediumMargin

        Item{ Layout.fillHeight: true;}

        Rectangle{ // question description
            Layout.fillWidth: true; Layout.margins: HaqtonStyle.smallMargin;
            implicitHeight: questionText.implicitHeight + 2 * HaqtonStyle.largeMargin
            color: "#ffffff"
            Label{
                id: questionText
                anchors{  right: parent.right;  left: parent.left;  verticalCenter: parent.verticalCenter; }
                color: "#808080"
                font { pixelSize: 16 }
                wrapMode: Text.WordWrap
                horizontalAlignment: Qt.AlignHCenter
                text: randomQuestion.description || ""
            }
        }

        ListView { // question options
            id: listOptions
            Layout.fillWidth: true; Layout.margins: HaqtonStyle.largeMargin; Layout.minimumHeight: listOptions.childrenRect.height;
            clip: true
            model: randomQuestion.question_options
            spacing: HaqtonStyle.mediumMargin
            delegate: optionsDelegate
        }

        Item{ Layout.fillHeight: true;}

        Item{ // competitor information
            Layout.fillWidth: true;
            Layout.preferredHeight: textPoints.implicitHeight * 2
            Rectangle{
                color: "#cce17055"
                width: parent.width
                height: textPoints.implicitHeight * 2
                Label{
                    anchors { right: parent.horizontalCenter; rightMargin: HaqtonStyle.mediumMargin * 4; verticalCenter: parent.verticalCenter; }
                    horizontalAlignment: Qt.AlignHCenter
                    font { family: gameFont.name; pixelSize: 19 }
                    color: "#fcfcfc"
                    text:  isQuestionAnswered ? "Answered" : "Not answered"
                }
                Rectangle{
                    anchors{ verticalCenter: parent.verticalCenter; left: parent.horizontalCenter; leftMargin: HaqtonStyle.mediumMargin * 4;}
                    width: textPoints.implicitWidth * 2
                    Label{
                        id: textPoints
                        Layout.fillWidth: true
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        text: playerScore + "  Pontos"
                        font { family: gameFont.name; pixelSize: 19 }
                        color: "#fcfcfc"

                    }
                    Image {
                        id: imageStar
                        source: "assets/images/star-svgrepo-com.png"
                        fillMode: Image.PreserveAspectFit
                        height: textPoints.implicitHeight * 2
                        anchors { verticalCenter: parent.verticalCenter; left: textPoints.right; leftMargin: HaqtonStyle.mediumMargin}
                        SequentialAnimation {
                            id: imageStarAnimation
                            SequentialAnimation{
                                PropertyAnimation { property: "scale"; target: imageStar; from: 1; to: 2; duration: 500; easing.type: Easing.InOutSine;}
                                PropertyAnimation { property: "scale"; target: imageStar; from: 2; to: 1; duration: 400; easing.type: Easing.InOutSine;}
                            }
                        }
                    }
                }
            }
        }


        Label{ // text list of players
            id: textListPlayers
            Layout.fillWidth: true; Layout.margins: HaqtonStyle.mediumMargin;
            text: "Participants list (" + numPlayers + ")"
            font { family: gameFontText.name; pixelSize: 16; italic: true; bold: true; underline: true;}
            horizontalAlignment: Text.AlignHCenter
            color: "#fff"
            wrapMode: Text.WordWrap
            SequentialAnimation{
                id: animationAnswered
                PropertyAnimation {property: "scale";  target: textListPlayers; from: 1; to: 0.8; duration: 500; easing.type:Easing.InOutCubic }
                PropertyAnimation {property: "scale";  target: textListPlayers; from: 0.8; to: 1; duration: 500; easing.type:Easing.OutBack}
            }
        }

        ListView { // list of players
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.maximumHeight: parent.height / 4; Layout.margins: HaqtonStyle.mediumMargin;
            spacing: HaqtonStyle.smallMargin
            clip: true
            model: listModelPlayers

            delegate: Rectangle {
                width: ListView.view.width; height: itemPlayer.implicitHeight * 1.2;
                color: index % 2 ? "transparent" : "#44e17055"

                RowLayout{
                    anchors { fill: parent; rightMargin: HaqtonStyle.largeMargin; leftMargin: HaqtonStyle.largeMargin;}
                    Label {
                        id: itemPlayer;
                        text: "- "+player_name;
                        Layout.fillWidth: true;
                        font { family: gameFontText.name; pixelSize: 15 }
                        color: "#505050"
                    }
                    Rectangle{
                        height: itemPlayer.implicitHeight + 2; width: height
                        Layout.alignment: Qt.AlignRight;
                        color: currQuestionOption === -1 ? "#fff" : "#e17055"
                        radius: height*0.5
                        Label{
                            anchors.centerIn:  parent
                            visible: numPlayers === numPlayersAnswered;
                            text: String.fromCharCode(currQuestionOption+65);
                            font { family: gameFontText.name; pixelSize: 15; bold: true }
                            color: "#ffffff"
                        }
                    }
                }
            }
        }


        GameButton{
            Layout.fillWidth: true; Layout.margins: HaqtonStyle.mediumMargin; Layout.bottomMargin: 0;
            visible: isCreator && !isMatchFinished
            size: HaqtonStyle.buttonSizeS
            text: "Next Question"
            state: numPlayers === numPlayersAnswered ? HaqtonStyle.buttonGreen : HaqtonStyle.buttonGrey
            enabled: numPlayers === numPlayersAnswered
            textColor: numPlayers === numPlayersAnswered ? "#ffffff" : "#808080"
            onClicked: Core.requestController.get("matches/"+matchData.id+"/random_question","randomQuestion")
        }

        GameButton{
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; Layout.margins: HaqtonStyle.mediumMargin;
            visible: isCreator && !isMatchFinished
            size: HaqtonStyle.buttonSizeS
            text: "End match"
            state:  HaqtonStyle.buttonYellow
            textColor: "#ffffff"
            onClicked: dialogCloseMatch.open()

        }
        GameButton{
            id: buttonEndMatch
            Layout.fillWidth: true;
            visible: isMatchFinished
            size: HaqtonStyle.buttonSizeS
            Layout.margins: HaqtonStyle.mediumMargin
            text: "SEE RESULTS"
            state:  HaqtonStyle.buttonGreen
            textColor: "#ffffff"
            onClicked: {
                console.log("POP 9")
                stackView.pop();
                stackView.push("PageEndMatch.qml",{competitorData: competitorData})
            }
            SequentialAnimation {
                id: bounceAnimation
                loops: Animation.Infinite
                running: true;
                SequentialAnimation{
                    PropertyAnimation { property: "scale"; target: buttonEndMatch; from: 0.9; to: 1; duration: 800; easing.type: Easing.InOutQuad;}
                    PropertyAnimation { property: "scale"; target: buttonEndMatch; from: 1; to: 0.9; duration: 800; easing.type:Easing.InOutQuad;}
                }
            }
        }
    }

    DialogCustom {
        id: dialogCloseMatch
        textTitle: "Message"
        textMessage:  "Do you really want to finish this match?"
        onAccepted: {Core.requestController.put("matches/"+matchData.id,{ "status": 2 },"currentMatch") ; dialogCloseMatch.close()}
        onRejected: dialogCloseMatch.close()
    }

    Component {
        id: optionsDelegate
        Rectangle {
            id: optionRect
            radius : 5
            width: ListView.view.width
            height: option.implicitHeight + HaqtonStyle.largeMargin
            scale: 0
            color: {
                if(index === questionAnswer){
                    if(index === randomQuestion.right_option)  return "#65d092";
                    if(index !== randomQuestion.right_option)  return "#ff7c7c"; }
                return "#ffffff"
            }

            Label {
                id: letterOption
                anchors { left: parent.left; right: option.left; verticalCenter: option.verticalCenter; leftMargin: HaqtonStyle.largeMargin                }
                color:  index == questionAnswer ? "#ffffff" : "#808080"
                height: implicitHeight
                text: String.fromCharCode(index+65) + ") "
                elide: Text.ElideRight
                font {family: gameFontText.name; pixelSize: 15;}
            }
            Label {
                id: option
                anchors { right: parent.right; left: letterOption.right; verticalCenter: parent.verticalCenter;}
                color:  index == questionAnswer ? "#ffffff" : "#808080"
                horizontalAlignment: Text.AlignHCenter
                height: implicitHeight
                text: modelData.description
                wrapMode: Text.WordWrap
                font {family: gameFontText.name; pixelSize: 15;}
            }
            MouseArea{
                id: mouseArea
                anchors.fill: parent;
                cursorShape: Qt.PointingHandCursor; hoverEnabled: true;
                onClicked: {
                    if(!isQuestionAnswered && !isMatchFinished){
                        Core.requestController.post("matches/"+ matchData.id + "/players/"+competitorData.id+"/answer", {   "question_id": modelData.question_id,
                                                        "player_option": index}, "lastAnswer")
                    }
                }
            }
            SequentialAnimation {
                id: showAnim; running: false;
                PauseAnimation { duration: index*150 }
                ScaleAnimator { target: optionRect; from: 0; to: 1; duration: 800; easing.type: Easing.InOutCirc}
            }
            Component.onCompleted:{ showAnim.start(); }
        }
    }

    Image {
        id: messageEndMatch
        source: "assets/images/fimdapartida.png"
        anchors.centerIn: parent
        anchors.verticalCenterOffset:  -HaqtonStyle.largeMargin
        width: parent.width*0.8
        fillMode: Image.PreserveAspectFit
        opacity: 0; scale: 0.5
        SequentialAnimation{
            id: animationEndMatch
            ParallelAnimation{
                PropertyAnimation {property: "opacity";target: messageEndMatch; from: 0; to: 1; duration: 500; easing.type:Easing.InOutQuad;}
                PropertyAnimation {property: "scale"; target: messageEndMatch; from: 0.5; to: 1; duration: 2000; easing.type:Easing.OutElastic}
            }
            PauseAnimation{ duration: 200}
            ParallelAnimation{
                PropertyAnimation {property: "opacity";target: messageEndMatch; from: 1; to: 0; duration: 800; easing.type:Easing.InOutQuad;}
                PropertyAnimation {property: "scale"; target: messageEndMatch; from: 1; to: 0; duration: 800; easing.type:Easing.InOutQuad}
            }
        }
    }

    SoundEffect { id: soundSuccess; source: "assets/audio/success_ding.wav";}
    SoundEffect { id: playSound; source: "assets/audio/Whoosh.wav";}
    SoundEffect { id: soundEndMatch; source: "assets/audio/endMatch.wav";}
    SoundEffect { id: soundErrorAnswer; source: "assets/audio/error_ding.wav";}

    function updatePlayersInformation(player_id,player_option,right_option){
        for(var i = 0 ; i < numPlayers; i++){
            if(playersList[i].id === player_id){
                listModelPlayers.setProperty(i,"currQuestionOption",player_option)
                if(player_option === right_option){
                    listModelPlayers.setProperty(i,"score",listModelPlayers.get(i).score + 1)
                }
                return
            }
        }
    }

    function updateCurrentQuestionStates(){
        for(var i = 0 ; i < numPlayers; i++){
            listModelPlayers.setProperty(i,"currQuestionOption",-1)
        }
    }

    Connections{
        target: Core.messagingController
        function onNewMessage(message){
            var jmessage = JSON.parse(message)
            if(jmessage.message === "new_question"){
                updateCurrentQuestionStates();
                randomQuestion = jmessage.data
                isQuestionAnswered = false
                questionAnswer = -1
                numPlayersAnswered = 0
                if(settings.sounds) playSound.play();
                return
            }
            if(jmessage.message === "new_answer"){
                updatePlayersInformation(jmessage.data.player_id,jmessage.data.player_option,randomQuestion.right_option);
                numPlayersAnswered += 1
                if(jmessage.data.player_id === competitorData.id){
                    isQuestionAnswered = true
                    questionAnswer = jmessage.data.player_option
                    if(jmessage.data.player_option === randomQuestion.right_option ){ playerScore += 1;}
                    else{ if(settings.sounds) soundErrorAnswer.play()}
                }
                if(numPlayersAnswered === numPlayers){ animationAnswered.start(); }
                return
            }
            if(jmessage.message === "match_finished"){
                isMatchFinished = true;
                if(settings.sounds) soundEndMatch.play();
                animationEndMatch.start();
                return
            }
        }
    }

    StackView.onActivated: {
        window.headerTitle = "Haqton! Quiz"
        window.headerColor = "#e17055"


        listModelPlayers.clear()
        numPlayers = playersList.length
        for(var i = 0 ; i < numPlayers; i++){
            listModelPlayers.append({"score": playersList[i].score, "id": playersList[i].id,
                                        "player_name": playersList[i].player_name, "currQuestionOption": -1})
        }
        if(isCreator) {
            console.log("GETTING random_question")
            Core.requestController.get("matches/"+matchData.id+"/random_question","randomQuestion")
        }
    }
}



