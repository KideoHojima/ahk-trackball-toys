; Combined AutoHotkey script
; Includes: Trackball scrolling, side button customization, and VSCode shortcut
; Author: Combined from multiple scripts

#NoEnv
#SingleInstance Force
#Persistent

; =============================================================================
; TRACKBALL SCROLLING VARIABLES
; =============================================================================
ScrollMode := false
LastX := 0
LastY := 0
Sensitivity := 1  ; Adjust this value to change scroll sensitivity (higher = more sensitive)
ScrollThreshold := 1  ; Minimum movement needed to trigger scroll
MouseMoved := false  ; Track if mouse has moved during right-click
TrackballScrollEnabled := true  ; Toggle for trackball scrolling functionality

; =============================================================================
; SIDE BUTTONS VARIABLES
; =============================================================================
SideButtonsDisabled := true
SideButtonMode := 2  ; 0 = disabled, 1 = normal (back/forward), 2 = page up/down

; =============================================================================
; TRACKBALL SCROLLING FUNCTIONALITY
; =============================================================================

; Right mouse button down - enter scroll mode
RButton::
    if (!TrackballScrollEnabled) {
        Send, {RButton}  ; Send normal right-click if scrolling is disabled
        return
    }
    ScrollMode := true
    MouseMoved := false
    MouseGetPos, LastX, LastY
    SetTimer, CheckMouseMovement, 10
    return

; Right mouse button up - exit scroll mode or show context menu
RButton Up::
    if (!TrackballScrollEnabled) {
        Send, {RButton Up}  ; Send normal right-click up if scrolling is disabled
        return
    }
    ScrollMode := false
    SetTimer, CheckMouseMovement, Off
    
    ; If mouse didn't move, send right-click to open context menu
    if (!MouseMoved) {
        Click, Right
    }
    return

; Check for mouse movement while in scroll mode
CheckMouseMovement:
    if (!ScrollMode)
        return
    
    MouseGetPos, CurrentX, CurrentY
    
    ; Calculate movement delta
    DeltaX := CurrentX - LastX
    DeltaY := CurrentY - LastY
    
    ; Only scroll if movement exceeds threshold
    if (Abs(DeltaY) > ScrollThreshold) {
        MouseMoved := true  ; Mark that mouse has moved
        
        ; Get window/control under cursor for precise scrolling
        MouseGetPos, vPosX, vPosY, hWnd,, 2
        
        ; Vertical scrolling (up/down)
        if (DeltaY > 0) {
            ; Mouse moved down - scroll down
            Loop, % Round(Abs(DeltaY) / Sensitivity) {
                PostMessage, 0x20A, % (-10)<<16, % vPosX|(vPosY<<16),, % "ahk_id " hWnd
            }
        } else {
            ; Mouse moved up - scroll up
            Loop, % Round(Abs(DeltaY) / Sensitivity) {
                PostMessage, 0x20A, % (10)<<16, % vPosX|(vPosY<<16),, % "ahk_id " hWnd
            }
        }
    }
    
    ; Horizontal scrolling (left/right)
    if (Abs(DeltaX) > ScrollThreshold) {
        MouseMoved := true  ; Mark that mouse has moved
        
        ; Get window/control under cursor for precise scrolling
        MouseGetPos, vPosX, vPosY, hWnd,, 2
        
        if (DeltaX > 0) {
            ; Mouse moved right - scroll right
            Loop, % Round(Abs(DeltaX) / Sensitivity) {
                PostMessage, 0x20E, % (10)<<16, % vPosX|(vPosY<<16),, % "ahk_id " hWnd
            }
        } else {
            ; Mouse moved left - scroll left
            Loop, % Round(Abs(DeltaX) / Sensitivity) {
                PostMessage, 0x20E, % (-10)<<16, % vPosX|(vPosY<<16),, % "ahk_id " hWnd
            }
        }
    }
    
    ; Reset mouse position to keep cursor in place during scroll mode
    MouseMove, LastX, LastY, 0
    
    return

; =============================================================================
; SIDE BUTTONS CUSTOMIZATION
; =============================================================================

