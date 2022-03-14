# RaidNotesTBC

## Overview

RaidNotesTBC is an addon that allows you to set personal raid notes for each boss within all TBC raids. Additionally, you can set notes for trash sections that come before each boss. The addon will handle progressing the notes as you clear the instance.

## Usage

* Click on the Murloc minimap icon to open the editor
* Click on a raid and boss that you want to edit and add notes for trash and/or boss and click accept
* With the editor open - drag/resize the notes pane (this is where notes will show up)
* When you enter an instance that it recognizes it will display notes for the first boss
* As you progress through the instance it will automatically update which notes are displayed. Triggers include when a boss begins, ends, or is targeted

## Todo

* Make notes advance to the next trash section as a boss encounter begins (so you see current boss and the trash after it rather than before)
* Clean up editor to show name of boss that is being edited. Also hide the edit boxes unless a boss is selected
* Open editor to the current boss for the current zone
* Organize the raids in a more logical order
* Allow customization of boss routing with an instance
* Add options to allow customization of font size, notes opacity, etc
* Add version outdated notification on login

## Known Issues

* Trying to save notes without selecting a raid and boss results in an error and nothing happens
* Notes can be dragged off screen and it causes them to disappear. If you reload your UI it will reappear as a workaround for now
* Boss notes don't take the spot of Trash notes when they are missing and it shows a gap
* Targeting a boss where the boss name is not the same as the encounter name (Illidari Council, Reliquary of Souls, etc) does not update the notes properly