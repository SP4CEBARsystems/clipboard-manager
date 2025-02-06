#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global register := []
global bank := 0

register := [] 
Loop, 100
    register[A_Index - 1] := "Empty"

showIndicator()

^+1::copyToRegister(1)
^1::pasteFromRegister(1)
^+2::copyToRegister(2)
^2::pasteFromRegister(2)
^+3::copyToRegister(3)
^3::pasteFromRegister(3)
^+4::copyToRegister(4)
^4::pasteFromRegister(4)
^+5::copyToRegister(5)
^5::pasteFromRegister(5)
^+6::copyToRegister(6)
^6::pasteFromRegister(6)
^+7::copyToRegister(7)
^7::pasteFromRegister(7)
^+8::copyToRegister(8)
^8::pasteFromRegister(8)
^+9::copyToRegister(9)
^9::pasteFromRegister(9)
^+0::copyToRegister(0)
^0::pasteFromRegister(0)
^=::nextBank()
^-::previousBank()

copyToRegister(index)
{
	global register
	global bank
	Clipboard := ""
	send ^c
	ClipWait, 5 ; Wait for max. 5 seconds
	register[bank*10 + index-1] := clipboard
	updateIndicator()
}

pasteFromRegister(index)
{
	global register
	global bank
	clipboard := register[bank*10 + index-1]
	send ^v
	updateIndicator()
}

nextBank(){
	global bank
	bank := Min(bank + 1, 10)
	updateIndicator()
}

previousBank(){
	global bank
	bank := Max(bank - 1, 0)
	updateIndicator()
}

showIndicator(){
	; source: https://www.autohotkey.com/boards/viewtopic.php?style=1&t=96934#p430774
	global vMyEdit
	Gui, +LastFound +AlwaysOnTop
	Gui, % CLICKTHROUGH := "+E0x20"
	Gui, Color, F0F0F0
	Gui, Font, s0,
	Gui, Add, Edit, vMyEdit w200 h220 -E0x200
	Gui, Font, s15, Verdana
	updateIndicator()
	Gui, Show, x1600 y100 NoActivate
}

updateIndicator(){
	global bank
	global register
	global MyEdit
	contents := ""
	loop, 10 {
		contents .= "`n" . A_Index . ": " . register[bank*10 + A_Index - 1]
	}
	GuiControl,, MyEdit, Bank: %bank% contains %contents%
}