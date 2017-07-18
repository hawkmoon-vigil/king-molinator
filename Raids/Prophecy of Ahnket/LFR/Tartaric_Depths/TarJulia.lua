-- TarJulia Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOATDTAR_Settings = nil
chKBMPOATDTAR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["Tartaric_Depths"]

local TAR = {
    Directory = Instance.Directory,
    File = "TarJulia.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "TarJulia",
    Object = "TAR",
}

-- Main Unit Dictionary
TAR.Lang.Unit = {}
TAR.Lang.Unit.TarJulia = KBM.Language:Add("TarJulia")
TAR.Lang.Unit.TarJulia:SetFrench("TarJulia")
TAR.Lang.Unit.TarJulia:SetGerman("Tarjulia")

TAR.Lang.Unit.Soul = KBM.Language:Add("Infernal Soul")
TAR.Lang.Unit.Soul:SetFrench("Âme infernale")
TAR.Lang.Unit.Soul:SetGerman("Infernalische Seele")

TAR.TarJulia = {
    Mod = TAR,
    Level = "??",
    Active = false,
    Name = TAR.Lang.Unit.TarJulia[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    MechRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U1218D6C904266DB4",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
            Enabled = true,
            MoltenBlast = KBM.Defaults.AlertObj.Create("red"),
            CallForHelp = KBM.Defaults.AlertObj.Create("blue"),
            Fury = KBM.Defaults.AlertObj.Create("orange"),
            SpiderWeave = KBM.Defaults.AlertObj.Create("purple"),
        },
        TimersRef = {
            Enabled = true,
            MoltenBlast = KBM.Defaults.TimerObj.Create("red"),
            FirstMoltenBlast = KBM.Defaults.TimerObj.Create("red"),
            CallForHelp = KBM.Defaults.TimerObj.Create("blue"),
            FirstCallForHelp = KBM.Defaults.TimerObj.Create("blue"),
            SpiderWeave = KBM.Defaults.TimerObj.Create("purple"),
            FirstSpiderWeave = KBM.Defaults.TimerObj.Create("purple"),
            Fury = KBM.Defaults.TimerObj.Create("orange"),
            FirstFury = KBM.Defaults.TimerObj.Create("orange"),
        },		
        MechRef = {
			Enabled = true,
			SpiderWeave = KBM.Defaults.MechObj.Create("red"),
		}
    },
}

TAR.Soul = {
    Mod = TAR,
    Level = "72",
    Name = TAR.Lang.Unit.Soul[KBM.Lang],
    NameShort = "Infernal Soul",
    UnitList = {},
    Menu = {},
    UTID = "U60B1A0B31BAFAC42",
    Ignore = true,
    Type = "multi",
}

KBM.RegisterMod(TAR.ID, TAR)

-- Ability Dictionary
TAR.Lang.Ability = {}
TAR.Lang.Ability.MoltenBlast = KBM.Language:Add("Molten Blast")
TAR.Lang.Ability.MoltenBlast:SetFrench("Explosion de magma")
TAR.Lang.Ability.MoltenBlast:SetGerman("Geschmolzene Explosion")

TAR.Lang.Ability.CallForHelp = KBM.Language:Add("Call for Help")

-- Verbose Dictionary
TAR.Lang.Verbose = {}
TAR.Lang.Verbose.MoltenBlast = KBM.Language:Add("Go to a pillar!")
TAR.Lang.Verbose.MoltenBlast:SetFrench("Allez au pillier!")
TAR.Lang.Verbose.MoltenBlast:SetGerman("Geh zur Säule!")

-- Buff Dictionary
TAR.Lang.Buff = {}
TAR.Lang.Buff.Fury = KBM.Language:Add("Fury")

-- Debuff Dictionary
TAR.Lang.Debuff = {}
TAR.Lang.Debuff.SpiderWeave = KBM.Language:Add("Spider's Weave")

TAR.Lang.Notify = {}

-- Menu Dictionary
TAR.Lang.Menu = {}
TAR.Lang.Menu.FirstMoltenBlast = KBM.Language:Add("First " .. TAR.Lang.Ability.MoltenBlast[KBM.Lang])
TAR.Lang.Menu.FirstMoltenBlast:SetFrench("Première " .. TAR.Lang.Ability.MoltenBlast[KBM.Lang])
TAR.Lang.Menu.FirstCallForHelp = KBM.Language:Add("First " .. TAR.Lang.Ability.CallForHelp[KBM.Lang])
TAR.Lang.Menu.FirstCallForHelp:SetFrench("Première " .. TAR.Lang.Ability.CallForHelp[KBM.Lang])
TAR.Lang.Menu.FirstFury = KBM.Language:Add("First " .. TAR.Lang.Buff.Fury[KBM.Lang])
TAR.Lang.Menu.FirstFury:SetFrench("Première " .. TAR.Lang.Buff.Fury[KBM.Lang])
TAR.Lang.Menu.FirstSpiderWeave = KBM.Language:Add("First " .. TAR.Lang.Debuff.SpiderWeave[KBM.Lang])
TAR.Lang.Menu.FirstSpiderWeave:SetFrench("Première " .. TAR.Lang.Debuff.SpiderWeave[KBM.Lang])

