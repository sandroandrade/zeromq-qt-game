import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtGraphicalEffects 1.0
import "FontAwesome"
import QtMultimedia 5.15

Image {
    id: button
    fillMode: Image.PreserveAspectFit
    signal clicked

    SoundEffect {
        id: tapSound
        source: "assets/audio/button.wav"
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor;
        onClicked:{
            animationPress.start()
            button.clicked()
            if(settings.sounds) tapSound.play()
        }
    }

    SequentialAnimation {
        id: animationPress
        PropertyAnimation { property: "scale"; target: button; from: 1; to: 0.95; duration: 100; easing.type: Easing.InOutSine; }
        PropertyAnimation { property: "scale"; target: button; from: 0.95; to: 1; duration: 100; easing.type: Easing.InOutSine; }
    }
}
