import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import QtQuick.Window 2.1

import Qt.labs.settings 1.0
import haqton 1.0
import "FontAwesome"
import "HaqtonStyle"

Dialog {
    id: settingsDialog
    x: Math.round((window.width - width) / 2)
    y: Math.round(window.height / 6)
    width: Math.round(Math.min(window.width, window.height) / 3 * 2)
    modal: true
    focus: true

    contentItem: ColumnLayout {
        id: columnSettings
        spacing: HaqtonStyle.mediumMargin

        RowLayout{
            Label{
                id: textSettings
                Layout.fillWidth: true
                text:  "Options"
                horizontalAlignment: Qt.AlignLeft
                font { family: gameFontText.name; pixelSize: 18;}
            }
            ToolGameButton{
                source: "assets/images/cancel-svgrepo-com.png"
                sourceSize.width: textSettings.implicitHeight
                Layout.alignment: Qt.AlignRight
                onClicked: settingsDialog.close()
            }
        }

        RowLayout {
            spacing: HaqtonStyle.mediumMargin
            width: parent.width
            ToolGameButton{
                Layout.fillWidth: true;
                sourceSize.width: textSettings.implicitHeight *2
                source: settings.music ? "assets/images/music-svgrepo-com.png" : "assets/images/music-no-svgrepo-com.png"
                onClicked: {
                    settings.music = !settings.music;
                    if(settings.music) gameMusic.play()
                    else gameMusic.stop()
                }
            }
            ToolGameButton{
                Layout.fillWidth: true;
                sourceSize.width: textSettings.implicitHeight *2
                source: settings.sounds ? "assets/images/sound-speaker-svgrepo-com.png" : "assets/images/sound-volume-svgrepo-com.png"
                onClicked: settings.sounds = !settings.sounds
            }
        }

        Item { height: HaqtonStyle.largeMargin; width: height;}

        GameButton{
            Layout.fillWidth:  true
            text: "About HaQton"
            textColor: "#ffffff"
            size: HaqtonStyle.buttonSizeS
            state: HaqtonStyle.buttonYellow
            onClicked: Qt.openUrlExternally('https://br.qtcon.org/')
        }
        GameButton{
            Layout.fillWidth:  true
            text: "Sponsors"
            textColor: "#ffffff"
            size: HaqtonStyle.buttonSizeS
            state: HaqtonStyle.buttonYellow
            onClicked: {
                settingsDialog.close()
                stackView.push("PageSponsors.qml")
            }
        }

        Item { height: HaqtonStyle.largeMargin; width: height; }

        GameButton{
            Layout.fillWidth:  true
            text: "Sign out"
            textColor: "#ffffff"
            size: HaqtonStyle.buttonSizeS
            state: HaqtonStyle.buttonRed
            visible: settings.competitorNickname.length != 0
            onClicked: {
                settings.competitorNickname = ""
                settings.competitorEmail = ""
                settings.wins = 0
                settings.points = 0
                settings.avatar=  "assets/images/Mascot_konqi-dev-qt.png"
                stackView.clear(StackView.PopTransition)
                stackView.push("PageLogin.qml")
                settingsDialog.close()
            }
        }
    }
}