-- Description Dictionary
TAR.Lang.Main = {}
TAR.Descript = TAR.Lang.Unit.TarJulia[KBM.Lang]

function TAR:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.TarJulia.Name] = self.TarJulia,
        [self.Soul.Name] = self.Soul,
    }
end

function TAR:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.TarJulia.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        -- TimersRef = self.Baird.Settings.TimersRef,
        AlertsRef = self.TarJulia.Settings.AlertsRef,
        MechSpy = KBM.Defaults.MechSpy(),
    }
    KBMPOATDTAR_Settings = self.Settings
    chKBMPOATDTAR_Settings = self.Settings

end

function TAR:SwapSettings(bool)

    if bool then
        KBMPOATDTAR_Settings = self.Settings
        self.Settings = chKBMPOATDTAR_Settings
    else
        chKBMPOATDTAR_Settings = self.Settings
        self.Settings = KBMPOATDTAR_Settings
    end

end

function TAR:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOATDTAR_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOATDTAR_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOATDTAR_Settings = self.Settings
    else
        KBMPOATDTAR_Settings = self.Settings
    end 
end

function TAR:SaveVars()
    if KBM.Options.Character then
        chKBMPOATDTAR_Settings = self.Settings
    else
        KBMPOATDTAR_Settings = self.Settings
    end
end

function TAR:Castbar(units)
end

function TAR:RemoveUnits(UnitID)
    if self.TarJulia.UnitID == UnitID then
        self.TarJulia.Available = false
        return true
    end
    return false
end

function TAR:Death(UnitID)
    if self.TarJulia.UnitID == UnitID then
        self.TarJulia.Dead = true
        return true
    end
    if self.Soul.UnitList[UnitID] then
        if self.Soul.UnitList[UnitID].Dead == false then
            self.Soul.UnitList[UnitID].Dead = true
        end
    end
    return false
end


function TAR:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.TarJulia.UTID then
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.TarJulia.Dead = false
                self.TarJulia.Casting = false
                self.TarJulia.CastBar:Create(unitID)
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
                self.PhaseObj.Objectives:AddPercent(self.TarJulia, 0, 100)
                self.PhaseObj.Objectives:AddDeath(TAR.Lang.Unit.Soul[KBM.Lang], 9)
                self.Phase = 1
                KBM.MechTimer:AddStart(self.TarJulia.TimersRef.FirstMoltenBlast)
                KBM.MechTimer:AddStart(self.TarJulia.TimersRef.FirstFury)
                KBM.MechTimer:AddStart(self.TarJulia.TimersRef.FirstSpiderWeave)
                KBM.MechTimer:AddStart(self.TarJulia.TimersRef.FirstCallForHelp)
            end
            self.TarJulia.UnitID = unitID
            self.TarJulia.Available = true
            return self.TarJulia
        end
        if uDetails.type == self.Soul.UTID then
           if not self.Bosses[uDetails.name].UnitList[unitID] then
                local SubBossObj = {
                    Mod = TAR,
                    Level = 72,
                    Name = uDetails.name,
                    Dead = false,
                    Casting = false,
                    UnitID = unitID,
                    Available = true,
                }
                self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
            else
                self.Bosses[uDetails.name].UnitList[unitID].Available = true
                self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
            end
            return self.Bosses[uDetails.name].UnitList[unitID]
        end
    end
end

function TAR:Reset()
    self.EncounterRunning = false
    self.TarJulia.Available = false
    self.TarJulia.UnitID = nil
    self.TarJulia.CastBar:Remove()
    self.Soul.UnitList = {}
    self.PhaseObj:End(Inspect.Time.Real())
end

function TAR:Timer()
end


