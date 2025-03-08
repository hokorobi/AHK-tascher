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
  ; 除外するウィンドウ

  excludeWindows:= Map(
    "CLOCKPOD64.EXE", "",
  )
  ; 例:
  ; - タイトルが hoge と完全一致するすべてのプロセスを除外
  ; - タイトルが fuga と完全一致するすべてのプロセスを除外
  ; - piyo のプロセスでタイトルが a と完全一致するウィンドウを除外
  ; excludeWindows:= Map(
  ;   "", Map(
  ;     "hoge", "",
  ;     "fuga", "",
  ;   ),
  ;   "piyo", "a",
  ; )

  if (FileExist(listFile)) {
    FileDelete(listFile)
  }

  list := GenerateWindowList(appendPatterns, excludeWindows, activateAHK)
  FileAppend(list, listFile, "UTF-8")

  Run(Format('{} -N -U NONE -i NONE -u ~/vimfiles/vimrcLauncher -c "CtrlPLauncher! windows"', pathToVim))
  Loop {
    if (WinExist("vimLauncher")) {
      WinActivate()
      break
    }
    Sleep(50)
  }
}

GenerateWindowList(patterns, excludeWindows, activateAHK) {
  local list := ""
  idList := WinGetList(, , "Program Manager")
  for id in idList {
    title := WinGetTitle("ahk_id " id)
    if (title == "") {
      continue
    }

    process := WinGetProcessName("ahk_id " id)
    if (exclude(excludeWindows, process, title)) {
      continue
    }

    list .= Format(
      "{}{} - {}`tcall system(`'{} `"{}`"`')|quit`n",
      getAppendString(title, patterns), process, title, activateAHK, trimPeriod(title)
    )
  }
  return list
}

exclude(excludeWindows, process, title) {
  ; タイトルに完全一致するすべてのプロセスのウィンドウを除外
  if (excludeWindows.has("")) {
    if (excludeWindows[""].has(title)) {
      return true
    }
  }

  ; プロセス名に完全一致するウィンドウを除外
  if (excludeWindows.has(process)) {
    if (excludeWindows[process] == "") {
      return true
    } else if (excludeWindows[process] == title){
      ; ウィンドウタイトルも完全一致するウィンドウを除外
      return true
    }
  }

  return false
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
