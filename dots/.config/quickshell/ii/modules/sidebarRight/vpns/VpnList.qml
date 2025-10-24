import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: Network.updateVpnList()
    }

    Component.onCompleted: {
        if (Network.vpnConnections.length === 0) {
            Network.updateVpnList();
        }
    }

    ScrollView {
        id: scrollView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: statusRow.top
        anchors.bottomMargin: 5

        clip: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: scrollView.width
                height: scrollView.height
                radius: Appearance.rounding.normal
            }
        }

        ColumnLayout {
            width: scrollView.width
            spacing: 5

            Repeater {
                model: Network.vpnConnections

                delegate: Rectangle {
                    id: vpnItem
                    Layout.fillWidth: true
                    height: 50
                    color: Appearance.m3colors.m3surface
                    radius: Appearance.rounding.small

                    readonly property var connection: modelData

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 8
                            Layout.preferredHeight: 8
                            radius: 4
                            color: vpnItem.connection && vpnItem.connection.isActive ? 
                                   Appearance.m3colors.m3primary : 
                                   Appearance.m3colors.m3outline
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            StyledText {
                                Layout.fillWidth: true
                                font.pixelSize: Appearance.font.pixelSize.normal
                                text: vpnItem.connection ? vpnItem.connection.name : ""
                                elide: Text.ElideRight
                            }

                            StyledText {
                                Layout.fillWidth: true
                                font.pixelSize: Appearance.font.pixelSize.small
                                color: Appearance.m3colors.m3outline
                                text: {
                                    if (!vpnItem.connection) return Translation.tr("Loading...");
                                    return vpnItem.connection.isActive ? 
                                        Translation.tr("Active • %1").arg(vpnItem.connection.device || "N/A") : 
                                        Translation.tr("Inactive")
                                }
                                elide: Text.ElideRight
                            }
                        }

                        ButtonGroup {
                            id: controls
                            VpnToggleButton {
                                Layout.preferredWidth: 80
                                Layout.preferredHeight: 30
                                enabled: vpnItem.connection
                                connection: vpnItem.connection
                                buttonText: connection && connection.isActive ? 
                                    Translation.tr("Disconnect") : 
                                    Translation.tr("Connect")
                            }
                        }
                    }
                }
            }
        }
    }

    // Placeholder 
    Item {
        anchors.fill: scrollView

        visible: opacity > 0
        opacity: (Network.vpnConnections.length === 0 && !isLoading) ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Appearance.animation.menuDecel.duration
                easing.type: Appearance.animation.menuDecel.type
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 5

            MaterialSymbol {
                Layout.alignment: Qt.AlignHCenter
                iconSize: 55
                color: Appearance.m3colors.m3outline
                text: "vpn_lock"
            }
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.m3colors.m3outline
                horizontalAlignment: Text.AlignHCenter
                text: Translation.tr("No VPN connections found")
            }
        }
    }

    Item {
        id: statusRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Layout.fillWidth: true
        implicitHeight: Math.max(
            controls.implicitHeight,
            statusText.implicitHeight
        )

        StyledText {
            id: statusText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            horizontalAlignment: Text.AlignHCenter
            text: {
                if (!Network.vpnConnections || Network.vpnConnections.length === 0) {
                    return Translation.tr("No VPN connections");
                }
                
                var activeCount = 0;
                for (var i = 0; i < Network.vpnConnections.length; i++) {
                    if (Network.vpnConnections[i] && Network.vpnConnections[i].isActive) {
                        activeCount++;
                    }
                }
                return Translation.tr("%1 of %2 VPN connections active").arg(activeCount).arg(Network.vpnConnections.length)
            }

            opacity: Network.vpnConnections.length > 0 ? 1 : 0
            visible: opacity > 0
            Behavior on opacity {
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }
        }

        ButtonGroup {
            id: controls
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 5

            VpnStatusButton {
                buttonIcon: "refresh"
                buttonText: Translation.tr("Refresh")
                onClicked: () => {
                    Network.updateVpnList()
                }
            }
        }
    }
}