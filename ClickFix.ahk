; --- Load directives ---

#SingleInstance, force
#InstallMouseHook
SendMode, Input
SetWorkingDir %A_ScriptDir%

; --- Actual program ---

ver := "3.0.0"
settings_file = ClickFix_Settings.ini
startup_shortcut := A_Startup . "\ClickFix.lnk"
settings := Object()

; Initialize Settings in the following way:
; array[key]   := ["Section", "Key", "Value", "OPT: Other variables" ...]
settings["lb"] := ["Mouse", "left_button", false]
settings["mb"] := ["Mouse", "middle_button", false]
settings["rb"] := ["Mouse", "right_button", false]
settings["fb"] := ["Mouse", "forward_button", false]
settings["bb"] := ["Mouse", "back_button", false]
settings["lpr"] := ["General", "left_pressure", 25, "Left click"]
settings["mpr"] := ["General", "middle_pressure", 25, "Middle click"]
settings["rpr"] := ["General", "right_pressure", 25, "Right click"]
settings["bpr"] := ["General", "forward_pressure", 25, "Forward click"]
settings["fpr"] := ["General", "back_pressure", 25, "Back click"]
settings["sww"] := ["General", "startup_run", false]
settings["dis"] := ["General", "disabled", false]

; Initialize Last-click times
last_m_down := 0
last_m_up := 0

last_l_down := 0
last_l_up := 0

last_r_down := 0
last_r_up := 0

last_f_down := 0
last_f_up := 0

last_b_down := 0
last_b_up := 0

; Let's assume that this is a first-run, since there's no settings
if !FileExist(settings_file) {
    write_settings(settings)
    settingsGui()
    about()
}

; Initialize the program's functionality
read_settings(settings)

; Set up the right click menu
Menu, Tray, NoStandard

Menu, Tray, Add, About, about

Menu, options, Add, Fix Left Button, flb
Menu, options, Add, Fix Middle Button, fmb
Menu, options, Add, Fix Right Button, frb
Menu, options, Add, Fix Forward Button, ffb
Menu, options, Add, Fix Back Button, fbb
Menu, options, Add
Menu, options, Add, Start with Windows, sww
Menu, Tray, Add, Quick Options, :options
Menu, Tray, Add, Full Settings, settingsGui
Menu, Tray, Default, Full Settings


Menu, Tray, Add,
Menu, Tray, Add, Restart, restart
Menu, Tray, Add, Toggle Active, toggle_enabled
Menu, Tray, Add,
Menu, Tray, Add, Reset, reset
Menu, Tray, Add, Exit, exit
Menu, Tray, Tip, ClickFix - Tame your mouse

; Set the App Icon
setTrayIcon()

