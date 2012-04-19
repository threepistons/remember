import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage;

    function showTasks(name, id)
    {
        tasksPage.title = name;
        service.setListId(id);
        pageStack.push(tasksPage);
    }

    QueryDialog {
        id: splashMessage;
        message: qsTr("This product uses the Remember The Milk API but is not endorsed or certified by Remember The Milk.");
        acceptButtonText: qsTr("OK");
    }

    Connections {
        target: service;
        onAuthenticationDone: {
            if (success) {
                service.listsGetList();
                service.tasksGetList();
            }
            else
            {
                loginDialog.open();
            }
        }

        onAuthenticationLoadUrl: {
            loginDialog.open();
            loginDialog.url = url;
        }
    }

    LoginDialog {
        id: loginDialog;
    }

    MainPage {
        id: mainPage;
    }

    TasksPage {
        id: tasksPage;
    }

    ToolBarLayout {
        id: commonTools
        visible: false
        ToolIcon {
            id: backButton;
            iconId: "icon-m-toolbar-back";
            onClicked: pageStack.pop();
            visible: (pageStack.depth > 1);
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Log out");
                onClicked: myApp.forgetAuthToken();
            }
        }
    }

    Component.onCompleted: {
        splashMessage.open();
    }
}