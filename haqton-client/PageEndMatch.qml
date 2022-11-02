import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import "HaqtonStyle"

Item {

    property var competitorData;

    Rectangle{
        color: "#2ECC71"
        anchors.fill: parent
        Image {
            id: rotatingImage
            anchors{ verticalCenter: parent.bottom; horizontalCenter: parent.horizontalCenter;}
            source: "assets/images/lights.png"
            sourceSize.height: parent.height*2
            fillMode: Image.PreserveAspectFit
            RotationAnimator {  target: rotatingImage; from: 0; to: 360; duration: 40000; running: true; loops: Animation.Infinite}}
    }


    ColumnLayout{
        anchors.fill: parent
        Layout.margins: HaqtonStyle.mediumMargin

        Item{
            Layout.fillWidth: true;
            Layout.preferredHeight: laurelsImage.implicitHeight
            Image {
                id: laurelsImage
                anchors.centerIn: parent
                source: "assets/images/award-svgrepo-com.png"
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 140
            }
        }
        Label{
            Layout.fillWidth: true;
            text: "Ranking"
            horizontalAlignment: Text.AlignHCenter
            font { family: gameFontText.name; pixelSize: 22; bold: true }
            color: "#ffffff"
            wrapMode: Text.WordWrap
        }

        ListView {
            id: viewPlayers
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.leftMargin:  HaqtonStyle.largeMargin; Layout.rightMargin: HaqtonStyle.largeMargin;
            spacing: HaqtonStyle.mediumMargin
            clip: true
            delegate: Rectangle {
                id: rectPlayer
                radius: 5
                opacity: 0
                color: index % 2 ? "#44ffffff":"#ccffffff"
                x: -50
                width: ListView.view.width
                height: textPosition.implicitHeight * 2
                RowLayout{
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    spacing: 10
                    Label {
                        text: index + 1 + '.';
                        font { family: gameFont.name; pixelSize: 16 }
                        color: "#404040"
                    }
                    Image {
                        visible: index == 0
                        source: "assets/images/crown-svgrepo-com.png"
                        sourceSize.width: textPosition.implicitHeight
                        fillMode: Image.PreserveAspectFit
                    }
                    Label{
                        id: textPosition;
                        text: player_name;
                        Layout.fillWidth: true;
                        font { family: gameFontText.name; pixelSize: 18 }
                        elide: Qt.ElideRight
                        color: "#303030"
                    }

                    Label{
                        Layout.alignment: Qt.AlignRight;
                        text: score;
                        font { family: gameFont.name; pixelSize: 22; bold: true; }
                        color: "#606060"
                    }

                    Image {
                        source: "assets/images/star-svgrepo-com.png"
                        sourceSize.width: textPosition.implicitHeight
                        fillMode: Image.PreserveAspectFit

                    }
                }
                SequentialAnimation {
                    running: true
                    PauseAnimation { duration: index*200 }
                    ParallelAnimation{
                        PropertyAnimation {target: rectPlayer; from: 0; to: 1; duration: 500; properties: "opacity"; easing.type: Easing.InOutQuad }
                        PropertyAnimation {target: rectPlayer; from: -50; to: 0; duration: 500; properties: "x"; easing.type: Easing.InOutQuad }
                    }
                }
            }
        }
        GameButton{
            id: buttonCloseMatch
            Layout.fillWidth: true; Layout.margins: HaqtonStyle.mediumMargin;
            size: HaqtonStyle.buttonSizeS;
            state: HaqtonStyle.buttonYellow;
            text: "BACK TO MENU"
            textColor: "#ffffff"
            onClicked: {
                console.log("POP 6")
                stackView.pop()
                listModelPlayers.clear()

            }
        }

    }


    function orderPlayersByScore(){
        let indexes = [ ...Array(listModelPlayers.count).keys() ]
        indexes.sort( (a,b) => {
                         if (listModelPlayers.get(a).score < listModelPlayers.get(b).score) return 1
                         return listModelPlayers.get(a).score > listModelPlayers.get(b).score ? -1 : 0
                     } )
        let sorted = 0
        while ( sorted < indexes.length && sorted === indexes[sorted] ) sorted++
        if ( sorted === indexes.length ) return
        for ( let i = sorted; i < indexes.length; i++ ) {
            listModelPlayers.move( indexes[i], listModelPlayers.count - 1, 1 )
            listModelPlayers.insert( indexes[i], { } )
        }
        listModelPlayers.remove( sorted, indexes.length - sorted )

    }

    function sumCompetitorScore(){
        for(var i = 0 ; i < listModelPlayers.count; i++){
            if(competitorData.id === listModelPlayers.get(i).id){
                settings.points += listModelPlayers.get(i).score
                if(i === 0 && listModelPlayers.get(i).score !== 0 ) settings.wins += 1
            }
        }
    }

    StackView.onActivated: {
        window.headerTitle = "Haqton! Quiz"
        window.headerColor = "#28b362"

        orderPlayersByScore()
        viewPlayers.model =  listModelPlayers
        sumCompetitorScore()
    }

}


