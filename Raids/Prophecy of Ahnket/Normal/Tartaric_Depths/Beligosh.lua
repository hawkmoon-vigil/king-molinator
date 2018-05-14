-- Beligosh Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOANMTDBEL_Settings = nil
chKBMPOANMTDBEL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["NMTD"]

local BEL = {
    Directory = Instance.Directory,
    File = "Beligosh.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "NMbeligosh",
    Object = "BEL",
    Enrage = 565,
}

-- Main Unit Dictionary
BEL.Lang.Unit = {}
BEL.Lang.Unit.Beligosh = KBM.Language:Add("Beligosh")
BEL.Lang.Unit.Beligosh:SetFrench("Beligosh")
BEL.Lang.Unit.Beligosh:SetGerman("Beligosh")

BEL.Lang.Unit.Golem = KBM.Language:Add("Alavaxian Golem")
BEL.Lang.Unit.Golem:SetFrench("Golem alaviax")
BEL.Lang.Unit.Golem:SetGerman("Alavaxianischer Golem")

BEL.Beligosh = {
    Mod = BEL,
    Level = "72",
    Active = false,
    Name = BEL.Lang.Unit.Beligosh[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U34892E205315F334",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
          Enabled = true,
          Wrath = KBM.Defaults.AlertObj.Create("red"),
          BurningGround = KBM.Defaults.AlertObj.Create("blue"),
        },
        TimersRef = {
            Enabled = true,
            SeedOfImmolation = KBM.Defaults.TimerObj.Create("purple"),
            VengeanceOfBeligosh = KBM.Defaults.TimerObj.Create("blue"),
            MagmaBreath = KBM.Defaults.TimerObj.Create("red"),
            BurningGround = KBM.Defaults.TimerObj.Create("blue"),
            Landing = KBM.Defaults.TimerObj.Create("red"),
            SoftEnrageTimer = KBM.Defaults.TimerObj.Create("dark_grey"),
            Enrage = KBM.Defaults.TimerObj.Create("dark_grey"),
        },
    },
}

BEL.Golem = {
    Mod = BEL,
    Level = "72",
    Name = BEL.Lang.Unit.Golem[KBM.Lang],
    NameShort = "Alavaxian Golem",
    UnitList = {},
    Menu = {},
    UTID = "U110556F3514C5C3F",
    Ignore = true,
    Type = "multi",
}

KBM.RegisterMod(BEL.ID, BEL)

-- Ability Dictionary
BEL.Lang.Ability = {}
BEL.Lang.Ability.MagmaBreath = KBM.Language:Add("Magma Breath")
BEL.Lang.Ability.MagmaBreath:SetFrench("Souffle de magma")
BEL.Lang.Ability.MagmaBreath:SetGerman("Magmaatem")

-- Verbose Dictionary
BEL.Lang.Verbose = {}
BEL.Lang.Verbose.Wrath = KBM.Language:Add("Wrath of Beligosh")
BEL.Lang.Verbose.Wrath:SetFrench("Courroux de Beligosh")
BEL.Lang.Verbose.Wrath:SetGerman("Zorn von Beligosh")

BEL.Lang.Verbose.BurningGround = KBM.Language:Add("Burning Ground")
BEL.Lang.Verbose.BurningGround:SetGerman("Brennende Erde")
BEL.Lang.Verbose.BurningGround:SetFrench("Terrain enflammé") 

BEL.Lang.Verbose.Landing = KBM.Language:Add("Landing")

BEL.Lang.Verbose.SoftEnrageTimer = KBM.Language:Add("Soft Enrage")
BEL.Lang.Verbose.SoftEnrageTimer:SetGerman("Weich Wütend")
BEL.Lang.Verbose.SoftEnrageTimer:SetFrench("Doux Enragé") 

BEL.Lang.Verbose.Enrage = KBM.Language:Add("Enrage")
BEL.Lang.Verbose.Enrage:SetGerman("Wütend")
BEL.Lang.Verbose.Enrage:SetFrench("Enragé") 

-- Buff Dictionary
BEL.Lang.Buff = {}

-- Debuff Dictionary
BEL.Lang.Debuff = {}
BEL.Lang.Debuff.VengeanceOfBeligosh = KBM.Language:Add("Vengeance of Beligosh")--tank debuff
BEL.Lang.Debuff.VengeanceOfBeligosh:SetGerman("Rache von Beligosh")
BEL.Lang.Debuff.VengeanceOfBeligosh:SetFrench("Vengeance de Beligosh")

BEL.Lang.Debuff.SeedOfImmolation = KBM.Language:Add("Seed of Immolation")--raid debuff
BEL.Lang.Debuff.SeedOfImmolation:SetGerman("Saat der Opferung")
BEL.Lang.Debuff.SeedOfImmolation:SetFrench("Graine d'immolation")

-- Notify Dictionary
BEL.Lang.Notify = {}
BEL.Lang.Notify.Wrath = KBM.Language:Add("Beligosh: Feel the wrath of Beligosh!")
BEL.Lang.Notify.Wrath:SetFrench("Beligosh : Sentez le courroux de Beligosh !")
BEL.Lang.Notify.Wrath:SetGerman("Beligosh: Spürt den Zorn von Beligosh!")

