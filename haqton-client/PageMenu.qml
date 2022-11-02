import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.12

import haqton 1.0
import "FontAwesome"
import "HaqtonStyle"
Item {

    property bool runAnimations

    Rectangle{
        color: "#0099E9"
        anchors.fill: parent
        Image {
            id: backgroundImage
            anchors.centerIn: parent
            opacity: 0 // soft animation
            source: "assets/images/background_menu.png"
            fillMode: Image.PreserveAspectFit
            sourceSize.height: parent.height
            PropertyAnimation {running: runAnimations; property: "opacity";  target: backgroundImage; from: 0.2; to: 0.6; duration: 1000;}
            ParallelAnimation{
                running: runAnimations;
                loops: Animation.Infinite
                SequentialAnimation {
                    loops: Animation.Infinite
                    PropertyAnimation {property: "scale";  target: backgroundImage; from: 1; to: 1.1; duration: 2000; }
                    PropertyAnimation {property: "scale";  target: backgroundImage; from: 1.1; to: 1; duration: 1500; }
                }
                RotationAnimator {loops: Animation.Infinite;target: backgroundImage; from: 0; to: 360; duration: 60000;}
            }
        }
    }

    Popup {
        id: popupNewMatch
        anchors.centerIn: Overlay.overlay
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        padding: HaqtonStyle.mediumMargin
        contentItem: PageNewMatch {
            onNewMatch: {
                popupNewMatch.close()
                stackView.push("PageApprovalCompetitor_Creator.qml", { competitorData : competitorData })
            }
        }
    }

    ColumnLayout{
        anchors.fill: parent

        GameDisplayInfo{ // Game information
        }

        Item {Layout.fillHeight: true}

        Item{ // Avatar
            Layout.fillWidth: true
            Layout.preferredHeight: parent.width*0.4 > 256 ? 256 : parent.width*0.4;
            Layout.preferredWidth: parent.width*0.4 > 256 ? 256 : parent.width*0.4;
            Layout.alignment: Qt.AlignHCenter;
            Rectangle {
                anchors.centerIn: parent
                width: parent.height;
                height: width;
                radius: width*0.5;
                border.color: "#efefef"; border.width: 2;
                color: "#008acf"
                Image {
                    anchors.centerIn: parent
                    source: "assets/images/lights.png"
                    opacity: 0.5
                    width: parent.width * 3
                    fillMode: Image.PreserveAspectFit
                }
                Rectangle{ anchors.fill: parent; color: "#008acf"; radius: width*0.5; border.color: "#efefef"; border.width: 2; }
                Image{
                    source: "assets/images/Mascot_konqi-dev-qt.png"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width - 15
                    anchors.centerIn: parent;
                }
            }
        }

        Label { // User Nickname
            text: settings.competitorNickname;
            Layout.alignment: Qt.AlignHCenter;
            color: "#fff";
            font { family: gameFontText.name; pixelSize: 22; bold: true}
        }

        Item {Layout.fillHeight: true}


        GridLayout { // Buttons
            Layout.fillWidth: true;
            Layout.margins: HaqtonStyle.mediumMargin
            Layout.leftMargin: HaqtonStyle.largeMargin
            Layout.rightMargin: HaqtonStyle.largeMargin
            columns: 1;
            columnSpacing: HaqtonStyle.mediumMargin
            rowSpacing: columnSpacing
            Repeater {
                model: [
                    {   icon: Icons.faPlusCircle,
                        text: "CREATE MATCH",
                        source: "PageNewMatch.qml",
                        type: "popup"
                    },
                    {   icon: Icons.faGamepad,
                        text: "JOIN MATCH",
                        source: "PageListMatches.qml",
                        type: "page"
                    }
                ]
                GameButton{
                    Layout.fillWidth: true;
                    text: modelData.text
                    state: HaqtonStyle.buttonWhite
                    textColor: "#008acf"
                    size: HaqtonStyle.buttonSizeS
                    onClicked: {
                        if (modelData.type === 'page') stackView.push(modelData.source)
                        else popupNewMatch.open()
                    }
                }
            }
        }
    }

    StackView.onActivated: {
        runAnimations = true
        window.headerTitle = "HaQton!"
        window.headerColor = "#008acf"
    }
    StackView.onDeactivated: {
        backgroundImage.opacity = 0; // TODO  - background soft animation
        runAnimations = false
    }
}
