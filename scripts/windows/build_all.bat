@echo on

rem Rust 1.71.0 Windows toolchain required,
rem `rustup toolchain install 1.71.0-x86_64-pc-windows-msvc`.

set ROOT_DIR=%cd%\..\..

mkdir build

rmdir /s /q "%ROOT_DIR%\src\serai\target" 2>nul

cd "%ROOT_DIR%\src\serai\hrf" || exit
if "%IS_ARM%"=="true" (
    echo Building arm frostdart
    cargo +1.71.0 build --target aarch64-pc-windows-msvc --release --lib
    copy "..\target\x86_64-pc-windows-msvc\release\hrf_api.dll" "%ROOT_DIR%\scripts\windows\build\frostdart.dll"
) else (
    echo Building x86_64 frostdart
    cargo +1.71.0 build --target x86_64-pc-windows-msvc --release --lib
    copy "..\target\x86_64-pc-windows-msvc\release\hrf_api.dll" "%ROOT_DIR%\scripts\windows\build\frostdart.dll"
)
