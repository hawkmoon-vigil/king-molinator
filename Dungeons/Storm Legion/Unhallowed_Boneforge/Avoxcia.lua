﻿-- Avoxcia Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMUBFAVX_Settings = nil
chKBMSLNMUBFAVX_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Unhallowed Boneforge"]

local MOD = {
	Directory = Instance.Directory,
	File = "Avoxcia.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Avoxcia",
	Object = "MOD",
}

MOD.Avoxcia = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Avoxcia",
	NameShort = "Avoxcia",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U4A5B98C5031815B4",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Avoxcia = KBM.Language:Add(MOD.Avoxcia.Name)
MOD.Lang.Unit.Avoxcia:SetGerman()
MOD.Avoxcia.Name = MOD.Lang.Unit.Avoxcia[KBM.Lang]
MOD.Descript = MOD.Avoxcia.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Avoxcia")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Avoxcia.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Avoxcia.Name] = self.Avoxcia,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Avoxcia.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Avoxcia.Settings.TimersRef,
		-- AlertsRef = self.Avoxcia.Settings.AlertsRef,
	}
	KBMSLNMUBFAVX_Settings = self.Settings
	chKBMSLNMUBFAVX_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMUBFAVX_Settings = self.Settings
		self.Settings = chKBMSLNMUBFAVX_Settings
	else
		chKBMSLNMUBFAVX_Settings = self.Settings
		self.Settings = KBMSLNMUBFAVX_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMUBFAVX_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMUBFAVX_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMUBFAVX_Settings = self.Settings
	else
		KBMSLNMUBFAVX_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMUBFAVX_Settings = self.Settings
	else
		KBMSLNMUBFAVX_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Avoxcia.UnitID == UnitID then
		self.Avoxcia.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Avoxcia.UnitID == UnitID then
		self.Avoxcia.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Avoxcia.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Avoxcia.Dead = false
					self.Avoxcia.Casting = false
					self.Avoxcia.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Avoxcia.Name, 0, 100)
					self.Phase = 1
				end
				self.Avoxcia.UnitID = unitID
				self.Avoxcia.Available = true
				return self.Avoxcia
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Avoxcia.Available = false
	self.Avoxcia.UnitID = nil
	self.Avoxcia.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Avoxcia, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Avoxcia)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Avoxcia)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Avoxcia.CastBar = KBM.CastBar:Add(self, self.Avoxcia)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end