function TAR:Start()
    -- Create Timers
    self.TarJulia.TimersRef.FirstMoltenBlast = KBM.MechTimer:Add(self.Lang.Ability.MoltenBlast[KBM.Lang], 20)
    self.TarJulia.TimersRef.FirstMoltenBlast.MenuName = self.Lang.Menu.FirstMoltenBlast[KBM.Lang]
    self.TarJulia.TimersRef.MoltenBlast = KBM.MechTimer:Add(self.Lang.Ability.MoltenBlast[KBM.Lang], 40)

    self.TarJulia.TimersRef.FirstCallForHelp = KBM.MechTimer:Add(self.Lang.Ability.CallForHelp[KBM.Lang], 35)
    self.TarJulia.TimersRef.FirstCallForHelp.MenuName = self.Lang.Menu.FirstCallForHelp[KBM.Lang]
    self.TarJulia.TimersRef.CallForHelp = KBM.MechTimer:Add(self.Lang.Ability.CallForHelp[KBM.Lang], 40)

    self.TarJulia.TimersRef.FirstSpiderWeave = KBM.MechTimer:Add(self.Lang.Debuff.SpiderWeave[KBM.Lang], 15)
    self.TarJulia.TimersRef.FirstSpiderWeave.MenuName = self.Lang.Menu.FirstSpiderWeave[KBM.Lang]
    self.TarJulia.TimersRef.SpiderWeave = KBM.MechTimer:Add(self.Lang.Debuff.SpiderWeave[KBM.Lang], 30)

    self.TarJulia.TimersRef.FirstFury = KBM.MechTimer:Add(self.Lang.Buff.Fury[KBM.Lang], 20)
    self.TarJulia.TimersRef.FirstFury.MenuName = self.Lang.Menu.FirstFury[KBM.Lang]
    self.TarJulia.TimersRef.Fury = KBM.MechTimer:Add(self.Lang.Buff.Fury[KBM.Lang], 25)

    KBM.Defaults.TimerObj.Assign(self.TarJulia)

    self.TarJulia.MechRef.SpiderWeave = KBM.MechSpy:Add(self.Lang.Debuff.SpiderWeave[KBM.Lang], 5, "playerDebuff", self.TarJulia)
    KBM.Defaults.MechObj.Assign(self.TarJulia)

    -- Create Alerts
    self.TarJulia.AlertsRef.MoltenBlast = KBM.Alert:Create(self.Lang.Verbose.MoltenBlast[KBM.Lang], 10, true, true, "red")
    self.TarJulia.AlertsRef.CallForHelp = KBM.Alert:Create(self.Lang.Ability.CallForHelp[KBM.Lang], 1, true, true, "blue")
    self.TarJulia.AlertsRef.Fury = KBM.Alert:Create(self.Lang.Buff.Fury[KBM.Lang], 1, true, true, "orange")
    self.TarJulia.AlertsRef.SpiderWeave = KBM.Alert:Create(self.Lang.Debuff.SpiderWeave[KBM.Lang], 1, true, true, "purple")
    KBM.Defaults.AlertObj.Assign(self.TarJulia)

    -- Assign Alerts and Timers to Triggers
    self.TarJulia.Triggers.MoltenBlast = KBM.Trigger:Create(self.Lang.Ability.MoltenBlast[KBM.Lang], "cast", self.TarJulia)
    self.TarJulia.Triggers.MoltenBlast:AddAlert(self.TarJulia.AlertsRef.MoltenBlast, true)
    self.TarJulia.Triggers.MoltenBlast:AddTimer(self.TarJulia.TimersRef.MoltenBlast)

    self.TarJulia.Triggers.CallForHelp = KBM.Trigger:Create(self.Lang.Ability.CallForHelp[KBM.Lang], "cast", self.TarJulia)
    self.TarJulia.Triggers.CallForHelp:AddAlert(self.TarJulia.AlertsRef.CallForHelp)
    self.TarJulia.Triggers.CallForHelp:AddTimer(self.TarJulia.TimersRef.CallForHelp)

    self.TarJulia.Triggers.SpiderWeave = KBM.Trigger:Create(self.Lang.Debuff.SpiderWeave[KBM.Lang], "playerDebuff", self.TarJulia)
    self.TarJulia.Triggers.SpiderWeave:AddAlert(self.TarJulia.AlertsRef.SpiderWeave)
    self.TarJulia.Triggers.SpiderWeave:AddTimer(self.TarJulia.TimersRef.SpiderWeave)
    self.TarJulia.Triggers.SpiderWeave:AddSpy(self.TarJulia.MechRef.SpiderWeave)

    self.TarJulia.Triggers.Fury = KBM.Trigger:Create(self.Lang.Buff.Fury[KBM.Lang], "buff", self.TarJulia)
    self.TarJulia.Triggers.Fury:AddAlert(self.TarJulia.AlertsRef.Fury)
    self.TarJulia.Triggers.Fury:AddTimer(self.TarJulia.TimersRef.Fury)

    self.TarJulia.CastBar = KBM.Castbar:Add(self, self.TarJulia)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)

end
