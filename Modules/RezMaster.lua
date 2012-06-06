-- King Boss Mods Rez Master
-- Written By Paul Snart
-- Copyright 2012
--

local KBMTable = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMTable.data

local RM = {
	Broadcast = {
		LastSent = Inspect.Time.Real()
	},
	Rezes = {
		ActiveTimers = {},
		Tracked = {},
	},
	GUI = {
		Store = {},
	},
}

KBM.RezMaster = RM

function RM.GUI:ApplySettings()
	self.Settings.Enabled = true
	self.Anchor:ClearAll()
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("BOTTOMRIGHT", UIParent, 0.9, 0.5)
	end
	self.Anchor:SetWidth(math.ceil(KBM.Constant.RezMaster.w * self.Settings.wScale))
	self.Anchor:SetHeight(math.ceil(KBM.Constant.RezMaster.h * self.Settings.hScale))
	self.Anchor.Text:SetFontSize(math.ceil(KBM.Constant.RezMaster.TextSize * self.Settings.tScale))
	if KBM.MainWin:GetVisible() then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end	
end

function RM.GUI:Pull()
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Timer_Frame", KBM.Context)
		GUI.Background:SetPoint("LEFT", RM.GUI.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", RM.GUI.Anchor, "RIGHT")
		GUI.Background:SetHeight(RM.GUI.Anchor:GetHeight())
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.Icon = UI.CreateFrame("Texture", "Timer_Icon", GUI.Background)
		GUI.Icon:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Icon:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.Icon:SetWidth(GUI.Background:GetHeight())
		GUI.TimeBar = UI.CreateFrame("Frame", "Timer_Progress_Frame", GUI.Background)
		--GUI.TimeBar:SetTexture("KingMolinator", "Media/BarTexture2.png")
		GUI.TimeBar:SetWidth(RM.GUI.Anchor:GetWidth() - GUI.Icon:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Icon, "TOPRIGHT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.CastInfo = UI.CreateFrame("Text", "Timer_Text_Frame", GUI.Background)
		GUI.CastInfo:SetFontSize(math.ceil(KBM.Constant.RezMaster.TextSize * RM.GUI.Settings.tScale))
		GUI.CastInfo:SetPoint("CENTERLEFT", GUI.Icon, "CENTERRIGHT")
		GUI.CastInfo:SetLayer(3)
		GUI.CastInfo:SetFontColor(1,1,1)
		GUI.CastInfo:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(math.ceil(KBM.Constant.RezMaster.TextSize * RM.GUI.Settings.tScale))
		GUI.Shadow:SetPoint("CENTER", GUI.CastInfo, "CENTER", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Background)
		GUI.Texture:SetTexture("KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.Constant.RezMaster.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
	end
	return GUI
end

function RM.GUI:Init()
	self.Settings = KBM.Options.RezMaster

	self.Anchor = UI.CreateFrame("Frame", "Rez Timer", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
		
	function self.Anchor:Update(uType)
		if uType == "end" then
			RM.GUI.Settings.x = self:GetLeft()
			RM.GUI.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Text = UI.CreateFrame("Text", "Rez Master Anchor", self.Anchor)
	self.Anchor.Text:SetText(" Ready! "..KBM.Language.RezMaster.AnchorText[KBM.Lang])
	self.Anchor.Text:SetPoint("CENTERLEFT", self.Anchor, "CENTERLEFT")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor_Drag", 5)
	
	function self.Anchor.Drag.Event:WheelForward()
		if RM.GUI.Settings.ScaleWidth then
			if RM.GUI.Settings.wScale < 1.5 then
				RM.GUI.Settings.wScale = RM.GUI.Settings.wScale + 0.025
				if RM.GUI.Settings.wScale > 1.5 then
					RM.GUI.Settings.wScale = 1.5
				end
				RM.GUI.Anchor:SetWidth(math.ceil(RM.GUI.Settings.wScale * KBM.Constant.RezMaster.w))
				if #RM.Rezes.ActiveTimers > 0 then
					for _, Timer in ipairs(RM.Rezes.ActiveTimers) do
						Timer.SetWidth = RM.GUI.Anchor:GetWidth() - RM.GUI.Anchor:GetHeight()
						if Timer.Waiting then
							Timer.GUI.TimeBar:SetWidth(Timer.SetWidth)
						else
							Timer:Update()
						end
					end
				end
			end
		end
		
		if RM.GUI.Settings.ScaleHeight then
			if RM.GUI.Settings.hScale < 1.5 then
				RM.GUI.Settings.hScale = RM.GUI.Settings.hScale + 0.025
				if RM.GUI.Settings.hScale > 1.5 then
					RM.GUI.Settings.hScale = 1.5
				end
				RM.GUI.Anchor:SetHeight(math.ceil(RM.GUI.Settings.hScale * KBM.Constant.RezMaster.h))
				if #RM.Rezes.ActiveTimers > 0 then
					for _, Timer in ipairs(RM.Rezes.ActiveTimers) do
						Timer.GUI.Background:SetHeight(RM.GUI.Anchor:GetHeight())
						Timer.GUI.Icon:SetWidth(RM.GUI.Anchor:GetHeight())
						Timer.SetWidth = RM.GUI.Anchor:GetWidth() - RM.GUI.Anchor:GetHeight()
						if Timer.Waiting then
							Timer.GUI.TimeBar:SetWidth(Timer.SetWidth)
						else
							Timer:Update()
						end
					end
				end
			end
		end
		
		if RM.GUI.Settings.ScaleText then
			if RM.GUI.Settings.tScale < 1.5 then
				RM.GUI.Settings.tScale = RM.GUI.Settings.tScale + 0.025
				if RM.GUI.Settings.tScale > 1.5 then
					RM.GUI.Settings.tScale = 1.5
				end
				RM.GUI.Anchor.Text:SetFontSize(math.ceil(RM.GUI.Settings.tScale * KBM.Constant.RezMaster.TextSize))
				if #RM.Rezes.ActiveTimers > 0 then
					for _, Timer in ipairs(RM.Rezes.ActiveTimers) do
						Timer.GUI.CastInfo:SetFontSize(RM.GUI.Anchor.Text:GetFontSize())
						Timer.GUI.Shadow:SetFontSize(RM.GUI.Anchor.Text:GetFontSize())
					end
				end
			end
		end
	end
	
	function self.Anchor.Drag.Event:WheelBack()		
		if RM.GUI.Settings.ScaleWidth then
			if RM.GUI.Settings.wScale > 0.5 then
				RM.GUI.Settings.wScale = RM.GUI.Settings.wScale - 0.025
				if RM.GUI.Settings.wScale < 0.5 then
					RM.GUI.Settings.wScale = 0.5
				end
				RM.GUI.Anchor:SetWidth(math.ceil(RM.GUI.Settings.wScale * KBM.Constant.RezMaster.w))
				if #RM.Rezes.ActiveTimers > 0 then
					for _, Timer in ipairs(RM.Rezes.ActiveTimers) do
						Timer.SetWidth = RM.GUI.Anchor:GetWidth() - RM.GUI.Anchor:GetHeight()
						if Timer.Waiting then
							Timer.GUI.TimeBar:SetWidth(Timer.SetWidth)
						else
							Timer:Update()
						end
					end
				end
			end
		end
		
		if RM.GUI.Settings.ScaleHeight then
			if RM.GUI.Settings.hScale > 0.5 then
				RM.GUI.Settings.hScale = RM.GUI.Settings.hScale - 0.025
				if RM.GUI.Settings.hScale < 0.5 then
					RM.GUI.Settings.hScale = 0.5
				end
				RM.GUI.Anchor:SetHeight(math.ceil(RM.GUI.Settings.hScale * KBM.Constant.RezMaster.h))
				if #RM.Rezes.ActiveTimers > 0 then
					for _, Timer in ipairs(RM.Rezes.ActiveTimers) do
						Timer.GUI.Background:SetHeight(RM.GUI.Anchor:GetHeight())
						Timer.GUI.Icon:SetWidth(RM.GUI.Anchor:GetHeight())
						Timer.SetWidth = RM.GUI.Anchor:GetWidth() - RM.GUI.Anchor:GetHeight()
						if Timer.Waiting then
							Timer.GUI.TimeBar:SetWidth(Timer.SetWidth)
						else
							Timer:Update()
						end
					end
				end
			end
		end
		
		if RM.GUI.Settings.ScaleText then
			if RM.GUI.Settings.tScale > 0.5 then
				RM.GUI.Settings.tScale = RM.GUI.Settings.tScale - 0.025
				if RM.GUI.Settings.tScale < 0.5 then
					RM.GUI.Settings.tScale = 0.5
				end
				RM.GUI.Anchor.Text:SetFontSize(math.ceil(RM.GUI.Settings.tScale * KBM.Constant.RezMaster.TextSize))
				if #RM.Rezes.ActiveTimers > 0 then
					for _, Timer in ipairs(RM.Rezes.ActiveTimers) do
						Timer.GUI.CastInfo:SetFontSize(RM.GUI.Anchor.Text:GetFontSize())
						Timer.GUI.Shadow:SetFontSize(RM.GUI.Anchor.Text:GetFontSize())
					end
				end				
			end
		end
	end
	self:ApplySettings()

end

function RM.Rezes:Init()
	function self:Add(Name, aID, aCD, aFull)
		if KBM.Player.Grouped then
			if RM.GUI.Settings.Enabled then
				local aDetails = Inspect.Ability.Detail(aID)
				if aDetails then
					local Anchor = RM.GUI.Anchor
					local Timer = {}
					if self.Tracked[Name] then
						if self.Tracked[Name][aID] then
							self.Tracked[Name][aID]:Remove()
						end
					else
						self.Tracked[Name] = {}
					end
					self.Tracked[Name][aID] = Timer
					Timer.GUI = RM.GUI:Pull()
					Timer.GUI.Background:SetHeight(Anchor:GetHeight())
					Timer.GUI.CastInfo:SetFontSize(KBM.Constant.RezMaster.TextSize * RM.GUI.Settings.tScale)
					Timer.GUI.Shadow:SetFontSize(Timer.GUI.CastInfo:GetFontSize())
					Timer.GUI.Icon:SetTexture("Rift", aDetails.icon)
					Timer.SetWidth = Timer.GUI.Background:GetWidth() - Timer.GUI.Background:GetHeight()
					local Spec, UID = LibSRM.Group.NameSearch(Name)
					Timer.Class = ""
					if UID then
						Timer.Class = KBM.Unit.List.UID[UID].Details.calling or ""
					else
						if KBM.Unit.List.Name[Name] then
							for UID, Object in pairs(KBM.Unit.List.Name[Name]) do
								Timer.Class = Object.Details.calling or ""
								break
							end
						end
					end

					if Timer.Class == "" then
						for Calling, AbilityList in pairs(KBM.PlayerControl.RezBank) do
							if AbilityList[aID] then
								Timer.Class = Calling
								KBM.Unit.List.UID[UID].Details.calling = Calling
								break
							end
						end
					end
							
					if Timer.Class == "mage" then
						Timer.GUI.TimeBar:SetBackgroundColor(0.8, 0.55, 1, 0.33)
					elseif Timer.Class == "cleric" then
						Timer.GUI.TimeBar:SetBackgroundColor(0.55, 1, 0.55, 0.33)
					end
					Timer.Duration = math.floor(tonumber(aFull))
					Timer.Remaining = (aCD or 0)
					Timer.TimeStart = Inspect.Time.Real() - (Timer.Duration - Timer.Remaining)
					Timer.Player = Name
					Timer.Name = aDetails.name
					
					--if KBM.MechTimer.Settings.Shadow then
						Timer.GUI.Shadow:SetText(Timer.GUI.CastInfo:GetText())
						Timer.GUI.Shadow:SetVisible(true)
					--else
						--self.GUI.Shadow:SetVisible(false)
					--end
					
					--if KBM.MechTimer.Settings.Texture then
						--Timer.GUI.Texture:SetVisible(true)
					--else
						--self.GUI.Texture:SetVisible(false)
					--end
					
					
					-- if self.Settings then
						-- if self.Settings.Custom then
							-- self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
						-- else
							-- self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
						-- end
					-- else
						--self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[KBM.MechTimer.Settings.Color].Red, KBM.Colors.List[KBM.MechTimer.Settings.Color].Green, KBM.Colors.List[KBM.MechTimer.Settings.Color].Blue, 0.33)
					--end
					
					if #self.ActiveTimers > 0 then
						for i, cTimer in ipairs(self.ActiveTimers) do
							if (Timer.Remaining < cTimer.Remaining) or (Timer.Duration <= cTimer.Duration and Timer.Remaining == cTimer.Remaining) then
								Timer.Active = true
								if i == 1 then
									Timer.GUI.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
									cTimer.GUI.Background:SetPoint("TOPLEFT", Timer.GUI.Background, "BOTTOMLEFT", 0, 1)
								else
									Timer.GUI.Background:SetPoint("TOPLEFT", self.ActiveTimers[i-1].GUI.Background, "BOTTOMLEFT", 0, 1)
									cTimer.GUI.Background:SetPoint("TOPLEFT", Timer.GUI.Background, "BOTTOMLEFT", 0, 1)
								end
								table.insert(self.ActiveTimers, i, Timer)
								break
							end
						end
						if not Timer.Active then
							Timer.GUI.Background:SetPoint("TOPLEFT", self.LastTimer.GUI.Background, "BOTTOMLEFT", 0, 1)
							table.insert(self.ActiveTimers, Timer)
							self.LastTimer = Timer
							Timer.Active = true
						end
					else
						Timer.GUI.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
						table.insert(self.ActiveTimers, Timer)
						Timer.Active = true
						self.LastTimer = Timer
						if RM.GUI.Settings.Visible then
							Anchor.Text:SetVisible(false)
						end
					end
					Timer.GUI.Background:SetVisible(true)
					Timer.Starting = false
					
					function Timer:Update(CurrentTime, Force)
						local text = ""
						if self.Active then
							if self.Waiting then
							else
								self.Remaining = self.Duration - (CurrentTime - self.TimeStart)
								--if self.Remaining < 10 then
									--text = string.format(" %0.01f : ", self.Remaining)..self.Player
								if self.Remaining >= 60 then
									text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Player
								else
									text = " "..math.floor(self.Remaining).." : "..self.Player
								end
								self.GUI.CastInfo:SetText(text)
								self.GUI.Shadow:SetText(text)
								self.GUI.TimeBar:SetWidth(self.SetWidth - (self.SetWidth * (self.Remaining/self.Duration)))
								if self.Remaining <= 0 then
									self.Remaining = 0
									self.GUI.CastInfo:SetText(" "..self.Player.." "..KBM.Language.RezMaster.Ready[KBM.Lang])
									self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
									self.GUI.TimeBar:SetWidth(self.SetWidth)
									self.Waiting = true
								end
							end
						end
					end
					
					function Timer:Remove()
						for i, iTimer in ipairs(RM.Rezes.ActiveTimers) do
							if iTimer == self then
								if #RM.Rezes.ActiveTimers == 1 then
									RM.RezesLastTimer = nil
									if RM.GUI.Settings.Visible then
										RM.GUI.Anchor.Text:SetVisible(true)
									end
								elseif i == 1 then
									RM.Rezes.ActiveTimers[i+1].GUI.Background:SetPoint("TOPLEFT", RM.GUI.Anchor, "TOPLEFT")
								elseif i == #RM.Rezes.ActiveTimers then
									RM.Rezes.LastTimer = RM.Rezes.ActiveTimers[i-1]
								else
									RM.Rezes.ActiveTimers[i+1].GUI.Background:SetPoint("TOPLEFT", RM.Rezes.ActiveTimers[i-1].GUI.Background, "BOTTOMLEFT", 0, 1)
								end
								table.remove(RM.Rezes.ActiveTimers, i)
								self.GUI.Background:SetVisible(false)
								self.GUI.Shadow:SetText("")
								table.insert(RM.GUI.Store, self.GUI)
								break
							end
						end
					end
					Timer:Update(Inspect.Time.Real())
				end	
			end
		end
	end

	function self:Clear(sPlayer)
		if not sPlayer then
			for Player, TimerList in pairs(self.Tracked) do
				for aID, Timer in pairs(TimerList) do
					Timer:Remove()
				end
			end
		elseif self.Tracked[sPlayer] then
			for aID, Timer in pairs(self.Tracked[sPlayer]) do
				Timer:Remove()
			end
		end
	end
	
	function self:Remove(Name, aID)
		if not self.Tracked[Name] then
			return
		end
		local Timer = self.Tracked[Name][aID]
		if Timer then
			Timer:Remove()
		end
	end
end

function RM.MessageSent(Failed, Message)
end

function RM.Broadcast.RezSet(toName, crID)
	if KBM.Player.Grouped then
		if toName then
			for crID, Details in pairs(KBM.Player.Rezes.List) do
				KBM.Player.Rezes.List[crID] = Inspect.Ability.Detail(crID)
				Details = KBM.Player.Rezes.List[crID]
				Command.Message.Send(toName, "KBMRezSet", crID..","..tostring(Details.currentCooldownRemaining)..","..tostring(Details.cooldown), RM.MessageSent)
			end
		elseif not crID then
			for crID, Details in pairs(KBM.Player.Rezes.List) do
				-- print("Sending: "..Details.name.." to raid")
				KBM.Player.Rezes.List[crID] = Inspect.Ability.Detail(crID)
				Details = KBM.Player.Rezes.List[crID]
				Command.Message.Broadcast(KBM.Player.Mode, nil, "KBMRezSet", crID..","..tostring(Details.currentCooldownRemaining)..","..tostring(Details.cooldown))
			end
		else
			KBM.Player.Rezes.List[crID] = Inspect.Ability.Detail(crID)
			local Details = KBM.Player.Rezes.List[crID]
			Command.Message.Broadcast(KBM.Player.Mode, nil, "KBMRezSet", crID..","..tostring(Details.currentCooldownRemaining)..","..tostring(Details.cooldown))
		end
	end
end

function RM.Broadcast.RezRem(crID)
	if KBM.Player.Grouped then
		-- print("Sending: "..crID.." remove message")
		Command.Message.Broadcast("raid", nil, "KBMRezRem", crID)
		if RM.Rezes.Tracked[KBM.Player.Name] then
			if RM.Rezes.Tracked[KBM.Player.Name][crID] then
				RM.Rezes.Tracked[KBM.Player.Name][crID]:Remove()
				RM.Rezes.Tracked[KBM.Player.Name][crID] = nil
			end
		end
	end
end

function RM.Broadcast.RezClear()
	if KBM.Player.Grouped then
		-- print("Sending: Can no longer BR/CR message")
		Command.Message.Broadcast(KBM.Player.Mode, nil, "KBMRezClear", KBM.Player.UnitID)
		RM.Rezes:Clear(KBM.Player.Name)
	end
end

function RM.MessageHandler(From, Type, Channel, Identifier, Data)
	if From ~= KBM.Player.Name and Data ~= nil then
		if Type then
			if Type == "raid" or Type == "party" then
				if Identifier == "KBMRezSet" then
					local aID = string.sub(Data, 1, 17)
					local st = string.find(Data, ",", 19)
					local aCD = math.ceil(tonumber(string.sub(Data, 19, st - 1)) or 0)
					local aDR = math.floor(tonumber(string.sub(Data, st + 1)))
					local aDets = Inspect.Ability.Detail(aID)
					RM.Rezes:Add(From, aID, aCD, aDR)
					-- print("Initiate "..From.."'s CR/BR state for "..aDets.name)
					-- print("Data retrieved: "..aID)
					if aCD > 0 then
						-- print("On cooldown: remaining "..tostring(aCD))
					else
						-- print("Is available for use")
					end
				elseif Identifier == "KBMRezRem" then
					if RM.Rezes.Tracked[From] then
						if RM.Rezes.Tracked[From][Data] then
							RM.Rezes.Tracked[From][Data]:Remove()
						end
					end
					-- print("Remove "..From.."'s CR/BR states")
					-- print("Data retrieved: "..Data)
				elseif Identifier == "KBMRezClear" then
					RM.Rezes:Clear(From)
					--print("Remove all Rez Timers for "..From)
				end
			elseif Type == "send" then
				if Identifier == "KBMRezSet" then
					--print("Private Rez details sent by: "..From)
					RM.MessageHandler(From, "raid", nil, Identifier, Data)
				elseif Identifier == "KBMRezReq" then
					--print("Rez list request from: "..From)
					RM.Broadcast.RezSet(From)
					if Data == "C" then
						Command.Message.Send(From, "KBMRezReq", "R", RM.MessageSent)
					end
				end
			end
		end
	end
end


function RM:Start()
	self.MSG = KBM.MSG
	self.GUI:Init()
	self.Rezes:Init()
	Command.Message.Accept("raid", "KBMRezSet")
	Command.Message.Accept("raid", "KBMRezRem")
	Command.Message.Accept("raid", "KBMRezClear")
	Command.Message.Accept("party", "KBMRezSet")
	Command.Message.Accept("party", "KBMRezRem")
	Command.Message.Accept("party", "KBMRezClear")
	Command.Message.Accept("send", "KBMRezSet")
	Command.Message.Accept("send", "KBMRezReq")
	table.insert(Event.Message.Receive, {RM.MessageHandler, "KingMolinator", "Message Parse"})
end