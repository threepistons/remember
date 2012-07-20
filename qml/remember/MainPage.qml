import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    Component {
        id: listsDelegate;
        Item {
            width: parent.width;
            height: nameText.height + 24

            Label {
                id: nameText;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: 20;
                text: display;
                platformStyle: LabelStyle {
                    fontPixelSize: 32;
                }
            }

            Rectangle {
                id: line
                y: parent.height
                width: parent.width
                height: 1
                color: "#bbb"
                opacity: 0.8
            }

            Image {
                source: "image://theme/icon-m-common-drilldown-arrow";
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.rightMargin: 20;
            }

            MouseArea {
                id: listMouse
                anchors.fill: parent
                onClicked: {
                    appWindow.showTasks( display, id);
                }
            }
        }
    }

    Rectangle {
        id: label;
        width: parent.width;
        height: headerText.height + 24;
        color: "mediumblue";
        anchors {
            top: parent.top;
            left: parent.left;
        }

        Text {
            id: headerText;
            anchors {
                left: parent.left;
                leftMargin: 20;
                right: parent.right;
                verticalCenter: parent.verticalCenter;
            }
            text: qsTr("Select a list");
            font.pixelSize: 32;
            color: "white";
        }
    }

    ListView {
        id: listsView;
        width: parent.width;
        height: parent.height - label.height;
        anchors {
            top: label.bottom;
            left: parent.left;
        }

        delegate: listsDelegate;
        model: remember.listsModel;
        focus: true;
        clip: true;
    }

}
