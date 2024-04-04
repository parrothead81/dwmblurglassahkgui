#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance
#Persistent
#NoTrayIcon
;tested on AutoHotKey v1.1.37.02

Version := "2.1.1 - GUI Mockup"

Gui, New, -Resize -MaximizeBox, % "DWMBlurGlass " . Version
Gui, Add, Tab3,, General|Advanced|Symbol|Config|About


; General
Gui, Add, Text, Section, Status: Installed
Gui, Add, Button, Disabled, Install
Gui, Add, Button, yp x+m, Uninstall			; yp = previous control's y position, x+m = previous control's right edge + margin width
Gui, Add, Text, yp x+m Disabled, |
Gui, Add, Button, yp x+m gSave, Save			; gSave means go to Save subroutine when clicked

Gui, Add, Text, xs y+m, Effect Settings
Gui, Add, CheckBox, vOverrideDWMAPI, Override DWMAPI effect (win11)		; vOverrideDWMAPI means value will be stored in variable OverrideDWMAPI
Gui, Add, CheckBox, Checked vExtendToBorders, Effects extend to borders (win10)
Gui, Add, CheckBox, Checked vAeroReflection, Enable Aero reflection effect
Gui, Add, CheckBox, Checked vDecreaseTitlebar, Decrease Titlebar button height (win7 style)
Gui, Add, CheckBox, Checked vBlurRadiusEnabled gEnableDisableBlurRadius, Blur radius (global):
Gui, Add, Slider, yp x+m vBlurRadius gUpdateBlurRadius Range0-50, 3
Gui, Add, Text, yp x+m vBlurRadiusValue, 100
GuiControl,, BlurRadiusValue, 3

Gui, Add, Text, xs, Light mode colors
Gui, Add, Text, xs y+m w150, Titlebar blend color (active):
Gui, Add, Edit, yp x+m w150 vActiveTitlebarColor, RGBA(80,80,80,136)
Gui, Add, Text, xs y+m w150, Titlebar blend color (inactive):
Gui, Add, Edit, yp x+m w150 vInactiveTitlebarColor, RGBA(80,80,80,80)
Gui, Add, Text, xs y+m w150, Active text color:
Gui, Add, Edit, yp x+m w150 vActiveTextColor, RGBA(0,0,0)
Gui, Add, Text, xs y+m w150, Inactive text color:
Gui, Add, Edit, yp x+m w150 vInactiveTextColor, RGBA(0,0,0)

Gui, Add, Text, xs y+20, Dark mode colors
Gui, Add, Text, xs y+m w150, Titlebar blend color (active):
Gui, Add, Edit, yp x+m w150 vDarkActiveTitlebarColor, RGBA(80,80,80,136)
Gui, Add, Text, xs y+m w150, Titlebar blend color (inactive):
Gui, Add, Edit, yp x+m w150 vDarkInactiveTitlebarColor, RGBA(80,80,80,80)
Gui, Add, Text, xs y+m w150, Active text color:
Gui, Add, Edit, yp x+m w150 vDarkActiveTextColor, RGBA(0,0,0)
Gui, Add, Text, xs y+m w150, Inactive text color:
Gui, Add, Edit, yp x+m w150 vDarkInactiveTextColor, RGBA(0,0,0)

;Gui, Add, Text, xs y+20, Preview
;Gui, Add, Picture, w350 h-1, ????????

; Advanced
Gui, Tab, 2
Gui, Add, Text, Section w150, Blur Method:
Gui, Add, DropDownList, yp x+m vBlurMethod gBlurMethodScreenUpdate AltSubmit Choose1 w170	; Choose1 picks first option by default
	, CustomBlur (IComposition)|OldBlur (AccentBlurBehind)|DWMAPI (SystemBackdrop)
customblurtext := "[Recommended] Custom blur implementation written by CVisual (DWM) ... test wordwrap: aaaaaaaaaa aaaaaa aaaaaaaaaaaaa aaaaaaaaaaa aaaaaaaaaaaabb"
oldblurtext := "[Not Recommended] Use DWM internal blur..."
dwmapiblurtext := "Use documented DWMAPI to apply limited SystemBackdrop efect...."
Gui, Add, Text, xs y+m w350 vBlurMethodDescription, %customblurtext%