-- Description Dictionary
BEL.Lang.Main = {}
BEL.Descript = BEL.Lang.Unit.Beligosh[KBM.Lang]

function BEL:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.Beligosh.Name] = self.Beligosh,
        [self.Golem.Name] = self.Golem,
    }
end

function BEL:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.Beligosh.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        -- TimersRef = self.Baird.Settings.TimersRef,
        AlertsRef = self.Beligosh.Settings.AlertsRef,
    }
    KBMPOANMTDBEL_Settings = self.Settings
    chKBMPOANMTDBEL_Settings = self.Settings

end

function BEL:SwapSettings(bool)

    if bool then
        KBMPOANMTDBEL_Settings = self.Settings
        self.Settings = chKBMPOANMTDBEL_Settings
    else
        chKBMPOANMTDBEL_Settings = self.Settings
        self.Settings = KBMPOANMTDBEL_Settings
    end

end

function BEL:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOANMTDBEL_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOANMTDBEL_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOANMTDBEL_Settings = self.Settings
    else
        KBMPOANMTDBEL_Settings = self.Settings
    end 
end

function BEL:SaveVars()
    if KBM.Options.Character then
        chKBMPOANMTDBEL_Settings = self.Settings
    else
        KBMPOANMTDBEL_Settings = self.Settings
    end
end

function BEL:Castbar(units)
end

function BEL:RemoveUnits(UnitID)
    if self.Beligosh.UnitID == UnitID then
        self.Beligosh.Available = false
        return true
    end
    return false
end

function BEL:Death(UnitID)
    if self.Beligosh.UnitID == UnitID then
        self.Beligosh.Dead = true
        return true
    end
    return false
end

function BEL:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.Beligosh.UTID then
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.Beligosh.Dead = false
                self.Beligosh.Casting = false
                self.Beligosh.CastBar:Create(unitID)
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase(self.Beligosh.Name)
                self.PhaseObj.Objectives:AddPercent(self.Beligosh, 75, 100)
                self.Phase = 1
                KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.SeedOfImmolation)
                KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.VengeanceOfBeligosh)
                KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.MagmaBreath)
                KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.BurningGround)
            end
            self.Beligosh.UnitID = unitID
            self.Beligosh.Available = true
            return self.Beligosh
        end
        if uDetails.type == self.Golem.UTID then
           if not self.Bosses[uDetails.name].UnitList[unitID] then
                local SubBossObj = {
                    Mod = BEL,
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

function BEL:Reset()
    self.EncounterRunning = false
    self.Beligosh.Available = false
    self.Beligosh.UnitID = nil
    self.Beligosh.CastBar:Remove()
    self.Golem.UnitList = {}

    self.PhaseObj:End(Inspect.Time.Real())
end

function BEL:Timer()
end

function BEL.PhaseTwo()
    BEL.PhaseObj.Objectives:Remove()
    if BEL.Phase == 2 then
        BEL.Phase = 3
        BEL.PhaseObj:SetPhase(3)
        BEL.PhaseObj.Objectives:AddPercent(BEL.Beligosh, 40, 75)
    else
        BEL.Phase = 5
        BEL.PhaseObj:SetPhase(5)
        BEL.PhaseObj.Objectives:AddPercent(BEL.Beligosh, 12, 40)
    end
    KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.Landing)
end

function BEL.AddPhase()
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.SeedOfImmolation)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.VengeanceOfBeligosh)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.MagmaBreath)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.BurningGround)
    BEL.PhaseObj.Objectives:Remove()
    if BEL.Phase == 1 then
        BEL.Phase = 2
        BEL.PhaseObj:SetPhase(2)
    else
        BEL.Phase = 4
        BEL.PhaseObj:SetPhase(4)
    end
    BEL.PhaseObj.Objectives:AddDeath(BEL.Lang.Unit.Golem[KBM.Lang], 6)
end

function BEL.FinalPhase()
    BEL.PhaseObj.Objectives:Remove()
    
    BEL.Phase = 6
    BEL.PhaseObj:SetPhase(6)
    BEL.PhaseObj.Objectives:AddPercent(BEL.Beligosh, 0, 12)
    
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.SeedOfImmolation)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.VengeanceOfBeligosh)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.MagmaBreath)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.SoftEnrageTimer)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.BurningGround)
    
    KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.VengeanceOfBeligosh)
    KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.Enrage)
end

function BEL.FinalPhaseTimer()
    if(BEL.Phase ~= 6) then
        BEL.PhaseObj.Objectives:Remove()
        
        BEL.Phase = 6
        BEL.PhaseObj:SetPhase(6)
        BEL.PhaseObj.Objectives:AddPercent(BEL.Beligosh, 0, 100)
        
        KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.SeedOfImmolation)
        KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.VengeanceOfBeligosh)
        KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.MagmaBreath)
        KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.BurningGround)
        KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.SoftEnrageTimer)
        
        KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.VengeanceOfBeligosh)
        KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.Enrage)
    end