; Press Ctrl+Alt+D to cycle through side button modes
^!d::
    SideButtonMode := SideButtonMode + 1
    if (SideButtonMode > 2) {
        SideButtonMode := 0
    }
    
    if (SideButtonMode = 0) {
        SideButtonsDisabled := true
        ToolTip, Side buttons DISABLED
        SetTimer, RemoveToolTip, 2000
    } else if (SideButtonMode = 1) {
        SideButtonsDisabled := false
        ToolTip, Side buttons: BACK/FORWARD mode
        SetTimer, RemoveToolTip, 2000
    } else if (SideButtonMode = 2) {
        SideButtonsDisabled := false
        ToolTip, Side buttons: PAGE UP/DOWN mode
        SetTimer, RemoveToolTip, 2000
    }
    return

; Conditional behavior based on mode
XButton1::
    if (SideButtonMode = 0) {
        return  ; Do nothing if disabled
    } else if (SideButtonMode = 1) {
        Send, {XButton1}  ; Send normal back button
    } else if (SideButtonMode = 2) {
        Send, {PgDn}  ; Send Page Down
    }
    return

XButton2::
    if (SideButtonMode = 0) {
        return  ; Do nothing if disabled
    } else if (SideButtonMode = 1) {
        Send, {XButton2}  ; Send normal forward button
    } else if (SideButtonMode = 2) {
        Send, {PgUp}  ; Send Page Up
    }
    return


; Toggle trackball scrolling functionality
^!s::
    TrackballScrollEnabled := !TrackballScrollEnabled
    if (TrackballScrollEnabled) {
        ToolTip, Trackball scrolling ENABLED
        SetTimer, RemoveToolTip, 2000
    } else {
        ToolTip, Trackball scrolling DISABLED
        SetTimer, RemoveToolTip, 2000
        ; If currently in scroll mode, exit it
        if (ScrollMode) {
            ScrollMode := false
            SetTimer, CheckMouseMovement, Off
        }
    }
    return

; =============================================================================
; VSCODE SHORTCUT FUNCTIONALITY
; =============================================================================

; Ctrl + Shift + V to open VSCode in current folder
^+v::
    WinGetClass, class, A
    if (class != "CabinetWClass" && class != "ExploreWClass") {
        return  ; Exit if not in Explorer
    }

    ; Get the current folder path from Explorer
    currentPath := Explorer_GetPath()
    
    ; VSCode executable path (update this to match your installation)
    vscodeExe := "C:\Users\" . A_UserName . "\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    
    ; Check if VSCode exists at this location
    if !FileExist(vscodeExe) {
        ; Try alternative locations
        if FileExist("C:\Program Files\Microsoft VS Code\Code.exe")
            vscodeExe := "C:\Program Files\Microsoft VS Code\Code.exe"
        else if FileExist("C:\Program Files (x86)\Microsoft VS Code\Code.exe")
            vscodeExe := "C:\Program Files (x86)\Microsoft VS Code\Code.exe"
        else {
            MsgBox, VSCode not found! Please check installation path.
            return
        }
    }
    
    ; Open VSCode
    if (currentPath != "")
        Run, "%vscodeExe%" "%currentPath%"
    else
        Run, "%vscodeExe%" .
return

; =============================================================================
; HELPER FUNCTIONS
; =============================================================================

; Function to get current Explorer path
Explorer_GetPath() {
    WinGetClass, class, A
    if (class = "CabinetWClass" || class = "ExploreWClass") {
        for window in ComObjCreate("Shell.Application").Windows {
            try {
                if (window.hwnd == WinActive("A")) {
                    return window.Document.Folder.Self.Path
                }
            }
        }
    }
    return ""
}

; Remove tooltip helper
RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return

; =============================================================================
; HOTKEYS AND EXIT
; =============================================================================

; Optional: Escape key to exit the script
; Esc::ExitApp

; =============================================================================
; SCRIPT INFORMATION
; =============================================================================
; Hotkeys summary:
; - Right-click + drag: Trackball scrolling (when enabled)
; - Ctrl+Alt+D: Cycle through side button modes (Disabled/Back-Forward/PageUp-PageDown)
; - Ctrl+Alt+S: Toggle trackball scrolling on/off
; - Ctrl+Shift+V: Open VSCode in current Explorer folder
; - Escape: Exit script
; =============================================================================