Gui, Add, Text, xs y+20 w150, Effect Type:
Gui, Add, DropDownList, yp x+m vEffectType gEffectTypeUpdate AltSubmit Choose1
	, Blur|Aero|Acrylic|Mica

Gui, Add, Text, xs y+m vBlurRadiusAdvancedText, Blur radius (titlebar only):
Gui, Add, Slider, yp x+m w100 vBlurRadiusAdvanced gUpdateBlurRadiusAdvanced Range0-50, 3
Gui, Add, Text, yp x+m vBlurRadiusAdvancedValue, 100
GuiControl,, BlurRadiusAdvancedValue, 3

Gui, Add, Text, xs y+30 vLuminosityOpacityText,Luminosity Opacity (`%)
Gui, Add, Slider, yp x+m w200 vLuminosityOpacity gUpdateLuminosityOpacity Range0-100, 65
Gui, Add, Text, yp x+m vLuminosityOpacityValue, 100
GuiControl,, LuminosityOpacityValue, 65
;default is blur so hide luminosity opacity
GuiControl, Hide, LuminosityOpacityText
GuiControl, Hide, LuminosityOpacity
GuiControl, Hide, LuminosityOpacityValue


; Symbol
Gui, Tab, 3
; stuff goes here


; Config
Gui, Tab, 4
; stuff goes here


; About
Gui, Tab, 5
; stuff goes here


Gui, Show
Loop
{
	Sleep, 100	; prevents automatically executing the subroutines below
}





Save:
	Gui, Submit, NoHide	; update variable values
	MsgBox, % "Test message: Current blur radius is " . BlurRadius
	; DllCall the necessary stuff here
Return

BlurMethodScreenUpdate:
	Gui, Submit, NoHide
	If (BlurMethod = 1)
		GuiControl,, BlurMethodDescription, %customblurtext%
	Else If (BlurMethod = 2)
		GuiControl,, BlurMethodDescription, %oldblurtext%
	Else If (BlurMethod = 3)
		GuiControl,, BlurMethodDescription, %dwmapiblurtext%
	;Rewrite effect type options
Return

EffectTypeUpdate:
	Gui, Submit, NoHide
	If (EffectType = 1 || EffectType = 2)
	{
		GuiControl, Hide, LuminosityOpacityText
		GuiControl, Hide, LuminosityOpacity
		GuiControl, Hide, LuminosityOpacityValue
		GuiControl, Enable, BlurRadiusAdvanced
		GuiControl, Enable, BlurRadiusAdvancedValue
		GuiControl, Enable, BlurRadiusAdvancedText
	} Else If (EffectType = 3) ; Acrylic
	{
		GuiControl, Show, LuminosityOpacityText
		GuiControl, Show, LuminosityOpacity
		GuiControl, Show, LuminosityOpacityValue
		GuiControl, Enable, BlurRadiusAdvanced
		GuiControl, Enable, BlurRadiusAdvancedValue
		GuiControl, Enable, BlurRadiusAdvancedText
	} Else If (EffectType = 4) ; Mica
	{
		GuiControl, Show, LuminosityOpacityText
		GuiControl, Show, LuminosityOpacity
		GuiControl, Show, LuminosityOpacityValue
		GuiControl, Disable, BlurRadiusAdvanced
		GuiControl, Disable, BlurRadiusAdvancedValue
		GuiControl, Disable, BlurRadiusAdvancedText
	}
Return

UpdateBlurRadius:			; on General tab
	Gui, Submit, NoHide
	GuiControl,, BlurRadiusValue, % BlurRadius
Return

UpdateBlurRadiusAdvanced:
	Gui, Submit, NoHide
	GuiControl,, BlurRadiusAdvancedValue, % BlurRadiusAdvanced
Return

UpdateLuminosityOpacity:
	Gui, Submit, NoHide
	GuiControl,, LuminosityOpacityValue, % LuminosityOpacity 
Return

EnableDisableBlurRadius:
	Gui, Submit, NoHide	
	If (BlurRadiusEnabled = 1)
	{
		GuiControl, Enable, BlurRadius
		GuiControl, Enable, BlurRadiusValue
	} Else {
		GuiControl, Disable, BlurRadius
		GuiControl, Disable, BlurRadiusValue
	}
Return

GuiClose:
ExitApp
;Reload