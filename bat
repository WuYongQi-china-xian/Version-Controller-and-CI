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
