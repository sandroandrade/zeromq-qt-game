import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import haqton 1.0
import "HaqtonStyle"
Item {
    Rectangle{
        anchors.fill: parent;
        color: "#ffffff"
        Image {
            anchors.centerIn: parent
            source: "assets/images/doodle_qt.png"
            fillMode: Image.PreserveAspectFit
            sourceSize.height: parent.height
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: HaqtonStyle.mediumMargin
        anchors.margins: HaqtonStyle.mediumMargin

        Item{ Layout.fillHeight: true; Layout.fillWidth: true;}

        Label{ // Animation text Haqton
            id: textHaqton
            Layout.fillWidth: true;
            text: "Haqton!"
            horizontalAlignment: Text.AlignHCenter
            font { family: gameFont.name; pixelSize: 60; }
            color: "#41CD52"
            wrapMode: Text.WordWrap
            SequentialAnimation {
                loops: Animation.Infinite
                running: true;
                SequentialAnimation{
                    PropertyAnimation { property: "scale"; target: textHaqton; from: 1; to: 1.2; duration: 1000; easing.type: Easing.InOutQuad;}
                    PropertyAnimation { property: "scale"; target: textHaqton; from: 1.2; to: 1; duration: 1000; easing.type: Easing.InOutQuad;}
                }
            }
        }

        Item{ Layout.fillHeight: true; Layout.fillWidth: true;}

        TextFieldCustom {
            id: nickname;
            text: settings.competitorNickname ;
            placeholderText: 'Name*';
            Layout.fillWidth:  true;
            horizontalAlignment: TextInput.AlignHCenter
        }
        TextFieldCustom {
            id: email;
            text: settings.competitorEmail;
            placeholderText: 'Email';
            Layout.fillWidth:  true;
            horizontalAlignment: TextInput.AlignHCenter
        }
        GameButton{
            Layout.fillWidth:  true
            text: "SIGN IN"
            size: HaqtonStyle.buttonSizeS
            textColor: nickname.length === 0 ? "#505050" : "#ffffff"
            state: nickname.length === 0 ? HaqtonStyle.buttonGrey : HaqtonStyle.buttonQt
            enabled: nickname.length !== 0
            onClicked: {
                settings.competitorNickname = nickname.text
                settings.competitorEmail    = email.text
                console.log("POP 8")
                stackView.pop()
                stackView.push("PageMenu.qml")
            }
            Layout.minimumWidth: 130
        }
    }
    StackView.onActivated: {
        window.headerTitle = "HaQton"
        window.headerColor = "#41CD52"
    }
}
