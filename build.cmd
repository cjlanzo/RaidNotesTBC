@echo off
cls

set target=%1
set addon_folder="C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns\RaidNotes"
set ptr_addon_folder="C:\Program Files (x86)\World of Warcraft\_classic_ptr_\Interface\AddOns\RaidNotes"

if exist build rmdir /Q /S build
mkdir build
mkdir build\Libs

xcopy src build
xcopy src\GUI build /E
xcopy src\Libs build\Libs /E
copy RELEASE_NOTES.md build
copy README.md build

if %target% == publish (
    if exist %addon_folder% rmdir /Q /S %addon_folder%
    mkdir %addon_folder%
    xcopy build %addon_folder% /E
)

if %target% == ptr_publish (
    if exist %ptr_addon_folder% rmdir /Q /S %ptr_addon_folder%
    mkdir %ptr_addon_folder%
    xcopy build %ptr_addon_folder% /E
)

if %target% == release (
    if exist release rmdir /Q /S release
    mkdir release
    mkdir release\RaidNotes
    xcopy build release\RaidNotes /E
)