; Define the settings GUI
settingsGui() {
    global

    ; Initialization
    Gui, Settings: New
    Gui, Settings: -Resize -MaximizeBox +OwnDialogs

    ; Title and Copyright
    Gui, Settings:font, s19, Arial
    Gui, Settings:Add, Text, Center W500 yp-2, ClickFix Settings
    Gui, Settings:font, s8 c808080, Trebuchet MS
    Gui, Settings:Add, Text, Center W500 yp+28, Copyright (c) 2021 Jason Cemra

    ; Leading Paragraph
    Gui, Settings:font, s10 c101013, Arial
    Gui, Settings:Add, Text, Left W500 yp+16, Choose which mouse button needs fixing - you can select multiple.`nIf you're having issues, adjust the corresponding slider until your clicks are fixed, and`nRemember to click the Apply or Ok button!

    ; Standard Settings
    Gui, Settings:font, s8 c505050, Trebuchet MS
    Gui, Settings:Add, GroupBox, yp+49 w235 h210, Standard Settings
    Gui, Settings:font, s10 c10101f, Trebuchet MS
    Gui, Settings:Add, Text, Left w210 xp+12 yp+22, Choose mouse buttons to fix:
    Gui, Add, Checkbox, yp+25 vcheck_left_button gSettingsCheckBoxes, Left Click
    Gui, Add, Checkbox, yp+25 vcheck_middle_button gSettingsCheckBoxes, Middle Click
    Gui, Add, Checkbox, yp+25 vcheck_right_button gSettingsCheckBoxes, Right Click
    Gui, Add, Checkbox, yp+25 vcheck_forward_button gSettingsCheckBoxes, Forward Button
    Gui, Add, Checkbox, yp+25 vcheck_back_button gSettingsCheckBoxes, Back Button
    Gui, Settings:Add, Text, Left w210 yp+19, Other Settings:
    Gui, Add, Checkbox, yp+21 vcheck_start_with_windows, Start on Windows Startup
    Gui, Settings:font, s8 c810000, Arial
    Gui, Settings:Add, Button, yp+30 w236 xp-12 gSettingsButtonReset, Reset everything to default

    ; Buttons
    Gui, Settings:font, s8 c101013 w340, Arial
    Gui, Settings:Add, Button, Default xp Y338 w75, Ok
    Gui, Settings:Add, Button, xp+80 Y338 w75, Apply
    Gui, Settings:Add, Button, xp+80 Y338 w75, Cancel

    ; Advanced Settings
    Gui, Settings:font, s8 c505050, Trebuchet MS
    Gui, Settings:Add, GroupBox, xp+85 y92 w235 h275, Advanced/Tweaking Settings
    Gui, Settings:font, s10 c101013, Trebuchet MS
    Gui, Settings:Add, Text, Left w210 xp+12 yp+22, "Pressure" for each mouse button:
    Gui, Settings:font, s7 c101013 w700, Arial
    Gui, Settings:Add, Link, Left w210 yp+25 vslide_readout_l, Left click has 0ms of delay.
    Gui, Add, Slider, yp+13 xp-7 w218 vslide_pressure_l gSettingsPressureSlider, 20
    Gui, Settings:Add, Link, Left w210 yp+32 xp+7 vslide_readout_m, Middle click has 0ms of delay.
    Gui, Add, Slider, yp+13 xp-7 w218 vslide_pressure_m gSettingsPressureSlider, 20
    Gui, Settings:Add, Link, Left w210 yp+32 xp+7 vslide_readout_r, Right click has 0ms of delay.
    Gui, Add, Slider, yp+13 xp-7 w218 vslide_pressure_r gSettingsPressureSlider, 20
    Gui, Settings:Add, Link, Left w210 yp+32 xp+7 vslide_readout_f, Forward click has 0ms of delay.
    Gui, Add, Slider, yp+13 xp-7 w218 vslide_pressure_f gSettingsPressureSlider, 20
    Gui, Settings:Add, Link, Left w210 yp+32 xp+7 vslide_readout_b, Back click has 0ms of delay.
    Gui, Add, Slider, yp+13 xp-7 w218 vslide_pressure_b gSettingsPressureSlider, 20

    loadSettingsToGui()
    settingsCheckBoxes()
    Gui, show, W530 H380 center, ClickFix Settings

    ; Show a warning if the program is disabled
    If (settings["dis"][3]) {
        MsgBox, 0x30, Warning, ClickFix Disabled. Press Ctrl + Shift + ~ to toggle this.
    }
}

; GUI Actions
settingsCheckBoxes() {
    global
    Gui, Settings:Submit, NoHide
    GuiControl, Settings:Enable%check_left_button%, slide_pressure_l
    GuiControl, Settings:Enable%check_middle_button%, slide_pressure_m
    GuiControl, Settings:Enable%check_right_button%, slide_pressure_r
    GuiControl, Settings:Enable%check_forward_button%, slide_pressure_f
    GuiControl, Settings:Enable%check_back_button%, slide_pressure_b
    settingsPressureSlider()
}
settingsPressureSlider() {
    global
    bufferSlidePressure()
    GuiControl, Settings:, slide_readout_l, % slidePressureReadout(settings["lpr"], check_left_button)
    GuiControl, Settings:, slide_readout_m, % slidePressureReadout(settings["mpr"], check_middle_button)
    GuiControl, Settings:, slide_readout_r, % slidePressureReadout(settings["rpr"], check_right_button)
    GuiControl, Settings:, slide_readout_f, % slidePressureReadout(settings["fpr"], check_forward_button)
    GuiControl, Settings:, slide_readout_b, % slidePressureReadout(settings["bpr"], check_back_button)
}
settingsButtonOk() {
    if (pullSettingsFromGui()) {
        Gui, Settings:Destroy
    }
}
settingsButtonApply(){
    pullSettingsFromGui()
}
loadSettingsToGui(){
    global
    GuiControl, Settings:, check_left_button, % settings["lb"][3]
    GuiControl, Settings:, check_middle_button, % settings["mb"][3]
    GuiControl, Settings:, check_right_button, % settings["rb"][3]
    GuiControl, Settings:, check_forward_button, % settings["fb"][3]
    GuiControl, Settings:, check_back_button, % settings["bb"][3]
    GuiControl, Settings:, slide_pressure_l, % settings["lpr"][3]
    GuiControl, Settings:, slide_pressure_m, % settings["mpr"][3]
    GuiControl, Settings:, slide_pressure_r, % settings["rpr"][3]
    GuiControl, Settings:, slide_pressure_f, % settings["fpr"][3]
    GuiControl, Settings:, slide_pressure_b, % settings["bpr"][3]
    GuiControl, Settings:, slide_readout_l, % slidePressureReadout(settings["lpr"], settings["lb"][3])
    GuiControl, Settings:, slide_readout_m, % slidePressureReadout(settings["mpr"], settings["mb"][3])
    GuiControl, Settings:, slide_readout_r, % slidePressureReadout(settings["rpr"], settings["rb"][3])
    GuiControl, Settings:, slide_readout_f, % slidePressureReadout(settings["fpr"], settings["fb"][3])
    GuiControl, Settings:, slide_readout_b, % slidePressureReadout(settings["bpr"], settings["bb"][3])
    GuiControl, Settings:, check_start_with_windows, % settings["sww"][3]
}
pullSettingsFromGui(){
    global
    Gui, Settings:Submit, NoHide
    settings["lb"][3] := check_left_button
    settings["mb"][3] := check_middle_button
    settings["rb"][3] := check_right_button
    settings["fb"][3] := check_forward_button
    settings["bb"][3] := check_back_button
    bufferSlidePressure()
    settings["sww"][3] := check_start_with_windows
    save()
    update_sww_state(settings["sww"][3])
    updateTrayMenuState()
    return true
}

