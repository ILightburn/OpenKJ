echo on

SET project_dir="%cd%"

echo Set up environment...
set PATH=%QT%\bin\;C:\Qt\Tools\QtCreator\bin\;C:\Qt\QtIFW2.0.1\bin\;%PATH%
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" %PLATFORM%

mkdir "%project_dir%\cscrt
7z e "%project_dir%\installer\cscrt.7z" -p"%cscrt_pass%" -o"%project_dir%\cscrt"

echo Building OpenKJ...
qmake CONFIG-=debug CONFIG+=release
nmake

echo Packaging...
cd %project_dir%\build\windows\msvc\%LONGARCH%\release\
dir
windeployqt OpenKJ\release\OpenKJ.exe
echo Signing OpenKJ binary
signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /f "%project_dir%\cscrt\cscrt.pfx" /p "%pfx_pass%" OpenKJ\release\Openkj.exe

rd /s /q OpenKJ\moc\
rd /s /q OpenKJ\obj\
rd /s /q OpenKJ\qrc\

echo Copying project files for archival...
copy "%project_dir%\README.md" "OpenKJ\README.md"
copy "%project_dir%\LICENSE" "OpenKJ\LICENSE.txt"

echo Copying files for installer...
mkdir "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\"
robocopy OpenKJ\release\ "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data" /E /np
del "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\*.obj"
del "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\*.cpp"
del "%project_dir%\installer\windows\%LONGARCH\packages\org.openkj.openkj\data\*.h"


echo Pulling gstreamer deps for installer...
copy c:\gstreamer\1.0\%LONGARCH%\bin\*.dll "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\"
mkdir "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\lib"
mkdir "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\lib\gstreamer-1.0"
mkdir "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\lib\gstreamer-1.0\validate"
copy c:\gstreamer\1.0\%LONGARCH%\lib\gstreamer-1.0\*.dll "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\lib\gstreamer-1.0\"
copy c:\gstreamer\1.0\%LONGARCH%\lib\gstreamer-1.0\validate\*.dll "%project_dir%\installer\windows\%LONGARCH%\packages\org.openkj.openkj\data\lib\gstreamer-1.0\validate\"


rem echo Packaging portable archive...
rem 7z a -bd OpenKJ_%OKJVERSION%_windows_x86_64_portable.zip OpenKJ

echo Creating installer...
cd %project_dir%\installer\windows\%LONGARCH%\
dir
binarycreator.exe --offline-only -c config\config.xml -p packages OpenKJ-%OKJVERSION%-windows-%LONGARCH%-installer.exe
signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /f "%project_dir%\cscrt\cscrt.pfx" /p "%pfx_pass%" OpenKJ-%OKJVERSION%-windows-%LONGARCH%-installer.exe
