# ahk-trackball-toys
AutoHotkeys v1 script to add custom functions to a trackball mouse 
  
## Features

- **Trackball Scrolling**: Hold right mouse button and drag to scroll vertically or horizontally. Cursor stays in place while scrolling. Can be toggled on/off.
- **Side Button Customization**: Optionally disable/enable side (XButton1/XButton2) mouse buttons with a hotkey.
- **VSCode Shortcut**: Open Visual Studio Code in the current Windows Explorer folder with a hotkey.

## Usage

1. Install [AutoHotkey v1](https://www.autohotkey.com/).
2. Edit `trackball-toys.ahk` if you need to change VSCode's path or sensitivity settings.
3. Run the script.

## Hotkeys

| Shortcut            | Function                                      |
|---------------------|-----------------------------------------------|
| Right-click + drag  | Trackball scrolling (when enabled)            |
| Ctrl+Alt+D          | Toggle side buttons on/off                    |
| Ctrl+Alt+S          | Toggle trackball scrolling on/off             |
| Ctrl+Shift+V        | Open VSCode in current Explorer folder        |
| Escape              | Exit script (if enabled)                      |

## Customization

- **Sensitivity**: Change the `Sensitivity` variable in the script to adjust scroll speed.
- **VSCode Path**: Update the `vscodeExe` variable if your VSCode is installed elsewhere.

## Notes

- Trackball scrolling only works when enabled and while holding the right mouse button.
- Side buttons can be disabled/enabled as needed.
- The VSCode shortcut works only in Windows Explorer windows.
