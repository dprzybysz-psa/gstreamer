set PRO_MESON_DIR=C:\Users\user\AppData\Roaming\Python\Python311\Scripts\;
set PRO_NINJA_DIR=C:\Users\user\AppData\Roaming\Python\Python311\Scripts\;
set PRO_MINGW_DIR=P:\Qt\Tools\mingw810_64\bin\;
set PRO_PKGCONFIG_DIR=p:\lib\pkgconfig;
set PRO_PKG_CONFIG_PATH=p:\lib\x265\lib\pkgconfig;
set PRO_GIT_DIR=C:\Program Files\Git\cmd;
set PRO_PYTHON_DIR=C:\Program Files\Python311;

set PRO_GST_VERSION=1.22.4
set PRO_GST_DESCRIPTION=GPL release for qt5

set PRO_INSTALL_PREFIX=%cd%\pro_install
set PRO_LOG=%PRO_INSTALL_PREFIX%\pro_gstreamer.txt
set PRO_LICENSE_DIRNAME=license
set PRO_LICENSE_DIR=%PRO_INSTALL_PREFIX%\%PRO_LICENSE_DIRNAME%

set PRO_ORGINAL_LICENCE=%cd%\LICENSE
set PRO_CP_ORGINAL_LICENCE=%PRO_LICENSE_DIR%\LICENSE
set PRO_ORGINAL_LICENCE_SCAN_DIR=%cd%\subprojects

set PKG_CONFIG_PATH=%PRO_PKG_CONFIG_PATH%;
set PATH=%PRO_MESON_DIR%;%PRO_NINJA_DIR%;%PRO_MINGW_DIR%;%PRO_GIT_DIR%;%PRO_PKGCONFIG_DIR%;

md %PRO_INSTALL_PREFIX%

echo Prometheus gstreamer >> %PRO_LOG%
echo GstVersion: %PRO_GST_VERSION% >> %PRO_LOG%
echo|set /p="Commit: " >> %PRO_LOG%
git rev-parse HEAD >> %PRO_LOG%
echo ProDescription: %PRO_GST_DESCRIPTION% >> %PRO_LOG%
echo Host: %COMPUTERNAME% >> %PRO_LOG%
echo CompilatonStart: %date% %time% >> %PRO_LOG%

meson setup --buildtype=release --prefix=%PRO_INSTALL_PREFIX% -Dlicensedir=%PRO_LICENSE_DIRNAME% -Dgpl=enabled -Dugly=enabled -Dgst-plugins-ugly:x264=enabled -Dbad=enabled -Dgst-plugins-bad:x265=enabled builddir
if %errorlevel% neq 0 exit /b %errorlevel%

meson compile -C builddir
if %errorlevel% neq 0 exit /b %errorlevel%

meson install -C builddir
if %errorlevel% neq 0 exit /b %errorlevel%

echo CompilatonEnd: %date% %time% >> %PRO_LOG%

set PATH=%PATH%;%PRO_PYTHON_DIR%;

copy %PRO_ORGINAL_LICENCE% %PRO_CP_ORGINAL_LICENCE%
if %errorlevel% neq 0 exit /b %errorlevel%

python pro/licenseCollect.py %PRO_ORGINAL_LICENCE_SCAN_DIR% %PRO_LICENSE_DIR%
if %errorlevel% neq 0 exit /b %errorlevel%