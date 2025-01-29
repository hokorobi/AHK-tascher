ListLines 0 ; デバッグモードでスクリプトの履歴を表示する機能はオフ
SendMode "Input" ; 一番高速なキー入力処理
SetWorkingDir A_ScriptDir
KeyHistory 0
ProcessSetPriority "H"
SetWinDelay -1
SetControlDelay -1

#SingleInstance force ;同じスクリプトを一つだけ起動。
SetTitleMatchMode(2) ;中間一致。Autoexec section にないといけない。

listfile := "C:\Users\username\vimfiles\rc\.ctrlp-launcher-windows"
activateAHK := A_ScriptDir . "\activateWindow.ahk"

list := ""
idList := WinGetList(, , "Program Manager")
for id in idList {
  title := WinGetTitle("ahk_id " id)
  process := WinGetProcessName("ahk_id " id)
  if (title != "") {
      list := list . process . " - " . title . "`tcall system(`'" . activateAHK . " `"" . title . "`"`')|quit`n"
  }
}
FileDelete(listfile)
FileAppend(list, listfile, "UTF-8")
Run('C:\vim\gvim.exe -c "CtrlPLaunch windows"')
ExitApp
