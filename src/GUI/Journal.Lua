local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f

local function createTree()
    local sortedInstances = sortBy(asArray(instancesDb), function (instance) return instance.instanceIndex end)

    return map(sortedInstances, function(instance)
        local sortedEncounters = 
            sortBy(instanceEncountersLookup[instance.instanceID], function(e) 
                return e.encounterIndex
            end)

        return {
            ["text"] = instance.instanceName,
            ["value"] = instance.instanceID,
            ["children"] = map(sortedEncounters, function(encounter)
                return {
                    ["text"]  = encounter.encounterName,
                    ["value"] = encounter.encounterID,
                }
            end)
        }
    end)
end

function RaidNotes:InitJournal()
    f = AceGUI:Create("Frame")
    f:Hide()
    f:SetWidth(860)
    f:SetHeight(500)
    f:SetLayout("Flow")
    f:EnableResize(false)
    f:SetTitle(ADDON_NAME)

    hooksecurefunc(f, "Hide", function(self) 
        if not RaidNotes:ShouldDisplayNotes() then RaidNotes:HideNotes() end
        RaidNotes:LockNotes() 
    end)

    _G[ADDON_NAME.."MainFrame"] = f
    table.insert(UISpecialFrames, ADDON_NAME.."MainFrame") -- close on escape

    local treeGroup = AceGUI:Create("TreeGroup")
    treeGroup:SetFullWidth(true)
    treeGroup:SetFullHeight(true)
    treeGroup:SetTree(createTree())

    local function loadData(self, key)
        debugPrint(string.format("Loading data for %s", key))

        local encounterID = getEncounterFromKey(key)

        if encounterID then treeGroup.content:Show() else treeGroup.content:Hide(); return end

        local encounter = encountersDb[encounterID]
        local notes = getEncounterNotes(encounterID)

        _G["TrashEditBox"]:SetLabel(string.format("%s Trash", encounter.encounterName))
        _G["BossEditBox"]:SetLabel(encounter.encounterName)

        _G["TrashEditBox"].editBox:SetText(notes.trash or "")
        _G["BossEditBox"].editBox:SetText(notes.boss or "")

        RaidNotes:DisplayNotes(encounterAsNotes(encounter))
    end

    hooksecurefunc(treeGroup, "SetSelected", loadData)

    f:AddChild(treeGroup)

    RaidNotes:CreateNotesEdit(treeGroup, "Trash")
    RaidNotes:CreateNotesEdit(treeGroup, "Boss")

    treeGroup.content:Hide()
end

function RaidNotes:CreateNotesEdit(parent, name)
    local editBox = AceGUI:Create("MultiLineEditBox")
    _G[name.."EditBox"] = editBox
    editBox:SetRelativeWidth(1)
    editBox:SetNumLines(11)
    parent:AddChild(editBox)

    -- figure out if we can replace this with a hooksecurefunc without having to duplicate the code
    editBox.button:SetScript("OnClick", function(self)
        self = self.obj
        self.editBox:ClearFocus()

        local encounterID = getEncounterFromKey(parent.localstatus.selected)
        local noteType = contains(self.label:GetText(), "Trash") and "trash" or "boss"
        local noteValue = self:GetText()

        debugPrint(string.format("Setting '%s' encounter notes for %d to '%s'", noteType, encounterID, noteValue))

        setEncounterNotes(encounterID, { [noteType] = noteValue })
        RaidNotes:DisplayNotes(encounterAsNotes(encountersDb[encounterID]))

        if not self:Fire("OnEnterPressed", self.editBox:GetText()) then
            self.button:Disable()
        end
    end)
end

function RaidNotes:ShowJournal()
    if not f then self:InitJournal() end

    f:Show()
    RaidNotes:ShowNotes()
    RaidNotes:UnlockNotes()
end

function RaidNotes:HideJournal()
    if not RaidNotes:ShouldDisplayNotes() then RaidNotes:HideNotes() end
    RaidNotes:LockNotes()
    f:Hide() 
end

function RaidNotes:ToggleJournal()
    if f and f:IsShown() then
        self:HideJournal()
    else
        self:ShowJournal()
    end
end