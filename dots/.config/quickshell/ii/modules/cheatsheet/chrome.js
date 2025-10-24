var keybinds = {
    children: [
        {
            children: [
                {
                    name: "Tab & Window",
                    keybinds: [
                        {
                            mods: ["Ctrl"],
                            key: "N",
                            comment: "New window"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "N",
                            comment: "Incognito mode"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "T",
                            comment: "New tab"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "T",
                            comment: "Reopen tabs"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "Tab",
                            comment: "Next open tab",
                            alternative: ["Ctrl", "PgDn"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Tab",
                            comment: "Previous open tab",
                            alternative: ["Ctrl", "PgUp"]
                        },
                        {
                            mods: ["Ctrl"],
                            key: "1",
                            comment: "Specific tab (1-8)",
                            range: [1, 8]
                        },
                        {
                            mods: ["Ctrl"],
                            key: "9",
                            comment: "Rightmost tab"
                        },
                        {
                            mods: ["Alt"],
                            key: "Home",
                            comment: "Home"
                        },
                        {
                            mods: ["Alt"],
                            key: "Left",
                            comment: "Previous page from history"
                        },
                        {
                            mods: ["Alt"],
                            key: "Right",
                            comment: "Next page from history"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "W",
                            comment: "Close",
                            alternative: ["Ctrl", "F4"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "W",
                            comment: "Close the current window",
                            alternative: ["Alt", "F4"]
                        },
                        {
                            mods: ["Alt", "Space"],
                            key: "N",
                            comment: "Minimize"
                        },
                        {
                            mods: ["Alt", "Space"],
                            key: "X",
                            comment: "Maximize"
                        },
                        {
                            mods: ["Alt", "F"],
                            key: "X",
                            comment: "Quit"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Page ↑/↓",
                            comment: "Move tabs left/right",
                            alternative: ["Ctrl", "Shift", "PgDn"]
                        }
                    ]
                }
            ]
        },
        {
            children: [
                 {
                    name: "Address Bar",
                    keybinds: [
                        {
                            mods: ["Ctrl"],
                            key: "Enter",
                            action: "Type a site name",
                            comment: "Open in the current tab"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Enter",
                            action: "Type a site name",
                            comment: "Open in a new window"
                        },
                        {
                            mods: ["Alt"],
                            key: "Enter",
                            action: "Type a search term",
                            comment: "Search in the new tab"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "L",
                            comment: "Jump to the address bar",
                            alternatives: [
                                {mods: ["Alt"], key: "D"},
                                {key: "F6"}
                            ]
                        },
                        {
                            mods: ["Ctrl"],
                            key: "K",
                            comment: "Search on the page",
                            alternative: {mods: ["Ctrl"], key: "E"}
                        },
                        {
                            mods: ["Ctrl"],
                            key: "F5",
                            comment: "Move cursor to the address bar"
                        }
                    ]
                }
            ]
        },
        {
            children: [

                {
                    name: "Webpage",
                    keybinds: [
                        {
                            mods: ["Ctrl"],
                            key: "P",
                            comment: "Print"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "S",
                            comment: "Save"
                        },
                        {
                            key: "F5",
                            comment: "Reload",
                            alternative: { mods: ["Ctrl"], key: "R" }
                        },
                        {
                            mods: ["Shift"],
                            key: "F5",
                            comment: "Reload, ignoring cached content",
                            alternative: { mods: ["Ctrl", "Shift"], key: "R" }
                        },
                        {
                            key: "Esc",
                            comment: "Stop"
                        },
                        {
                            key: "Tab",
                            comment: "Browse forward"
                        },
                        {
                            mods: ["Shift"],
                            key: "Tab",
                            comment: "Browse backward"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "O",
                            action: "Select a file",
                            comment: "Open a file"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "U",
                            comment: "Source code"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "D",
                            comment: "Save bookmark"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "D",
                            comment: "Save all as bookmarks in a new folder"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "+",
                            comment: "Zoom +"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "-",
                            comment: "Zoom -"
                        },
                        {
                            mods: ["Ctrl"],
                            key: "0",
                            comment: "Default size"
                        },
                        {
                            key: "Space",
                            comment: "Scroll down",
                            alternative: { key: "PgDn" }
                        },
                        {
                            mods: ["Shift"],
                            key: "Space",
                            comment: "Scroll up",
                            alternative: { key: "PgUp" }
                        },
                        {
                            mods: [],
                            key: "Home",
                            comment: "Top"
                        },
                        {
                            mods: [],
                            key: "End",
                            comment: "Bottom"
                        },
                        {
                            mods: ["Shift"],
                            key: "Scroll ↑/↓",
                            comment: "Scroll horizontally"
                        },
                        {
                            mods: ["Alt"],
                            key: "Home",
                            comment: "Home"
                        }
                    ]   
                }
            ]
        }
    ]
};