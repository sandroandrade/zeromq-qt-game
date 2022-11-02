import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import QtQuick.Window 2.1

import Qt.labs.settings 1.0
import haqton 1.0
import "FontAwesome"
import "HaqtonStyle"
ApplicationWindow {

    id: window
    width:(Qt.platform.os === "android") ? Screen.Width : 380
    height:(Qt.platform.os === "android") ? Screen.Height : width * 16/9
    visible: true
    title: qsTr("HaQton")

    property var headerTitle: "Qt"
    property var headerColor: "#ffffff"


    FontLoader { id: gameFontText; source: "assets/fonts/Raleway-Medium.ttf" }
    FontLoader { id: gameFont; source: "assets/fonts/PocketMonk-15ze.ttf" }
    Audio { id: gameMusic; source: "assets/audio/Magic-Clock-Shop_Looping.mp3"; loops: Audio.Infinite; autoPlay: settings.music;}

    Settings {
        id: settings
        property bool sounds: true
        property bool music: true
        property string competitorNickname: ""
        property string competitorEmail:""
        property int wins: 0
        property int points: 0
        property string avatar: "assets/images/Mascot_konqi-dev-qt.png"
    }

    header: Rectangle {
        height: titleElement.implicitHeight * 2
        color: headerColor
        Label {
            id: titleElement
            text: headerTitle
            anchors.centerIn: parent
            font { family: gameFont.name; pixelSize: 26;}
            color: "#ffffff"
        }
        ToolGameButton{
            source: "assets/images/settings-cogwheel-svgrepo-com.png"
            sourceSize.width: titleElement.implicitHeight
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: HaqtonStyle.mediumMargin
            }
            onClicked: settingsDialog.open();
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent;
        Component.onCompleted: {
            if(settings.competitorNickname.length === 0) stackView.push("PageLogin.qml")
            else stackView.push("PageMenu.qml")
        }
    }

    LoadingScreen{}

    ErrorNotification{ id: errorNotification}

    ListModel{ id: listModelPlayers }

    SettingsDialog{ id: settingsDialog }

}