bufferSlidePressure() {
    global
    Gui, Settings:Submit, NoHide
    settings["lpr"][3] := slide_pressure_l
    settings["mpr"][3] := slide_pressure_m
    settings["rpr"][3] := slide_pressure_r
    settings["fpr"][3] := slide_pressure_f
    settings["bpr"][3] := slide_pressure_b
}

settingsButtonCancel(){
    Gui, Settings:Destroy
}
settingsButtonReset() {
    Gui, Settings: +OwnDialogs
    reset()
}
slidePressureReadout(obj, toggler=1) {
    suffix := "."
    if (slidePressureScale(obj[3]) >= 150 && toggler == 1) {
        suffix := "!"
    }
    if (toggler == 0) {
        value := "no delay (fix disabled)"
    } else {
        value := slidePressureScale(obj[3]) . "ms of delay"
    }
    return obj[4] . " has " . value . suffix
}
slidePressureScale(pressure){
    return Ceil(1.0202**(pressure + 250) - 140)
}
; Load in the menu state to reflect the settings
; Need a neater solution...
updateTrayMenuState(){
    global
    if (settings["lb"][3] == true) {
        Menu, options, Check, Fix Left Button
    } else {
        Menu, options, UnCheck, Fix Left Button
    }

    if (settings["mb"][3] == true) {
        Menu, options, Check, Fix Middle Button
    } else {
        Menu, options, UnCheck, Fix Middle Button
    }

    if (settings["rb"][3] == true) {
        Menu, options, Check, Fix Right Button
    } else {
        Menu, options, UnCheck, Fix Right Button
    }

    if (settings["fb"][3] == true) {
        Menu, options, Check, Fix Forward Button
    } else {
        Menu, options, UnCheck, Fix Forward Button
    }

    if (settings["bb"][3] == true) {
        Menu, options, Check, Fix Back Button
    } else {
        Menu, options, UnCheck, Fix Back Button
    }

    if (settings["sww"][3] == true) {
        Menu, options, Check, Start With Windows
    } else {
        Menu, options, UnCheck, Start With Windows
    }
}
setTrayIcon(){
    global 
    If (settings["dis"][3]) {
        Menu, Tray, Icon, ./icon/ClickFix-icon-disabled.ico
    } else {
        Menu, Tray, Icon, ./icon/ClickFix-icon.ico
    }
}

updateTrayMenuState()
Sleep, 500  ; There seems to be an issue with the startup shortcut disappearing
update_sww_state(settings["sww"][3])

