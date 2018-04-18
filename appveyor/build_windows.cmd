echo on

SET project_dir="%cd%"

echo Set up environment...
set PATH=%QT%\bin\;C:\Qt\Tools\QtCreator\bin\;C:\Qt\QtIFW2.0.1\bin\;%PATH%
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" %PLATFORM%

echo Building OpenKJ...
qmake CONFIG-=debug CONFIG+=release
nmake

echo Running tests...

echo Packaging...
cd %project_dir%\build\windows\msvc\x86_64\release\
windeployqt OpenKJ\OpenKJ.exe

rd /s /q OpenKJ\moc\
rd /s /q OpenKJ\obj\
rd /s /q OpenKJ\qrc\

echo Copying project files for archival...
copy "%project_dir%\README.md" "OpenKJ\README.md"
copy "%project_dir%\LICENSE" "OpenKJ\LICENSE.txt"

echo Copying files for installer...
mkdir "%project_dir%\installer\windows\x86_64\packages\org.openkj.openkj\data\"
robocopy OpenKJ\ "%project_dir%\installer\windows\x86_64\packages\org.openkj.openkj\data" /E

echo Packaging portable archive...
7z a OpenKJ_%TAG_NAME%_windows_x86_64_portable.zip OpenKJ

echo Creating installer...
cd %project_dir%\installer\windows\x86_64\
binarycreator.exe --offline-only -c appveyor\config.xml -p packages OpenKJ_%TAG_NAME%_windows_x86_64_installer.exe
