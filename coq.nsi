; This script is used to build the Windows install program for Coq.

;NSIS Modern User Interface
;Written by Joost Verburg
;Modified by Julien Narboux and Pierre Letouzey

;SetCompress off
SetCompressor lzma
; Comment out after debuging.

; The VERSION should be passed as an argument at compile time using :
;

!define MY_PRODUCT "Coq" ;Define your own software name here
!define COQ_SRC_PATH "coq-src"
!define GTK_RUNTIME "/usr/i586-mingw32msvc/gtk"
!define OUTFILE "coq-installer-${VERSION}.exe"

!include "MUI.nsh"
!include "FileAssociation.nsh"

;--------------------------------
;Configuration

  Name "Coq"

  ;General
  OutFile "${OUTFILE}"

  ;Folder selection page
  InstallDir "$PROGRAMFILES\${MY_PRODUCT}"
  
  ;Remember install folder
  InstallDirRegKey HKCU "Software\${MY_PRODUCT}" ""

;Interface Configuration

;  !define MUI_HEADERIMAGE
;  !define MUI_HEADERIMAGE_BITMAP "coq_logo.bmp" ; optional
;  !define MUI_ABORTWARNING


;--------------------------------
;Modern UI Configuration

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "${COQ_SRC_PATH}/LICENSE"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH  

;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"
  
;--------------------------------
;Language Strings

  ;Description
  LangString DESC_1 ${LANG_ENGLISH} "This is the windows version of Coq."
  LangString DESC_2 ${LANG_ENGLISH} "This is CoqIde, an interactive development environment for Coq."
  LangString DESC_3 ${LANG_ENGLISH} "This will copy the GTK dlls in the installation directory (These files are needed by CoqIde)."

;--------------------------------
;Data
  
Function .onInit
  SetOutPath $TEMP
  File /oname=coq_splash.bmp "coq_splash.bmp"
	InitPluginsDir

  advsplash::show 1000 600 400 -1 $TEMP\coq_splash

  Pop $0 ; $0 has '1' if the user closed the splash screen early,
         ; '0' if everything closed normal, and '-1' if some error occured.

  Delete $TEMP\coq_splash.bmp
FunctionEnd


;--------------------------------
;Installer Sections


Section "Coq" Sec1

  ;ADD YOUR OWN STUFF HERE!

  SetOutPath "$INSTDIR\"

  SetOutPath "$INSTDIR\bin"
  File /oname=coqtop.exe ${COQ_SRC_PATH}\_build\toplevel\coqtop.native
  File /oname=coqchk.exe ${COQ_SRC_PATH}\_build\checker/main.native
  File /oname=csdpcert.exe ${COQ_SRC_PATH}\_build\plugins\micromega\csdpcert.native
  File /oname=coqdep.exe ${COQ_SRC_PATH}\_build\tools\coqdep.native
  File /oname=coqwc.exe ${COQ_SRC_PATH}\_build\tools\coqwc.native
  File /oname=coq_makefile.exe ${COQ_SRC_PATH}\_build\tools\coq_makefile.native
  File /oname=coq-tex.exe ${COQ_SRC_PATH}\_build\tools\coq_tex.native
  File /oname=gallina.exe ${COQ_SRC_PATH}\_build\tools\gallina.native
  File /oname=coqdoc.exe ${COQ_SRC_PATH}\_build\tools\coqdoc\main.native
  File /oname=coqc.exe ${COQ_SRC_PATH}\_build\scripts\coqc.native
  File /oname=coqmktop.exe ${COQ_SRC_PATH}\_build\scripts\coqmktop.native
  File /oname=mkwinapp.exe ${COQ_SRC_PATH}\_build\tools\mkwinapp.native
  File ${COQ_SRC_PATH}\ide\coq.ico
  File make.exe

  SetOutPath "$INSTDIR\lib\theories"
  File /r ${COQ_SRC_PATH}\theories\*.vo
  SetOutPath "$INSTDIR\lib\plugins"
  File /r ${COQ_SRC_PATH}\plugins\*.vo
  SetOutPath "$INSTDIR\lib"
  File /r ${COQ_SRC_PATH}\_build\*.cmxs
  File /r ${COQ_SRC_PATH}\_build\*.cmxa
  File /r ${COQ_SRC_PATH}\_build\*.cmi
  File /r ${COQ_SRC_PATH}\_build\*.a
   ; caveat! the current script builds only grammar.cma,
   ; hence only this one is installed for the moment
  File /r ${COQ_SRC_PATH}\_build\*.cma
   ; Clean the few .cmi installed directly in \lib
  Delete *.cmi
  SetOutPath "$INSTDIR\lib\config"
  File /r ${COQ_SRC_PATH}\_build\coq_config.cm* ${COQ_SRC_PATH}\_build\coq_config.o
  SetOutPath "$INSTDIR\lib\states"
  File ${COQ_SRC_PATH}\states\initial.coq
  SetOutPath "$INSTDIR\lib\tools\coqdoc"
  File ${COQ_SRC_PATH}\tools\coqdoc\coqdoc.sty
  File ${COQ_SRC_PATH}\tools\coqdoc\coqdoc.css
  SetOutPath "$INSTDIR\emacs"
  File ${COQ_SRC_PATH}\tools\*.el
  SetOutPath "$INSTDIR\man"
  File ${COQ_SRC_PATH}\man\*.1
  SetOutPath "$INSTDIR\dev"

  ;Store install folder
  WriteRegStr HKCU "Software\${MY_PRODUCT}" "" $INSTDIR
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coq" \
	  "DisplayName" "Coq Version ${VERSION}"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coq" \
	  "UninstallString" '"$INSTDIR\Uninstall.exe"'

  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coq" \
          "DisplayVersion" "${VERSION}"

  WriteRegDWORD HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coq" \
          "NoModify" "1"
  WriteRegDWORD HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coq" \
          "NoRepair" "1"

  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coq" \
          "URLInfoAbout" "http://coq.inria.fr"

