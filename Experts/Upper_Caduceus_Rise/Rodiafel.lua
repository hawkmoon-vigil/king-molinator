﻿-- Rodiafel Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXUCRRL_Settings = nil
chKBMEXUCRRL_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Upper Caduceus Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Rodiafel.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Rodiafel",
}

MOD.Rodiafel = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Rodiafel",
	--NameShort = "Rodiafel",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U2DA3DE5504E72291",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

KBM.RegisterMod(MOD.ID, MOD)

MOD.Lang.Rodiafel = KBM.Language:Add(MOD.Rodiafel.Name)
MOD.Lang.Rodiafel:SetGerman("Rodiafel")
-- MOD.Lang.Rodiafel:SetFrench("")
-- MOD.Lang.Rodiafel:SetRussian("")
MOD.Rodiafel.Name = MOD.Lang.Rodiafel[KBM.Lang]
MOD.Descript = MOD.Rodiafel.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Rodiafel.Name] = self.Rodiafel,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Rodiafel.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Rodiafel.Settings.TimersRef,
		-- AlertsRef = self.Rodiafel.Settings.AlertsRef,
	}
	KBMEXUCRRL_Settings = self.Settings
	chKBMEXUCRRL_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXUCRRL_Settings = self.Settings
		self.Settings = chKBMEXUCRRL_Settings
	else
		chKBMEXUCRRL_Settings = self.Settings
		self.Settings = KBMEXUCRRL_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXUCRRL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXUCRRL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXUCRRL_Settings = self.Settings
	else
		KBMEXUCRRL_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXUCRRL_Settings = self.Settings
	else
		KBMEXUCRRL_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Rodiafel.UnitID == UnitID then
		self.Rodiafel.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Rodiafel.UnitID == UnitID then
		self.Rodiafel.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Rodiafel.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Rodiafel.Dead = false
					self.Rodiafel.Casting = false
					self.Rodiafel.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Rodiafel.Name, 0, 100)
					self.Phase = 1
				end
				self.Rodiafel.UnitID = unitID
				self.Rodiafel.Available = true
				return self.Rodiafel
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Rodiafel.Available = false
	self.Rodiafel.UnitID = nil
	self.Rodiafel.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Rodiafel:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function MOD.Rodiafel:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Rodiafel, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Rodiafel)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Rodiafel)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Rodiafel.CastBar = KBM.CastBar:Add(self, self.Rodiafel)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end