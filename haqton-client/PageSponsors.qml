import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import haqton 1.0
import "HaqtonStyle"
Item {

    Rectangle{
        anchors.fill: parent; color: "#ffffff";
    }

    ColumnLayout{
        anchors.fill: parent

        ToolGameButton{
            source: "assets/images/cancel-svgrepo-com.png"
            sourceSize.width: HaqtonStyle.largeMargin
            Layout.margins: HaqtonStyle.mediumMargin
            Layout.alignment: Qt.AlignRight
            onClicked: {
                console.log("POP 10")
                stackView.pop()
            }
        }

        GridLayout {
            Layout.alignment: Qt.AlignHCenter;
            Layout.fillWidth: true;
            Layout.margins: HaqtonStyle.mediumMargin
            Layout.leftMargin: HaqtonStyle.largeMargin
            Layout.rightMargin: HaqtonStyle.largeMargin
            columns: 1;
            columnSpacing: HaqtonStyle.mediumMargin
            rowSpacing: columnSpacing
            Repeater {
                model: [
                    {   icon: "assets/images/sponsor_opensuse.png",
                        link: "https://www.opensuse.org/",
                    },
                    {   icon: "assets/images/sponsor_toradex.png",
                        link: "https://www.toradex.com/pt-br/",
                    },
                    {   icon: "assets/images/sponsor_b2o.png",
                        link: "https://www.b2open.com/",
                    },
                ]
                ToolGameButton{
                    source: modelData.icon
                    sourceSize.width: 256
                    onClicked: Qt.openUrlExternally(modelData.link)
                }
            }
        }
    }
    StackView.onActivated: {
        window.headerTitle = "Sponsors"
        window.headerColor = "#41CD52"
    }
}
