ListLines 0 ; デバッグモードでスクリプトの履歴を表示する機能はオフ
SendMode "Input" ; 一番高速なキー入力処理
SetWorkingDir A_ScriptDir
KeyHistory 0
ProcessSetPriority "H"
SetWinDelay -1
SetControlDelay -1

#SingleInstance force ;同じスクリプトを一つだけ起動。
SetTitleMatchMode(2) ;中間一致。Autoexec section にないといけない。

; 消えてる場合もあるのでチェック
if (WinExist(A_Args[1])) {
  WinActivate(A_Args[1])
}