; Use a hotkey to enable/disable the software functionality
toggle_enabled:
^+`::
settings["dis"][3] := !settings["dis"][3]
setTrayIcon()
save()
return


; Menu handlers - using labels to manipulate global variables
flb:
Menu, options, ToggleCheck, Fix Left Button
settings["lb"][3] := !settings["lb"][3]
save()
loadSettingsToGui()
return

fmb:
Menu, options, ToggleCheck, Fix Middle Button
settings["mb"][3] := !settings["mb"][3]
save()
loadSettingsToGui()
return

frb:
Menu, options, ToggleCheck, Fix Right Button
settings["rb"][3] := !settings["rb"][3]
save()
loadSettingsToGui()
return

ffb:
Menu, options, ToggleCheck, Fix Forward Button
settings["fb"][3] := !settings["fb"][3]
save()
loadSettingsToGui()
return

fbb:
Menu, options, ToggleCheck, Fix Back Button
settings["bb"][3] := !settings["bb"][3]
save()
loadSettingsToGui()
return

sww:
menu, options, ToggleCheck, Start With Windows
settings["sww"][3] := !settings["sww"][3]
save()
update_sww_state(settings["sww"][3])
loadSettingsToGui()
return

reset(){
    global
    MsgBox, 0x34, Are you sure?, This will completely wipe all settings and exit the program.
    IfMsgBox, No
        return
    FileDelete, %settings_file%
    startup_shortcut_destroy()
    ExitApp
}

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

about() {
    global ver
    Gui, Settings:+OwnDialogs
    MsgBox, 0x40, Welcome to ClickFix!, % "Thank you for using ClickFix!`n`nClickFix is always available from the taskbar tray area (if it's running). Remember, ClickFix makes an unusable mouse into a bearable one until a replacement can be made. You may experience issues with the mouse not clicking at times - simply right click on the tray icon to restart the program.`n`nThis software is at version " . ver . ".`nCopyright 2021 Jason Cemra - released under the GPLv3.`nSpecial thanks to the AutoHotKey crew, for making this program easy to write."
}

restart() {
    Reload
    ExitApp
}



; The real logic of the program - hotkeys triggered by mouse events
#If, settings["mb"][3] and !settings["dis"][3]
MButton::
if (A_TickCount - last_m_down >= slidePressureScale(settings["mpr"][3]) && A_TickCount - last_m_up >= slidePressureScale(settings["mpr"][3])) {
    Send {Blind}{MButton Down}
    last_m_down := A_TickCount
}
return

MButton up::
if (A_TickCount - last_m_up >= slidePressureScale(settings["mpr"][3])) {
    Send {Blind}{MButton Up}
    last_m_up := A_TickCount
}
return

#If, settings["lb"][3] and !settings["dis"][3]
LButton::
Critical
if (A_TickCount - last_l_down >= slidePressureScale(settings["lpr"][3]) && A_TickCount - last_l_up >= slidePressureScale(settings["lpr"][3])) {
    Send {Blind}{LButton Down}
    last_l_down := A_TickCount
}
return

LButton up::
if (A_TickCount - last_l_up >= slidePressureScale(settings["lpr"][3])) {
    Send {Blind}{LButton Up}
    last_l_up := A_TickCount
}
return

#If, settings["rb"][3] and !settings["dis"][3]
*RButton::
if (A_TickCount - last_r_down >= slidePressureScale(settings["rpr"][3]) && A_TickCount - last_r_up >= slidePressureScale(settings["rpr"][3])) {
    Send {Blind}{RButton Down}
    last_r_down := A_TickCount
}
return

*RButton up::
if (A_TickCount - last_r_up >= slidePressureScale(settings["rpr"][3])) {
    Send {Blind}{RButton Up}
    last_r_up := A_TickCount
}
return

#If, settings["fb"][3] and !settings["dis"][3]
*XButton2::
if (A_TickCount - last_f_down >= slidePressureScale(settings["fpr"][3]) && A_TickCount - last_f_up >= slidePressureScale(settings["fpr"][3])) {
    Send {Blind}{XButton2 Down}
    last_f_down := A_TickCount
}
return

*XButton2 up::
if (A_TickCount - last_f_up >= slidePressureScale(settings["fpr"][3])) {
    Send {Blind}{XButton2 Up}
    last_f_up := A_TickCount
}
return

#If, settings["bb"][3] and !settings["dis"][3]
*XButton1::
if (A_TickCount - last_b_down >= slidePressureScale(settings["bpr"][3]) && A_TickCount - last_b_up >= slidePressureScale(settings["bpr"][3])) {
    Send {Blind}{XButton1 Down}
    last_b_down := A_TickCount
}
return

*XButton1 up::
if (A_TickCount - last_b_up >= slidePressureScale(settings["bpr"][3])) {
    Send {Blind}{XButton1 Up}
    last_b_up := A_TickCount
}
return