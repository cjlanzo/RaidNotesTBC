@echo off
cls

set target=%1
set addon_folder="C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns\RaidNotesTBC"

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

if %target% == release (
    if exist release rmdir /Q /S release
    mkdir release
    mkdir release\RaidNotesTBC
    xcopy build release\RaidNotesTBC /E
)