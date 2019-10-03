::
::設定參數
::
::遠端主機 IP
SET @IP=34.219.6.193
::遠端主機儲存專案的路徑
SET @PP=/home/ubuntu/Topline.DesignEngine
::supervisor 上的專案名稱
SET @SN=Topline_DesignEngine_61110
::ppk 檔名
SET @PK=C:\AutoDeploy\TLDE\ubuntuDebug.ppk

echo - [x] 更新開始

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
echo %mydate%_%mytime%

echo 關閉 ubuntu 內 supervisor 的 %@SN% 程式
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu sudo supervisorctl stop %@SN%;

echo 刪除 ubuntu 目錄內的檔案
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu cd %@PP%; sudo rm -rfv *;

echo 刪除本機端 Release 檔案
del "ubuntuRelease.ppk"
del "appsettings.Release.json"

echo 複製檔案到 ubuntu 目錄內
pscp -r -C -i %@PK% -pw ubuntu *.* ubuntu@%@IP%:%@PP%

echo ubuntu 內 supervisor 重啟
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu sudo supervisorctl reload %@SN%;

::停5秒
@ping 127.0.0.1 -n 5 -w 1000 > nul

echo 刪除 ubuntu 目錄內的敏感檔案
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu cd %@PP%; sudo rm -rfv "ubuntuDebug.ppk";

echo ubuntu 內 %@SN% 重啟
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu sudo supervisorctl restart %@SN%;

echo - [x] 更新結束

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
echo %mydate%_%mytime%

exit 0