end

function BEL:Start()
    -- Create Timers
    self.Beligosh.TimersRef.SoftEnrageTimer = KBM.MechTimer:Add(self.Lang.Verbose.SoftEnrageTimer[KBM.Lang], 540)
    self.Beligosh.TimersRef.Enrage = KBM.MechTimer:Add(self.Lang.Verbose.Enrage[KBM.Lang], 25)
    self.Beligosh.TimersRef.SeedOfImmolation = KBM.MechTimer:Add(self.Lang.Debuff.SeedOfImmolation[KBM.Lang], 24)
    self.Beligosh.TimersRef.VengeanceOfBeligosh = KBM.MechTimer:Add(self.Lang.Debuff.VengeanceOfBeligosh[KBM.Lang], 15)
    self.Beligosh.TimersRef.MagmaBreath = KBM.MechTimer:Add(self.Lang.Ability.MagmaBreath[KBM.Lang], 31)
    self.Beligosh.TimersRef.BurningGround = KBM.MechTimer:Add(self.Lang.Verbose.BurningGround[KBM.Lang], 17)
    self.Beligosh.TimersRef.Landing = KBM.MechTimer:Add(self.Lang.Verbose.Landing[KBM.Lang], 10)
    KBM.Defaults.TimerObj.Assign(self.Beligosh)

    -- Create Alerts
    self.Beligosh.AlertsRef.Wrath = KBM.Alert:Create(self.Lang.Verbose.Wrath[KBM.Lang], 10, true, true, "red")
    self.Beligosh.AlertsRef.BurningGround = KBM.Alert:Create(self.Lang.Verbose.BurningGround[KBM.Lang], 2, true, true, "blue")
    KBM.Defaults.AlertObj.Assign(self.Beligosh)

    -- Assign Alerts and Timers to Triggers
    self.Beligosh.CastBar = KBM.Castbar:Add(self, self.Beligosh)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)

    self.Beligosh.TimersRef.BurningGround:AddAlert(self.Beligosh.AlertsRef.BurningGround, 2)
    self.Beligosh.TimersRef.Landing:AddTimer(self.Beligosh.TimersRef.SeedOfImmolation, 0)
    self.Beligosh.TimersRef.Landing:AddTimer(self.Beligosh.TimersRef.VengeanceOfBeligosh, 0)
    self.Beligosh.TimersRef.Landing:AddTimer(self.Beligosh.TimersRef.MagmaBreath, 0)
    self.Beligosh.TimersRef.Landing:AddTimer(self.Beligosh.TimersRef.BurningGround, 0)

    self.Beligosh.Triggers.AddPhase = KBM.Trigger:Create(75, "percent", self.Beligosh)
    self.Beligosh.Triggers.AddPhase:AddPhase(self.AddPhase)

    self.Beligosh.Triggers.PhaseTwo = KBM.Trigger:Create(self.Lang.Notify.Wrath[KBM.Lang], "notify", self.Beligosh)
    self.Beligosh.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
    self.Beligosh.Triggers.PhaseTwo:AddAlert(self.Beligosh.AlertsRef.Wrath)

    self.Beligosh.Triggers.AddPhase2 = KBM.Trigger:Create(40, "percent", self.Beligosh)
    self.Beligosh.Triggers.AddPhase2:AddPhase(self.AddPhase)

    self.Beligosh.Triggers.SeedOfImmolation = KBM.Trigger:Create(self.Lang.Debuff.SeedOfImmolation[KBM.Lang], "playerDebuff", self.Beligosh)
    self.Beligosh.Triggers.SeedOfImmolation:AddTimer(self.Beligosh.TimersRef.SeedOfImmolation)

    self.Beligosh.Triggers.VengeanceOfBeligosh = KBM.Trigger:Create(self.Lang.Debuff.VengeanceOfBeligosh[KBM.Lang], "playerDebuff", self.Beligosh)
    self.Beligosh.Triggers.VengeanceOfBeligosh:AddTimer(self.Beligosh.TimersRef.VengeanceOfBeligosh)

    self.Beligosh.Triggers.MagmaBreath = KBM.Trigger:Create(self.Lang.Ability.MagmaBreath[KBM.Lang], "channel", self.Beligosh)
    self.Beligosh.Triggers.MagmaBreath:AddTimer(self.Beligosh.TimersRef.MagmaBreath)
    self.Beligosh.Triggers.MagmaBreath:AddTimer(self.Beligosh.TimersRef.BurningGround)

    self.Beligosh.Triggers.FinalPhase = KBM.Trigger:Create(12, "percent", self.Beligosh)
    self.Beligosh.Triggers.FinalPhase:AddPhase(self.FinalPhase)

    self.Beligosh.Triggers.FinalPhaseTimer = KBM.Trigger:Create(540, "time", self.Beligosh)
    self.Beligosh.Triggers.FinalPhaseTimer:AddPhase(self.FinalPhaseTimer)
end
