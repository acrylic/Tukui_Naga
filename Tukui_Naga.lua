-- Tukui_Naga
-- An Alternative to the default action bar that mimics the buttons on the Razer Naga
--
-- https://github.com/acrylic/Tukui_Naga
-- original edit by tweetix
local TG, TC, TL = Tukui:unpack()

if not TC["ActionBars"].Enable == true then return end

local Size = TC['ActionBars']['NormalButtonSize']
local Spacing = TC['ActionBars']['ButtonSpacing']
local Num = NUM_ACTIONBAR_BUTTONS
local Movers = TG["Movers"]

-- frame
local NagaFrame = CreateFrame("Frame", "NagaFrame", UIParent, "SecureHandlerStateTemplate")
NagaFrame:SetTemplate()
NagaFrame:SetWidth((Size * 3) + (Spacing * 4))
NagaFrame:SetHeight((Size * 4) + (Spacing * 5))
NagaFrame:SetPoint("CENTER", UIParent, 0, 0)
NagaFrame:SetFrameStrata("BACKGROUND")
NagaFrame:SetFrameLevel(2)
NagaFrame.Backdrop = CreateFrame("Frame", nil, NagaFrame)
NagaFrame.Backdrop:SetAllPoints()

-- buttons
local NagaBar = CreateFrame("Frame", "NagaBar", NagaFrame, "SecureHandlerStateTemplate")
NagaBar:SetAllPoints(NagaFrame)

hooksecurefunc( TG['ActionBars'], 'CreateBar1', function()
	TG['Panels']['ActionBar1']:HookScript( 'OnEvent', function( self, event, unit, ... )
		if( event == 'PLAYER_ENTERING_WORLD' ) then
                        local Button, Previous
                        
                        for i = 1, NUM_ACTIONBAR_BUTTONS do
                                Button = TG['Panels']['ActionBar1']['Button' .. i]
                                Previous = TG['Panels']['ActionBar1']['Button' .. i-1]
                                
                                Button:ClearAllPoints()
                                Button:SetParent( NagaBar )
                                Button:Size( Size, Size )
                                Button:SetFrameStrata("BACKGROUND")
                                Button:SetFrameLevel(15)
                                
                                if i == 1 then
                                    Button:SetPoint("TOPLEFT", NagaBar, "TOPLEFT", Spacing, -Spacing)
                                elseif i == 4 then
                                    Button:SetPoint("TOP", TG['Panels']['ActionBar1']['Button1'], "BOTTOM", 0, -Spacing)
                                elseif i == 7 then
                                    Button:SetPoint("TOP", TG['Panels']['ActionBar1']['Button4'], "BOTTOM", 0, -Spacing)
                                elseif i == 10 then
                                    Button:SetPoint("TOP", TG['Panels']['ActionBar1']['Button7'], "BOTTOM", 0, -Spacing)
                                else
                                    Button:SetPoint("LEFT", Previous, "RIGHT", Spacing, 0)
                                end
			end
		end
	end )
end )

-- hide during pet battles
RegisterStateDriver( NagaFrame, "visibility", "[petbattle] hide; show" );

-- move MultiBarRight to bar 1's place
hooksecurefunc( TG['ActionBars'], 'CreateBar5', function()
    local Anchor = TG['Panels']['ActionBar1']
    Anchor:SetAlpha(1)
    MultiBarLeft:SetParent( Anchor )
    
    local Button, Previous
    
    for i = 1, 12 do
        Button = TG['Panels']['ActionBar5']['Button' .. i]
        Previous = TG['Panels']['ActionBar5']['Button' .. i - 1]
        
        Button:ClearAllPoints()
        Button:Size( Size, Size )
        Button:SetFrameStrata( 'BACKGROUND' )
        Button:SetFrameLevel( 15 )
        
        if i == 1 then
            Button:SetPoint( 'TOPLEFT', Anchor, 'TOPLEFT', Spacing, -Spacing)
        else
            Button:SetPoint( 'LEFT', Previous, "RIGHT", Spacing, 0)
        end
    end
    
    -- hide TukuiActionBar5
    TG['Panels']['ActionBar5']:SetAlpha(0)
end )

-- hide the TukuiBar5 frame, and the toggle buttons for pets.
Movers:RegisterFrame( NagaFrame )