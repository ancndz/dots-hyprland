pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import qs
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

/**
 * Provides access to some Hyprland data not available in Quickshell.Hyprland.
 */
Singleton {
    id: root
    property var windowList: []
    property var addresses: []
    property var windowByAddress: ({})
    property var biggestWindowByWorkspace: ({})
    property var workspaces: []
    property var workspaceIds: []
    property var workspaceById: ({})
    property var activeWorkspace: null
    property var monitors: []
    property var layers: ({})

    // Convenient stuff

    function toplevelsForWorkspace(workspace) {
        return ToplevelManager.toplevels.values.filter(toplevel => {
            const address = `0x${toplevel.HyprlandToplevel?.address}`;
            var win = HyprlandData.windowByAddress[address];
            return win?.workspace?.id === workspace;
        })
    }

    function hyprlandClientsForWorkspace(workspace) {
        return root.windowList.filter(win => win.workspace.id === workspace);
    }

    function clientForToplevel(toplevel) {
        if (!toplevel || !toplevel.HyprlandToplevel) {
            return null;
        }
        const address = `0x${toplevel?.HyprlandToplevel?.address}`;
        return root.windowByAddress[address];
    }

    function biggestWindowForWorkspace(workspaceId) {
        return root.biggestWindowByWorkspace[workspaceId] ?? null;
    }

    // Collect related events in one batch. Starting an active timer leaves the deadline intact.
    property var pendingQueries: new Set()

    function queueRefresh(...queries) {
        for (const query of queries)
            root.pendingQueries.add(query);
        refreshTimer.start();
    }

    Timer {
        id: refreshTimer
        interval: 40
        onTriggered: {
            const queries = root.pendingQueries;
            root.pendingQueries = new Set();
            for (const query of queries)
                query.refresh();
        }
    }

    Component.onCompleted: {
        queueRefresh(getClients, getMonitors, getWorkspaces, getActiveWorkspace);
        if (GlobalStates.regionSelectorOpen)
            queueRefresh(getLayers);
    }

    Connections {
        target: GlobalStates

        function onOverviewOpenChanged() {
            // Geometry-only changes, such as resizing a window, may not emit an IPC event.
            if (GlobalStates.overviewOpen)
                root.queueRefresh(getClients, getMonitors);
        }

        function onRegionSelectorOpenChanged() {
            if (GlobalStates.regionSelectorOpen)
                root.queueRefresh(getClients, getLayers);
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            switch (event.name) {
            case "openwindow":
            case "closewindow":
            case "movewindow":
            case "movewindowv2":
            case "fullscreen":
            case "minimized":
                root.queueRefresh(getClients, getWorkspaces);
                break;
            case "activewindow":
            case "activewindowv2":
            case "windowtitle":
            case "windowtitlev2":
            case "changefloatingmode":
            case "togglegroup":
            case "moveintogroup":
            case "moveoutofgroup":
            case "pin":
                root.queueRefresh(getClients);
                break;
            case "focusedmon":
            case "focusedmonv2":
                root.queueRefresh(getClients, getActiveWorkspace);
                break;
            case "workspace":
            case "workspacev2":
            case "activespecial":
            case "activespecialv2":
                root.queueRefresh(getClients, getMonitors, getActiveWorkspace);
                break;
            case "createworkspace":
            case "createworkspacev2":
            case "destroyworkspace":
            case "destroyworkspacev2":
            case "renameworkspace":
            case "moveworkspace":
            case "moveworkspacev2":
            case "monitoradded":
            case "monitoraddedv2":
            case "monitorremoved":
            case "configreloaded":
                root.queueRefresh(getClients, getMonitors, getWorkspaces, getActiveWorkspace);
                break;
            case "openlayer":
            case "closelayer":
                if (GlobalStates.regionSelectorOpen)
                    root.queueRefresh(getLayers);
                if (GlobalStates.overviewOpen)
                    root.queueRefresh(getMonitors);
                break;
            }
        }
    }

    component HyprlandQuery: Process {
        id: query
        required property string request
        property bool refreshPending: false
        signal received(var data)

        command: ["hyprctl", "-j", request]

        function refresh() {
            if (query.running) {
                query.refreshPending = true;
                return;
            }
            query.refreshPending = false;
            query.running = true;
        }

        stdout: StdioCollector { id: collector }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0 || exitStatus !== 0) {
                console.warn("[HyprlandData] Failed to query", query.request, exitCode, exitStatus);
                return;
            }
            let data;
            try {
                data = JSON.parse(collector.text);
            } catch (error) {
                console.warn("[HyprlandData] Invalid response for", query.request, error);
                return;
            }
            query.received(data);
        }

        onRunningChanged: {
            if (!query.running && query.refreshPending) {
                Qt.callLater(() => {
                    if (query.refreshPending)
                        query.refresh();
                });
            }
        }
    }

    HyprlandQuery {
        id: getClients
        request: "clients"
        onReceived: windows => {
            const windowsByAddress = {};
            const biggestByWorkspace = {};
            const areaByWorkspace = {};
            for (const window of windows) {
                windowsByAddress[window.address] = window;
                const workspace = window.workspace.id;
                const area = (window.size?.[0] ?? 0) * (window.size?.[1] ?? 0);
                if (area > (areaByWorkspace[workspace] ?? 0)) {
                    areaByWorkspace[workspace] = area;
                    biggestByWorkspace[workspace] = window;
                }
            }
            root.windowList = windows;
            root.windowByAddress = windowsByAddress;
            root.biggestWindowByWorkspace = biggestByWorkspace;
            root.addresses = Object.keys(windowsByAddress);
        }
    }

    HyprlandQuery {
        id: getMonitors
        request: "monitors"
        onReceived: data => root.monitors = data
    }

    HyprlandQuery {
        id: getLayers
        request: "layers"
        onReceived: data => root.layers = data
    }

    HyprlandQuery {
        id: getWorkspaces
        request: "workspaces"
        onReceived: data => {
            // Filter out invalid workspace ids (e.g. temporary lock-screen workspaces).
            const workspaces = data.filter(ws => ws.id >= 1 && ws.id <= 100);
            root.workspaces = workspaces;
            root.workspaceById = Object.fromEntries(workspaces.map(ws => [ws.id, ws]));
            root.workspaceIds = workspaces.map(ws => ws.id);
        }
    }

    HyprlandQuery {
        id: getActiveWorkspace
        request: "activeworkspace"
        onReceived: data => root.activeWorkspace = data
    }
}
