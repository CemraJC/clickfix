#InstallMouseHook
#SingleInstance, force



ver := "1.1.2"
settings_file = ClickFix_Settings.ini
startup_shortcut := A_Startup . "\ClickFix.lnk"
settings := Object()

; Initialize Settings in the following way:
; array[key]   := ["Section", "Key", "Value"]
settings["lb"] := ["Mouse", "left_button", false]
settings["mb"] := ["Mouse", "middle_button", false]
settings["rb"] := ["Mouse", "right_button", false]
settings["sww"] := ["General", "startup_run", false]

; Let's assume that this is a first-run, since there's no settings
if !FileExist(settings_file) {
    write_settings(settings)
    about()
}

; Initialize the program's functionality
read_settings(settings)
set_hotkey_states()


; Set up the right click menu
Menu, Tray, NoStandard

Menu, Tray, Add, About, about

Menu, options, Add, Fix Left Button, flb
Menu, options, Add, Fix Middle Button, fmb
Menu, options, Add, Fix Right Button, frb
Menu, options, Add
Menu, options, Add, Start with Windows, sww
Menu, Tray, Add, Options, :options

Menu, Tray, Add,
Menu, Tray, Add, Reset, reset
Menu, Tray, Add, Exit, exit
Menu, Tray, Tip, ClickFix - Tame your mouse

