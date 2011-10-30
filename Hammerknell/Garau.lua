﻿-- Murdantix Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGU_Settings = nil

local GU = {
	ModEnabled = true,
	MenuName = "",
	Garau = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Garau",
	},
	Instance = "Hammerknell",
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {}
}

GU.Garau = {
	Mod = GU,
	Level = "??",
	Active = false,
	Name = "Inquisitor Garau",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Descript = GU.Garau.Name,
}

local KBM = KBM_RegisterMod(GU.Garau.ID, GU)

if KBM.Lang == "German" then
elseif KBM.Lang == "French" then
	GU.Garau.Name = "Inquisiteur Garau"
end

function GU:AddBosses(KBM_Boss)
	KBM_Boss[self.Garau.Name] = self.Garau
	self.Garau.MenuName = self.Garau.Name
	self.Garau.Bosses = {
		[self.Garau.Name] = true,
	}
end

function GU:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			BloodEnabled = true,
			PorterEnabled = true,
			EssenceEnabled = true,
			CrawlerEnabled = true,
		},
	}
	KBMGU_Settings = self.Settings
end

function GU:LoadVars()
	if type(KBMGU_Settings) == "table" then
		for Setting, Value in pairs(KBMGU_Settings) do
			if type(KBMGU_Settings[Setting]) == "table" then
				for tSetting, tValue in pairs(KBMGU_Settings[Setting]) do
					self.Settings[Setting][tSetting] = tValue
				end
			else
				self.Settings[Setting] = Value
			end
		end
	end
end

function GU:SaveVars()
	KBMGU_Settings = self.Settings
end

function GU:Castbar(units)
end

function GU:RemoveUnits(UnitID)
	if self.Garau.UnitID == UnitID then
		self.Garau.Available = false
		return true
	end
	return false
end

function GU:Death(UnitID)
	if self.Garau.UnitID == UnitID then
		self.Garau.Dead = true
		return true
	end
	return false
end

function GU:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Garau.Name then
				if not self.Garau.UnitID then
					self.Garau.UnitID = unitID
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Garau.Dead = false
					self.Garau.Available = true
					self.Garau.Casting = false
					return self.Garau
				end
			end
		end
	end
end

function GU:Reset()
	self.EncounterRunning = false
	self.Garau.UnitID = nil
end

function GU:Timer()
	
end

function GU.Garau:Options()
	function self:TimersEnabled(bool)
		GU.Settings.Timers.Enabled = bool
	end
	function self:BloodEnabled(bool)
		GU.Settings.Timers.BloodEnabled = bool
		GU.Garau.TimersRef.Blood.Enabled = bool
	end
	function self:CrawlerEnabled(bool)
		GU.Settings.Timers.CrawlerEnabled = bool
		GU.Garau.TimersRef.Crawler.Enabled = bool
	end
	function self:PorterEnabled(bool)
		GU.Settings.Timers.PorterEnabled = bool
		GU.Garau.TimersRef.Porter.Enabled = bool
	end
	function self:EssenceEnabled(bool)
		GU.Settings.Timers.EssenceEnabled = bool
		GU.Garau.TimersRef.Essence.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, GU.Settings.Timers.Enabled)
	Timers:AddCheck("Blood Tide", self.BloodEnabled, GU.Settings.Timers.BloodEnabled)
	Timers:AddCheck("Infused Crawlers", self.CrawlerEnabled, GU.Settings.Timers.CrawlerEnabled)
	Timers:AddCheck("Arcane Porter", self.PorterEnabled, GU.Settings.Timers.PorterEnabled)
	Timers:AddCheck("Arcane Essence", self.EssenceEnabled, GU.Settings.Timers.EssenceEnabled)
	
end

function GU:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Garau.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.Garau.Name, self.Garau, true, self.Header)
	self.Garau.MenuItem.Check:SetEnabled(false)
	self.Garau.TimersRef.Blood = KBM.MechTimer:Add("Blood Tide", "damage", 18.5, self.Garau, false)
	self.Garau.TimersRef.Blood.Enabled = self.Settings.Timers.BloodEnabled
	self.Garau.TimersRef.Crawler = KBM.MechTimer:Add({["Bask in the power of Akylios!"] = true,
					["Sacrifice your lives for Akylios!"] = true,}, "say", 30, self.Garau, false, "Infused Crawler")
	self.Garau.TimersRef.Crawler.Enabled = self.Settings.Timers.CrawlerEnabled
	self.Garau.TimersRef.Porter = KBM.MechTimer:Add("Power my creation!", "say", 45, self.Garau, false, "Arcane Porter")
	self.Garau.TimersRef.Porter.Enabled = self.Settings.Timers.PorterEnabled
	self.Garau.TimersRef.Essence = KBM.MechTimer:Add("Inquisitor Garau siphons arcane essence from nearby enemies!", "notify", 18, self.Garau, false, "Arcane Essence")
	self.Garau.TimersRef.Essence.Enabled = self.Settings.Timers.EssenceEnabled
end