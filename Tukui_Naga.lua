-- Thanks for downloading the Tukui Naga addon.
-- This is designed to make using the Razer Naga easier with the Tukui interface.
-- It's not really finished and is full of bugs atm, as my LUA skillz aren't exactly pro.
-- You can reach me at facta.ne@gmail.com if you wish.

-- Known issues:
-- # Pet Bar doesn't look right with this addon.
-- # Bar 1 code needs shortening. I don't have a clue what needs changing though.

local T, C, L = unpack(Tukui)
--local font = TukuiCF.media.font

if not C["actionbar"].enable == true then return end

-- Main code.
local nagaWidth = (T.buttonsize * 3) + (T.buttonspacing * 4)
local nagaHeight = (T.buttonsize * 4) + (T.buttonspacing * 5)

local function placeNaga()
	local anchor = CreateFrame("Button", "NagaAnchor", UIParent)
	local nagaFrame = CreateFrame("Frame", "NagaFrame", UIParent)
	
  		anchor:SetAlpha(0)
		anchor:SetTemplate("Default")
		anchor:SetBackdropBorderColor(1, 0, 0, 1)
		anchor:SetMovable(true)
		anchor:SetHeight(20)
		anchor:SetWidth(nagaWidth)
		anchor.text = T.SetFontString(anchor, C["media"].uffont, 12)
		anchor.text:SetPoint("CENTER")
		anchor.text:SetText("Naga bar")
		anchor.text.Show = function() anchor:SetAlpha(1) end
		anchor.text.Hide = function() anchor:SetAlpha(0) end
		anchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

		nagaFrame:CreatePanel(nagaFrame, 1, 1, "TOP", anchor, "BOTTOM", 0, -3)
		nagaFrame:SetWidth(nagaWidth)
		nagaFrame:SetHeight(nagaHeight)
		nagaFrame:SetFrameLevel(2)

--[[	local nagaClose = CreateFrame("Frame", "NagaClose", NagaFrame)
		nagaClose:CreatePanel(nagaClose, 1, 1, "BOTTOM", nagaFrame, "TOP", 0, 3)
		nagaClose:SetHeight(10)
		nagaClose:SetWidth(nagaWidth)
		nagaClose.Text = TukuiDB.SetFontString(NagaClose, TukuiCF["media"].font, 9)
		nagaClose.Text:SetText("-")
		nagaClose.Text:SetPoint("CENTER")
		nagaClose:EnableMouse(true)
		nagaClose:SetScript("OnMouseDown", function(self)
			NagaFrame:Hide()
		end)

	local nagaOpen = CreateFrame("Frame", "NagaOpen", UIParent)
		nagaOpen:CreatePanel(nagaOpen, 1, 1, "BOTTOM", TukuiBar1, "TOP", 0, TukuiDB.buttonspacing)
		nagaOpen:SetHeight(10)	
		nagaOpen:SetWidth(nagaWidth)
		nagaOpen.Text = TukuiDB.SetFontString(NagaOpen, TukuiCF["media"].font, 11)
		nagaOpen.Text:SetText("+")
		nagaOpen.Text:SetPoint("CENTER")
		nagaOpen:EnableMouse(true)
		nagaOpen:SetScript("OnMouseDown", function(self)
			NagaFrame:Show()
		end)
		nagaOpen:SetFrameLevel(1)
]]--		
	local nagaBar = CreateFrame("Frame", "NagaBar", NagaFrame)
		nagaBar:SetAllPoints(NagaFrame)

	-- The following is not ideal but it works.
	nagaBar:RegisterEvent("PLAYER_LOGIN")
	nagaBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	nagaBar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
	nagaBar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	nagaBar:RegisterEvent("BAG_UPDATE")
	nagaBar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	nagaBar:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			local button
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				button = _G["ActionButton"..i]
			end	

			self:SetAttribute("_onstate-page", [[ 
				for i, button in ipairs(buttons) do
					button:SetAttribute("actionpage", tonumber(newstate))
				end
			]])
		elseif event == "PLAYER_ENTERING_WORLD" then
			--MainMenuBar_UpdateKeyRing()
			local button
			for i = 1, 12 do
				button = _G["ActionButton"..i]
				button:SetSize(T.buttonsize, T.buttonsize)
				button:ClearAllPoints()
				button:SetParent(nagaBar)
				button:SetFrameStrata("BACKGROUND")
				button:SetFrameLevel(15)
				if i == 1 then
					button:SetPoint("TOPLEFT", nagaBar, "TOPLEFT", T.Scale(4), T.Scale(-4))
				elseif i == 4 then
					button:SetPoint("TOP", ActionButton1, "BOTTOM", 0, T.Scale(-4))
				elseif i == 7 then
					button:SetPoint("TOP", ActionButton4, "BOTTOM", 0, T.Scale(-4))
				elseif i == 10 then
					button:SetPoint("TOP", ActionButton7, "BOTTOM", 0, T.Scale(-4))
				else
				local previous = _G["ActionButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", T.buttonspacing, 0)
				end
		end
		else
			MainMenuBar_OnEvent(self, event, ...)
		end
	end)

	-- Move Bar 4 down into Bar 1's place.
	MultiBarLeft:SetParent(TukuiBar1)
	for i= 1, 12 do
		local b = _G["MultiBarLeftButton"..i]
		local b2 = _G["MultiBarLeftButton"..i-1]
		b:SetSize(T.buttonsize, T.buttonsize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		if i == 1 then
			b:SetPoint("BOTTOMLEFT", TukuiBar1, T.buttonspacing, T.buttonspacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
		end
	end

	-- Move Bar 5 across into Bar 4's place.
	MultiBarRight:SetParent(TukuiBar4)
	for i= 1, 12 do
		local b = _G["MultiBarRightButton"..i]
		local b2 = _G["MultiBarRightButton"..i-1]
		b:SetSize(T.buttonsize, T.buttonsize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		if i == 1 then
			b:SetPoint("TOPLEFT", TukuiBar4, T.buttonspacing, -T.buttonspacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
		end
	end
	TukuiBar5:Hide()
end

-- Add Tukui Naga into Tukz's /moveui
placeNaga()
table.insert(T.AllowFrameMoving, NagaAnchor)
