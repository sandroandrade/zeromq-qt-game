import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15

import QtGraphicalEffects 1.12

import "HaqtonStyle"

GridLayout {
    columns: 2
    Layout.margins: HaqtonStyle.mediumMargin
    Layout.fillWidth: true;
    Layout.alignment: Qt.AlignHCenter
    ColumnLayout{
        Layout.fillWidth: true;
        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

        Label{
            id: textVitorias
            Layout.fillWidth: true;
            text: "Victories"
            horizontalAlignment: Text.AlignHCenter
            font { family: gameFontText.name; pixelSize: 20; bold: true }
            color: "#fff"
            wrapMode: Text.WordWrap
        }
        Rectangle{
            height: 1
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            width: textVitorias.implicitWidth

        }
        ToolGameButton{
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            source: "assets/images/crown-svgrepo-com.png"
            sourceSize.width: textVitorias.implicitHeight*2
        }
        Label{
            Layout.fillWidth: true;
            text: settings.wins
            horizontalAlignment: Text.AlignHCenter
            font { family: gameFontText.name; pixelSize: 24; bold:true;}
            color: "#fff"

        }
    }
    ColumnLayout{

        Layout.fillWidth: true;
        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

        Label{
            id: textPontos
            text: "Score"
            Layout.fillWidth: true;
            horizontalAlignment: Text.AlignHCenter
            font { family: gameFontText.name; pixelSize: 20; bold: true }
            color: "#fff"
            wrapMode: Text.WordWrap
        }
        Rectangle{
            height: 1
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            width: textPontos.implicitWidth

        }
        ToolGameButton{
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            source: "assets/images/star-svgrepo-com.png"
            sourceSize.width: textPontos.implicitHeight*2
        }
        Label{
            Layout.fillWidth: true;
            text: settings.points
            horizontalAlignment: Text.AlignHCenter
            font { family: gameFontText.name; pixelSize: 24; bold:true; }
            color: "#fff"

        }
    }


}

