set PRO_MESON_DIR=c:\Users\user\AppData\Roaming\Python\Python311\Scripts\
set PRO_NINJA_DIR=c:\Users\user\AppData\Roaming\Python\Python311\Scripts\
set PRO_MINGW_DIR=p:\Qt\Tools\mingw1120_64\bin\
set PRO_GIT_DIR=C:\Program Files\Git\cmd

set PRO_GST_VERSION=1.22.4
set PRO_GST_DESCRIPTION=Default release for qt6

set PRO_INSTALL_PREFIX=%cd%\pro_install
set PRO_LOG=%PRO_INSTALL_PREFIX%\pro_gstreamer.txt

set PATH=%PRO_MESON_DIR%;%PRO_NINJA_DIR%;%PRO_MINGW_DIR%;%PRO_GIT_DIR%


md %PRO_INSTALL_PREFIX%

echo Prometheus gstreamer >> %PRO_LOG%
echo GstVersion: %PRO_GST_VERSION% >> %PRO_LOG%
echo ProDescription: %PRO_GST_DESCRIPTION% >> %PRO_LOG%
echo CompilatonStart: %date% %time% >> %PRO_LOG%

meson setup --buildtype=release --prefix=%PRO_INSTALL_PREFIX% builddir
if %errorlevel% neq 0 exit /b %errorlevel%

meson compile -C builddir
if %errorlevel% neq 0 exit /b %errorlevel%

meson install -C builddir
if %errorlevel% neq 0 exit /b %errorlevel%

echo CompilatonEnd: %date% %time% >> %PRO_LOG%
