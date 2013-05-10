-- Tukui_Naga
-- An Alternative to the default action bar that mimics the buttons on the Razer Naga
--
-- https://github.com/acrylic/Tukui_Naga
-- original edit by tweetix

local T, C, L, G = unpack(Tukui)

if not C["actionbar"].enable == true then return end

-- some local sizes
local nagaWidth = (T.buttonsize * 3) + (T.buttonspacing * 4)
local nagaHeight = (T.buttonsize * 4) + (T.buttonspacing * 5)

-- create the anchor for the mover
local anchor = CreateFrame("Button", "NagaAnchor", UIParent)
anchor:SetAlpha(0)
anchor:SetTemplate()
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

-- container for the buttons
local nagaFrame = CreateFrame("Frame", "NagaFrame", UIParent)
nagaFrame:SetTemplate()
nagaFrame:SetWidth(nagaWidth)
nagaFrame:SetHeight(nagaHeight)
nagaFrame:SetPoint("BOTTOM", anchor, "TOP", 0, 3)
nagaFrame:SetFrameLevel(2)
nagaFrame:SetFrameStrata("BACKGROUND")

-- buttons
local nagaBar = CreateFrame("Frame", "NagaBar", NagaFrame)
nagaBar:SetAllPoints(NagaFrame)

-- bind events, and apply the buttons
-- run the same stuff as on modules/actionbars/bar1.lua
nagaBar:RegisterEvent("PLAYER_LOGIN")
nagaBar:RegisterEvent("PLAYER_ENTERING_WORLD")
nagaBar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
nagaBar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
nagaBar:RegisterEvent("BAG_UPDATE")
nagaBar:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
nagaBar:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
nagaBar:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			G.ActionBars.Bar1["Button"..i] = button
		end	
	elseif event == "PLAYER_ENTERING_WORLD" then
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
	elseif event == "UPDATE_VEHICLE_ACTIONBAR" or event == "UPDATE_OVERRIDE_ACTIONBAR" then
		if HasVehicleActionBar() or HasOverrideActionBar() then
			if not self.inVehicle then
				TukuiBar2Button:Hide()
				TukuiBar3Button:Hide()
				TukuiBar4Button:Hide()
				self.inVehicle = true
			end
		else
			if self.inVehicle then
				TukuiBar2Button:Show()
				TukuiBar3Button:Show()
				TukuiBar4Button:Show()
				self.inVehicle = false
			end
		end
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

-- hide during pet battles
RegisterStateDriver( nagaFrame, "visibility", "[petbattle] hide; show" );

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

-- hide the TukuiBar5 frame, and the toggle buttons for pets.
RegisterStateDriver( TukuiBar5, "visibility", "hide")
TukuiLineToPetActionBarBackground:Hide()
TukuiBar5ButtonTop:Hide()
TukuiBar5ButtonBottom:Hide()

table.insert(T.AllowFrameMoving, NagaAnchor)