settingsGui() {
    global check_left_button
    global check_middle_button
    global check_right_button
    global check_start_with_windows
    global slide_hysteresis

    ; Initialization
    Gui, Settings: New
    Gui, Settings: -Resize -MaximizeBox +AlwaysOnTop

    ; Title and Copyright
    Gui, Settings:font, s18, Arial
    Gui, Settings:Add, Text, Center W500, ClickFix Settings
    Gui, Settings:font, s8 c808080, Trebuchet MS
    Gui, Settings:Add, Text, Center W500 yp+26, Copyright (c) 2016 Jason Cemra

    ; Leading Paragraph
    Gui, Settings:font, s10 c101013, Arial
    Gui, Settings:Add, Text, Left W500 yp+22, Choose which mouse button needs fixing - you can select multiple.`nIf you're having issues, adjust the slider until your clicks are fixed!

    ; Standard Settings
    Gui, Settings:font, s8 c505050, Trebuchet MS
    Gui, Settings:Add, GroupBox, w235 h220, Standard Settings
    Gui, Settings:font, s10 c10101f, Trebuchet MS
    Gui, Settings:Add, Text, Left w210 xp+12 yp+22, Choose mouse buttons to fix:
    Gui, Add, Checkbox, yp+25 vcheck_left_button, Fix Left Mouse Button
    Gui, Add, Checkbox, yp+25 vcheck_middle_button, Fix Middle Mouse Button
    Gui, Add, Checkbox, yp+25 vcheck_right_button, Fix Right Mouse Button
    Gui, Settings:Add, Text, Left w210 yp+35, Other Settings:
    Gui, Add, Checkbox, yp+25 vcheck_start_with_windows, Start on Windows Startup
    Gui, Settings:font, s10 c810000, Arial
    Gui, Settings:Add, Button, yp+25 w210, Reset everything to default

    ; Advanced Settings
    Gui, Settings:font, s8 c505050, Trebuchet MS
    Gui, Settings:Add, GroupBox, xp+245 y112 w235 h190, Advanced
    Gui, Settings:font, s10 c101013, Trebuchet MS
    Gui, Settings:Add, Text, Left w210 xp+12 yp+22, Hysteresis Slider
    Gui, Add, Slider, yp+20 xp-6 w218 vslide_hysteresis, 20
    Gui, Settings:font, s8 c101013, Arial
    Gui, Settings:Add, Text, Left w210 yp+22 xp+6, Slide this more to the right if ClickFix isn't working properly all the time. Don't forget to hit "Apply" between changes.

    ; Buttons
    Gui, Settings:Add, Button, Default xp-12 Y310 w75, Ok
    Gui, Settings:Add, Button, xp+80 Y310 w75, Apply
    Gui, Settings:Add, Button, xp+80 Y310 w75, Cancel

    Gui, show, W530 H350 center, ClickFix Settings
}
settingsGui()


; Load in the menu state to reflect the settings
; Need a neater solution...
if (settings["lb"][3] == true) {
    Menu, options, Check, Fix Left Button
}

if (settings["mb"][3] == true) {
    Menu, options, Check, Fix Middle Button
}

if (settings["rb"][3] == true) {
    Menu, options, Check, Fix Right Button
}

if (settings["sww"][3] == true) {
    Menu, options, Check, Start With Windows
}

Sleep, 500  ; There seems to be an issue with the startup shortcut disappearing
update_sww_state(settings["sww"][3])
return



; Menu handlers - using labels to manipulate global variables
flb:
Menu, options, ToggleCheck, Fix Left Button
settings["lb"][3] := !settings["lb"][3]
save()
set_hotkey_states()
return

fmb:
Menu, options, ToggleCheck, Fix Middle Button
settings["mb"][3] := !settings["mb"][3]
save()
set_hotkey_states()
return

frb:
Menu, options, ToggleCheck, Fix Right Button
settings["rb"][3] := !settings["rb"][3]
save()
set_hotkey_states()
return

sww:
menu, options, ToggleCheck, Start With Windows
settings["sww"][3] := !settings["sww"][3]
save()
update_sww_state(settings["sww"][3])
return

reset:
MsgBox, 0x34, Are you sure?, This will completely wipe all settings and exit the program.
IfMsgBox, No
    return
FileDelete, %settings_file%
startup_shortcut_destroy()
ExitApp
return

exit:
save()
ExitApp
return



; Function definitions

save() {
    global settings
    write_settings(settings)
}

write_settings(settings) {
    global settings_file
    for index, var in settings {
        IniWrite, % var[3], %settings_file%, % var[1], % var[2]
    }
}

read_settings(ByRef settings) {
    global settings_file
    for index, var in settings {
        IniRead, buffer, %settings_file%, % var[1], % var[2]
        var[3] := buffer
    }
}

set_hotkey_states() {
    global settings
    if (settings["lb"][3] == true) {
        Hotkey, LButton, On
    } else {
        Hotkey, LButton, Off
    }

    if (settings["mb"][3] == true) {
        Hotkey, MButton, On
    } else {
        Hotkey, MButton, Off
    }

    if (settings["rb"][3] == true) {
        Hotkey, RButton, On
    } else {
        Hotkey, RButton, Off
    }
}

; Makes sure the settings are refleched
update_sww_state(state){
    global startup_shortcut
    if (state) {
        FileGetShortcut, %startup_shortcut%, shortcut_path
        if (!FileExist(startup_shortcut) || shortcut_path != A_ScriptFullPath) {
            startup_shortcut_create()
        }
    } else {
        startup_shortcut_destroy()
    }
}


startup_shortcut_create() {
    global startup_shortcut
    FileCreateShortcut, %A_ScriptFullPath%, %startup_shortcut%, %A_WorkingDir%
}

startup_shortcut_destroy() {
    global startup_shortcut
    FileDelete, %startup_shortcut%
}

about(){
global ver
MsgBox, 0x40, Welcome to ClickFix!, % "Thank you for using ClickFix!`n`nTo get started, simply right click on the tray icon and under 'Options', select the name of the button on your mouse that's giving you grief. You can also choose to start ClickFix with Windows here. ClickFix will run in the background, keeping a leash on your mouse. It is always available from the taskbar tray area (if it's running)`n`nThis software is at version " . ver . ".`nCopyright 2016 Jason Cemra - released under the GPLv3.`nVery special thanks to the AutoHotKey crew, for making this program easy."
}



; The real logic of the program - hotkeys triggered by mouse events
MButton::
Click Middle Down
is_down := 1
while (is_down) {
    Sleep 35
    is_down := GetKeyState("MButton", "P")
}
Sleep 50
Click Middle Up
return

LButton::
Click Left Down
is_down := 1
while (is_down) {
    Sleep 5
    is_down := GetKeyState("LButton", "P")
}
Sleep 10
Click Left Up
return

RButton::
Click Right Down
is_down := 1
while (is_down) {
    Sleep 5
    is_down := GetKeyState("RButton", "P")
}
Sleep 10
Click Right Up
return