::
::�]�w�Ѽ�
::
::���ݥD�� IP
SET @IP=34.219.6.193
::���ݥD���x�s�M�ת����|
SET @PP=/home/ubuntu/Topline.DesignEngine
::supervisor �W���M�צW��
SET @SN=Topline_DesignEngine_61110
::ppk �ɦW
SET @PK=C:\AutoDeploy\TLDE\ubuntuDebug.ppk

echo - [x] ��s�}�l

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
echo %mydate%_%mytime%

echo ���� ubuntu �� supervisor �� %@SN% �{��
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu sudo supervisorctl stop %@SN%;

echo �R�� ubuntu �ؿ������ɮ�
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu cd %@PP%; sudo rm -rfv *;

echo �R�������� Release �ɮ�
del "ubuntuRelease.ppk"
del "appsettings.Release.json"

echo �ƻs�ɮר� ubuntu �ؿ���
pscp -r -C -i %@PK% -pw ubuntu *.* ubuntu@%@IP%:%@PP%

echo ubuntu �� supervisor ����
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu sudo supervisorctl reload %@SN%;

::��5��
@ping 127.0.0.1 -n 5 -w 1000 > nul

echo �R�� ubuntu �ؿ������ӷP�ɮ�
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu cd %@PP%; sudo rm -rfv "ubuntuDebug.ppk";

echo ubuntu �� %@SN% ����
plink -ssh -i %@PK% ubuntu@%@IP% -pw ubuntu sudo supervisorctl restart %@SN%;

echo - [x] ��s����

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
echo %mydate%_%mytime%

exit 0
