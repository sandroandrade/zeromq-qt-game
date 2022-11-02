import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtMultimedia 5.15
import "HaqtonStyle"

Item {
    id: button
    property var text;
    property int size;
    property int state;
    // white //grey / green / yellow / red / qt
    property variant primaryColor:   ["#ffffff","#e1e1e1","#4cd5a9","#ffa310","#e75b5b", "#41CD52"]
    property variant secondaryColor: ["#dddddd","#a3a3a3","#20c398","#cc8001","#c55b59", "#35a642"]
    property variant buttonPixelSize: [14,20,26,32]
    property alias textColor: textLabel.color

    signal clicked

    implicitHeight: textLabel.implicitHeight + buttonPixelSize[size]
    implicitWidth: textLabel.implicitWidth   + HaqtonStyle.mediumMargin
    anchors.margins: HaqtonStyle.mediumMargin

    Rectangle{
        anchors.fill: parent
        color: secondaryColor[button.state]
        radius: 7
        Rectangle{
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top:  parent.top
            }
            width: parent.width
            height: parent.height - 5
            color: primaryColor[button.state]
            radius: 7
            Label {
                id: textLabel
                text: button.text
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                font {
                    family: gameFontText.name;
                    pixelSize: buttonPixelSize[size]
                    bold: true
                }
                wrapMode: Text.WordWrap
            }
        }
    }

    SoundEffect { id: tapSound; source: "assets/audio/button.wav";}

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor;
        onClicked: {
            animationPress.start()
            button.clicked();
            if(settings.sounds) tapSound.play()
        }
    }

    SequentialAnimation {
        id: animationPress
        PropertyAnimation { property: "scale"; target: button; from: 1; to: 0.95; duration: 100; easing.type: Easing.InOutSine; }
        PropertyAnimation { property: "scale"; target: button; from: 0.95; to: 1; duration: 100; easing.type: Easing.InOutSine; }
    }
}
