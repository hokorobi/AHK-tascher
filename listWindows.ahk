; ListLines 0
; KeyHistory 0
; ProcessSetPriority "H"
; SetWinDelay -1
; SetControlDelay -1
; SendMode "Input"
; SetWorkingDir A_ScriptDir
; #SingleInstance Force
; SetTitleMatchMode(2) ; 中間一致

; listWindows()

listWindows() {
  pathToVim := "C:\path\to\gvim.exe"
  listFile := Format("{}\_vim\.ctrlp-launcher-windows", EnvGet("USERPROFILE"))
  ; .ahk は関連付け済みの想定
  activateAHK := Format("{}\activateWindow.ahk", A_ScriptDir)
  ; ウィンドウタイトルに含まれていたら追加する文字列
  appendPatterns := Map(
  "受信", "jushin",
  "予定", "yotei"
  )
  ; 除外するプロセス
  excludeProcesses:= Map(
  "CLOCKPOD64.EXE", "1"
  )

  list := GenerateWindowList(appendPatterns, excludeProcesses, activateAHK)

  if (FileExist(listFile)) {
    FileDelete(listFile)
  }
  FileAppend(list, listFile, "UTF-8")

  Run(Format('{} -N -U NONE -i NONE -u ~/vimfiles/vimrcLauncher -c "CtrlPLauncher! windows"', pathToVim))
}

GenerateWindowList(patterns, excludeProcesses, activateAHK) {
  local list := ""
  idList := WinGetList(, , "Program Manager")
  for id in idList {
    title := WinGetTitle("ahk_id " id)
    if (title == "") {
      continue
    }

    process := WinGetProcessName("ahk_id " id)
    if (excludeProcesses.has(process)) {
      continue
    }

    list .= Format(
      "{}{} - {}`tcall system(`'{} `"{}`"`')|quit`n",
      getAppendString(title, patterns), process, title, activateAHK, trimPeriod(title)
    )
  }
  return list
}

getAppendString(s, patterns) {
  for k, v in patterns {
    if (InStr(s, k)) {
      return Format("{} ", v)
    }
  }
  return ""
}

; ウィンドウタイトルに ' があると選択時にエラーになるので ' の出現位置以降を削除
trimPeriod(s) {
  pos := InStr(s, "`'")
  return (pos > 0) ? SubStr(s, 1, pos - 1) : s
}