; Start Menu Entries

; for the path in the .lnk
  SetOutPath "$INSTDIR" 

  CreateDirectory "$SMPROGRAMS\Coq"
  CreateShortCut "$SMPROGRAMS\Coq\Coq.lnk" "$INSTDIR\bin\coqtop.exe"
  WriteINIStr "$SMPROGRAMS\Coq\The Coq HomePage.url" "InternetShortcut" "URL" "http://coq.inria.fr"
  WriteINIStr "$SMPROGRAMS\Coq\The Coq Standard Library.url" "InternetShortcut" "URL" "http://coq.inria.fr/library"
  CreateShortCut "$SMPROGRAMS\Coq\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0

SectionEnd

Section "CoqIde" Sec2

  SetOutPath "$INSTDIR\config"
  File /oname=coqide-gtk2rc ${COQ_SRC_PATH}\ide\coqide-gtk2rc

  SetOutPath "$INSTDIR\share"
  File /oname=coq.png ${COQ_SRC_PATH}\ide\coq.png

  SetOutPath "$INSTDIR\bin"
  File /oname=coqide.exe ${COQ_SRC_PATH}\_build\ide\coqide_main.native

  ; Start Menu Entries
  SetOutPath "$INSTDIR"
  CreateShortCut "$SMPROGRAMS\Coq\CoqIde.lnk" "$INSTDIR\bin\coqide.exe"

  ${registerExtension} "$INSTDIR\bin\coqide.exe" ".v" "Coq Script File"

SectionEnd

Section  "The GTK DLLs (needed by CoqIde)" Sec3
  
  SetOutPath "$INSTDIR"
  ;File /r ${GTK_RUNTIME}\bin ${GTK_RUNTIME}\etc ${GTK_RUNTIME}\lib
  File /r ${GTK_RUNTIME}\etc
  SetOutPath "$INSTDIR\bin"
  File ${GTK_RUNTIME}\bin\*.dll
  SetOutPath "$INSTDIR\lib"
  File /r ${GTK_RUNTIME}\lib\gtk-2.0 ${GTK_RUNTIME}\lib\glib-2.0
  SetOutPath "$INSTDIR\share"
  File /r ${GTK_RUNTIME}\share\themes

SectionEnd

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec1} $(DESC_1)
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec2} $(DESC_2)
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec3} $(DESC_3)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
 
;--------------------------------
;Uninstaller Section

Section "Uninstall"

;; We keep the settings 
;; Delete "$INSTDIR\config\coqide-gtk2rc"
 
  RMDir /r "$INSTDIR\bin"
  RMDir /r "$INSTDIR\dev"
  RMDir /r "$INSTDIR\etc"
  RMDir /r "$INSTDIR\lib"
  RMDir /r "$INSTDIR\share"

  Delete "$INSTDIR\man\*.1"
  RMDir "$INSTDIR\man"

  Delete "$INSTDIR\emacs\*.el"
  RMDir "$INSTDIR\emacs"

;; Start Menu
  Delete "$SMPROGRAMS\Coq\Coq.lnk"
  Delete "$SMPROGRAMS\Coq\CoqIde.lnk"
  Delete "$SMPROGRAMS\Coq\Uninstall.lnk"
  Delete "$SMPROGRAMS\Coq\The Coq HomePage.url"
  Delete "$SMPROGRAMS\Coq\The Coq Standard Library.url"
  Delete "$INSTDIR\Uninstall.exe"
  
  DeleteRegKey /ifempty HKCU "Software\${MY_PRODUCT}"

  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Coq"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Coq"
  RMDir "$INSTDIR"
  RMDir "$SMPROGRAMS\Coq"

  ${unregisterExtension} ".v" "Coq Script File"

SectionEnd