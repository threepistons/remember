import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import com.jpwhiting 1.0

Page {
    tools: commonTools;

    onStatusChanged: {
        if (status == PageStatus.Inactive)
            editorLoader.source = "";
    }

    function commitTaskChanges()
    {
        if (edit.text != remember.currentTask.name)
            remember.currentTask.name = edit.text;

        if (duedateText.text == "" && Qt.formatDate(remember.currentTask.due) != "")
            remember.currentTask.removeDue();
        else if (duedateText.text != Qt.formatDate(remember.currentTask.due))
            remember.currentTask.due = new Date(duedateText.text);

        if (priorityColumn.selectedIndex != remember.currentTask.priority)
            remember.currentTask.priority = priorityColumn.selectedIndex;

        if (tagEdit.text != remember.currentTask.tags.join(","))
            remember.currentTask.tags = tagEdit.text.split(",");

        pageStack.pop();
    }

    DatePickerDialog {
        id: dueDatePicker
        titleText: "Due date"
        onAccepted: {
            var d = new Date();
            d.setFullYear(dueDatePicker.year);
            d.setMonth(dueDatePicker.month - 1); // Month is 0 based in Date.
            d.setDate(dueDatePicker.day);
            console.log("new due date is " + d);
            duedateText.text = Qt.formatDate(d);
        }
    }

    TumblerDialog {
        id: priorityDialog
        titleText: qsTr("Priority")
        columns: [ priorityColumn ]
    }

    TumblerColumn {
        id: priorityColumn
        items: ListModel {
            id: priorityList
            ListElement { value: "None" }
            ListElement { value: "High" }
            ListElement { value: "Medium" }
            ListElement { value: "Low" }
        }
        selectedIndex: remember.currentTask.priority
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

            text: "Task details";
            font.pixelSize: 32;
            color: "white";
        }
    }

    Flickable {
        id: container
        anchors.top: label.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: UiConstants.DefaultMargin
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick
        pressDelay: 100
        clip: true

        Column {
            id: col
            spacing: 5
            width: container.width

            Label {
                text: "Task Name:"
            }

            TextArea {
                id: edit
                anchors.left: parent.left
                anchors.right: parent.right
                height: 100
                text: remember.currentTask.name;
                wrapMode: TextEdit.Wrap
            }

            Label {
                text: "Priority:"
            }

            TumblerButton {
                id: priorityButton;
                text: priorityList.get(priorityColumn.selectedIndex).value
                onClicked: priorityDialog.open()
            }

            Label {
                text: "Due:"
            }

            Row {
                id: duerow;
                spacing: 5

                Label {
                    id: duedateText;
                    text: Qt.formatDate(remember.currentTask.due);

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: dueDatePicker.open();
                    }
                }

                Button {
                    id: addDueDate;
                    text: qsTr("Add due date");
                    onClicked: dueDatePicker.open();
                    visible: duedateText.text.length == 0
                }

                Button {
                    id: clearDueDate;
                    text: qsTr("Remove due date");
                    onClicked: duedateText.text = "";
                    visible: duedateText.text.length > 0
                }
            }

            Label {
                text: "Tags:"
            }

            TextArea {
                id: tagEdit
                anchors.left: parent.left
                anchors.right: parent.right
                height: 50
                text: remember.currentTask.tags.join(",");
            }

        }
    }
}
