@echo on
:: 启用延迟环境变量扩充
setlocal enabledelayedexpansion

:: 删除文件夹
for /d %%i in (D:\MachineLearning\tenant\training-*) do @rd /s /Q %%i

:: 下载新包
D:\programs\wget --no-check-certificate --no-proxy -P D:\MachineLearning\ -t 2 %artifact_url%

:: 解压zip包
cd /d D:\MachineLearning\
"C:\Program Files\7-Zip\7z.exe" x *.zip -y
"C:\Program Files\7-Zip\7z.exe" x *.zip -oD:\MachineLearning\ -y

:: 删除文件
cd /d D:\MachineLearning\
if exist "*.zip" (del *.zip)

:: 复制的例子
Xcopy D:\Config\MachineLearning\GDE_LLD_3VM.xlsx D:\MachineLearning\config\ /y
for /d %%i in (D:\MLStudio\tenant\SUM-*) do @Xcopy D:\Config\MLStudio\sum\input.json %%i\ /y

:: for和if联用的例子，判断某个文件夹存在，删除另一个文件夹并移动某文件夹过去
for /d %%i in (D:\MLStudio\tenant\studio-*) do (
    set a=%%i
    if exist !a! (
        for /d %%j in (D:\MachineLearning\tenant\studio-*) do @rd /s /Q %%j
        for /d %%k in (D:\MLStudio\tenant\studio-*) do @move /Y %%k D:\MachineLearning\tenant\
    )
)

:: 计算文件名称的字符个数
@echo on
set testPath="D:\工作任务\mockManasOneclickInstall\ManasOneClickInstall\GDE_1.3.0_TrainingService_1.3.0_Stack (1).zip"

:: 45 char
call :print %testPath%

:print
set file_name=%~n1
set /A N=0
pause
:LOOP
SET file_name=%file_name:~0,-1%
SET /A N=%N%+1
IF "%file_name%" EQU "" GOTO END
GOTO LOOP
:END
:: add .zip 4 char
SET /A N=%N%+4
echo %N%
pause

:: 下载文件夹
D:\programs\wget -r -np -nd --no-check-certificate --no-proxy -P D:\Config\ManasOneforClick\package\ -t 2 文件夹网址

:: 截取网址除了zip包名的前半段
@echo on
set testPath="D:\工作任务\mockManasOneclickInstall\ManasOneClickInstall\GDE_1.3.0_TrainingService_1.3.0_Stack (1).zip"
call :print %testPath%

:print
set file_name=%~n1
set file_name=%file_name%.zip
call set "file_path=%%testPath:%file_name%=%%"
echo %file_path%
pause

