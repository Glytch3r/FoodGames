----------------------------------------------------------------
-----  ▄▄▄   ▄    ▄   ▄  ▄▄▄▄▄   ▄▄▄   ▄   ▄   ▄▄▄    ▄▄▄  -----
----- █   ▀  █    █▄▄▄█    █    █   ▀  █▄▄▄█  ▀  ▄█  █ ▄▄▀ -----
----- █  ▀█  █      █      █    █   ▄  █   █  ▄   █  █   █ -----
-----  ▀▀▀▀  ▀▀▀▀   ▀      ▀     ▀▀▀   ▀   ▀   ▀▀▀   ▀   ▀ -----
----------------------------------------------------------------
--                                                            --
--   Project Zomboid Modding Commissions                      --
--   https://steamcommunity.com/id/glytch3r/myworkshopfiles   --
--                                                            --
--   ▫ Discord  ꞉   glytch3r                                  --
--   ▫ Support  ꞉   https://ko-fi.com/glytch3r                --
--   ▫ Youtube  ꞉   https://www.youtube.com/@glytch3r         --
--   ▫ Github   ꞉   https://github.com/Glytch3r               --
--                                                            --
----------------------------------------------------------------
----- ▄   ▄   ▄▄▄   ▄   ▄   ▄▄▄     ▄      ▄   ▄▄▄▄  ▄▄▄▄  -----
----- █   █  █   ▀  █   █  ▀   █    █      █      █  █▄  █ -----
----- ▄▀▀ █  █▀  ▄  █▀▀▀█  ▄   █    █    █▀▀▀█    █  ▄   █ -----
-----  ▀▀▀    ▀▀▀   ▀   ▀   ▀▀▀   ▀▀▀▀▀  ▀   ▀    ▀   ▀▀▀  -----
----------------------------------------------------------------
FoodGamesPanel = ISCollapsableWindow:derive("FoodGamesPanel")
--[[ 
function FoodGamesPanel:getColor()
    if self.mode == "HomeLender" then      
        self.themeCol =  { r = 0.8, g = 0.3, b = 0.3 }
        return { r = 0.8, g = 0.3, b = 0.3, a = 1 }
    elseif self.mode == "Wolferine" then
        self.themeCol = { r = 0.76, g = 0.47, b = 0.10 }
        return { r = 0.76, g = 0.47, b = 0.10,  a = 1 }
    elseif self.mode == "MagKneeToe" then
        self.themeCol = { r = 0.86, g = 0.36, b = 0.89}
        return { r = 0.86, g = 0.36, b = 0.89, a = 1}
    elseif self.mode == "GameBet" then
        self.themeCol = { r  = 0.99, g = 0.32, b = 0.64 }
        return { r = 0.99, g = 0.32, b = 0.64, a = 1 }
    end
    self.themeCol =  { r = 1, g = 1, b = 1 }
    return { r = 1, g = 1, b = 1, a = 1 }
end


 ]]
function FoodGamesPanel:getColor()    
    local col = FoodGames.colorList[self.mode]
    return {r=col.r,g=col.g,b=col.b,a=col.a}
end

FoodGames.modesStr = {
    "HomeLender",
    "Wolferine",
    "MagKneeToe",
    "GameBet",
}
FoodGames.sfxTable_On = {
    ["HomeLender"] = "HomeLander_ToggleOn",
    ["Wolferine"] = "Wolferine_ToggleOn",
    ["MagKneeToe"] = "MagKneeToe_Skill1",
    ["GameBet"] = "GameBet_Skill1",

}
FoodGames.sfxTable_Off = {
    ["HomeLender"] = "HomeLander_ToggleOff",
    ["Wolferine"] = "Wolferine_ToggleOff",
    ["MagKneeToe"] = "MagKneeToe_Skill2",
    ["GameBet"] = "GameBet_Skill2",

}

-----------------------            ---------------------------

function FoodGamesPanel:titleBarHeight()
    return 24   
end

function FoodGamesPanel:createChildren()
    ISCollapsableWindow.createChildren(self)
    self.modes = FoodGames.modesStr
    
--[[     self.data = self.player:getModData()['FoodGames']
    self.mode = getMode() ]]

    self.data = FoodGames.getData(self.player)
    self.mode = FoodGames.getMode(self.player)


    self.modeNum = { ["HomeLender"]=1,["Wolferine"]=2, ["MagKneeToe"]=3, ["GameBet"]=4  }
    
    self.modeIndex = self.modeNum[self.mode]
    self._lastButtonMode = nil
    self:setTitle("")

    self.borderColor.a = 0
    -- self.displayBackground = false
    self.backgroundColor.a = 0.9
    self.buttonBorderColor.a = 0
    local btnSize = 40   
    local sliderW = 190
    local sliderH = 20
    local gap = 42
    local divider = 24
    self.margin = self:titleBarHeight() + 4
    self.buttonsRow =  self.margin + (btnSize/2) - 5 
    self.sliderRow =   self.height /2  - divider + sliderH 
    self.sliderCol =   self.margin
    

    local col1 = self.margin 
    local col2 = self.margin  + gap
    local col3 = divider + col2 + gap
    local col4 = divider + col2 + (gap*2)
    self.arrowLeft = ISButton:new(col1, self.buttonsRow, btnSize, btnSize, "", self, function() self:onArrowLeft() end)
    --self.arrowLeft:setImage(getTexture("media/ui/Arrow_Left_" .. self.mode .. ".png"))
    self.arrowLeft:setImage(getTexture("media/ui/Arrow_Left_Off.png"))
    
    self.arrowLeft:initialise();
    self.arrowLeft:instantiate()
    self.arrowLeft:forceImageSize(32, 32)
    self.arrowLeft.borderColor.a = 0
    self.arrowLeft.displayBackground = false
    self:addChild(self.arrowLeft)
    
    self.arrowRight = ISButton:new(col2, self.buttonsRow, btnSize, btnSize, "", self,function() self:onArrowRight() end)
    --self.arrowRight:setImage(getTexture("media/ui/Arrow_Right_" .. self.mode .. ".png"))
    self.arrowRight:setImage(getTexture("media/ui/Arrow_Right_Off.png"))

    self.arrowRight:initialise();
    self.arrowRight:instantiate()
    self.arrowRight:forceImageSize(32, 32)
    self.arrowRight.borderColor.a = 0
    self.arrowRight.displayBackground = false
    self:addChild(self.arrowRight)

    -----------------------            ---------------------------
    self.activeSkill_1 = FoodGames.getActiveSkillStr(self.mode, 1)    
    self.activeSkill_2 = FoodGames.getActiveSkillStr(self.mode, 2)    
    -----------------------            ---------------------------


    local isAllowKeyBind = SandboxVars.FoodGames.AllowKeyBind or true
    local keyCaption = "Keybind: "
    local key1 = keyCaption..getKeyName(getCore():getKey("Food Games Skill 1"))    
    local key2 = keyCaption..getKeyName(getCore():getKey("Food Games Skill 2"))

    if not isAllowKeyBind then
        key1 = key1.." [DISABLED]"
        key2 = key2.." [DISABLED]"
    end
    -----------------------            ---------------------------

    self.Btn_Skill_1 = ISButton:new( col3, self.buttonsRow, btnSize, btnSize, "", self,function() FoodGames.onSkill(1) end)
    self.Btn_Skill_1:setImage(getTexture("media/ui/Icon_"..self.activeSkill_1.."_" .. self.mode .. ".png"))
    self.Btn_Skill_1:forceImageSize(32, 32)
    self.Btn_Skill_1.borderColor.a = 0
    self.Btn_Skill_1:initialise()
    self.Btn_Skill_1.displayBackground = false
    self.Btn_Skill_1.tooltip = tostring(key1)
    self:addChild(self.Btn_Skill_1)
    self.Btn_Skill_1:setVisible(true)


    self.Btn_Skill_2 = ISButton:new(col4, self.buttonsRow, btnSize, btnSize, "", self,function() FoodGames.onSkill(2) end)
    self.Btn_Skill_2:setImage(getTexture("media/ui/Icon_"..self.activeSkill_2.."_MagKneeToe.png"))
    self.Btn_Skill_2:forceImageSize(32, 32)
    self.Btn_Skill_2.borderColor.a = 0
    self.Btn_Skill_2:initialise()
    self.Btn_Skill_2.displayBackground = false
    self.Btn_Skill_2.tooltip = tostring(key2)
    self:addChild(self.Btn_Skill_2)
    
    self.EnergySlider = ISSliderPanel:new(self.sliderCol, self.sliderRow, sliderW, sliderH, self, self.onSliderChange)
    self.EnergySlider:initialise()
    self.EnergySlider:instantiate()
    --self.EnergySlider:setValues(0.0, 999, 1, 1, true)
    self.EnergySlider:setHeight(sliderH)
    self:addChild(self.EnergySlider)
    self.EnergySlider.sliderColor = self:getColor()    
    self.EnergySlider.sliderMouseOverColor = { r = 1, g = 1, b = 1, a = 1 }


end
    

function FoodGamesPanel:update()


    local hasTrait = self.player:HasTrait(tostring(self.mode))
    self._lastButtonMode = self.mode

    local isEnabled_1 = FoodGames.isHasEnergy(self.player, 1, self.mode)
    local isEnabled_2 = FoodGames.isHasEnergy(self.player, 2, self.mode)

    self.Btn_Skill_1:setEnable(isEnabled_1)
    self.Btn_Skill_2:setEnable(isEnabled_2) 


    self.activeSkill_1 = FoodGames.getActiveSkillStr(tostring(self.mode), 1)   
    self.activeSkill_2 = FoodGames.getActiveSkillStr(tostring(self.mode), 2)   

    
    
    self.Btn_Skill_1:setImage(getTexture("media/ui/Icon_" .. tostring(self.activeSkill_1) .. "_" .. tostring(self.mode) .. ".png"))

    local isMag = tostring( self.mode )== "MagKneeToe"
    local isGam = tostring( self.mode )== "GameBet"
    
    self.Btn_Skill_2:setVisible(isGam or isMag)

    if isMag or isGam then
        self.Btn_Skill_2:setImage(getTexture("media/ui/Icon_" .. tostring(self.activeSkill_2) .. "_" .. tostring(self.mode) .. ".png"))
        if not self.activeSkill_2 then
            self.Btn_Skill_2.textureColor.a = 0.2
        else
            self.Btn_Skill_2.textureColor.a = 1
        end
    end
    -- self.EnergySlider.sliderColor:setVisible(not self.isSkillActiveStr);
  

    --self.Btn_Skill_2:setTooltip("Only available for MagKneeToe")
    --self.arrowLeft:setImage(getTexture("media/ui/Arrow_Left_" .. tostring(self.mode) .. ".png"))
    --self.arrowRight:setImage(getTexture("media/ui/Arrow_Right_" .. tostring(self.mode) .. ".png"))

--[[     self.arrowLeft.tooltip = tostring(key1)
    self.arrowRight.tooltip = tostring(key1) ]]

    --self.EnergySlider.setVisible(self.mode ~= "GameBet")


    self.arrowLeft.textureColor = FoodGames.colorList[self.mode]
    self.arrowRight.textureColor = FoodGames.colorList[self.mode]
    
    self.headStr = "Food Game:    " .. tostring(self.mode)
end

-----------------------            ---------------------------

function FoodGamesPanel:onArrowLeft()
    if not FoodGames.isHero(self.player) then return end
    FoodGames.disableAllSkills()
    self.modeIndex, self.mode = FoodGames.getPrevMode(self.player, self.modeIndex)
    self.player:getModData().FoodGames.Mode = self.mode
    self:update()
    getSoundManager():playUISound("UIActivateTab")
    self:SliderUpdatePos()
end

function FoodGamesPanel:onArrowRight()
    if not FoodGames.isHero(self.player) then return end
    FoodGames.disableAllSkills()
    self.modeIndex, self.mode = FoodGames.getNextMode(self.player, self.modeIndex)
    self.player:getModData().FoodGames.Mode = self.mode
    self:update()
    getSoundManager():playUISound("UIActivateTab")
    self:SliderUpdatePos()
end

function FoodGamesPanel:SliderUpdatePos()
    
    local max = FoodGames.getMaxEnergy(self.mode)
    self.EnergySlider.maxValue = max

end
-----------------------            ---------------------------
function FoodGamesPanel:onSliderChange(val, _slider)
    if getCore():getDebug() then
        if self.mode == "GameBet" and self.player:HasTrait("GameBet") then
            self.data['StoredCards'] = val
            print(tostring(self.data['StoredCards']))
        elseif self.mode == "MagKneeToe" and self.player:HasTrait("MagKneeToe") then
            self.data['StoredMetal'] = val
            print(tostring(self.data['StoredMetal']))
        else
            self.data['StoredCalories'] = val
            print(tostring(self.data['StoredCalories']))
        end
    end

    --getSoundManager():playUISound("UIActivateButton")
end


-----------------------            ---------------------------
function FoodGames.isDualSkilled(mode)
    mode = mode or FoodGames.getMode()
    local tab = {
        ["MagKneeToe"] = true,
        ["GameBet"] = true,        
    }
    return tab[mode] or false
end

function FoodGames.getOtherSkill(skillNum)
    local tab = {
        [1] = 2,
        [2] = 1,
    }
    return tab[skillNum]
end
-----------------------            ---------------------------
function FoodGames.onSkill(skillNum)
    local pl = getPlayer()
    if not pl then return end
    skillNum = skillNum or 1
    local mode = FoodGames.getMode(pl)
    local isActive = FoodGames.isActiveSkill(mode, skillNum)
    if skillNum == 2 then
        if  FoodGames.isHasEnergy(pl, 2) then
            FoodGames.disableAllSkills()
            FoodGames.setActiveSkill(mode, 2, true)
            timer:Simple(1, function() 
                FoodGames.disableAllSkills()
            end)
        end
    end
    local sfx = "UIActivateMainMenuItem"

    if not FoodGames.isHasEnergy(pl, skillNum) then
        FoodGames.disableSkill(pl, skillNum, mode)
        return
    end

    local isMagKneeToe = mode == "MagKneeToe"
    local isGameBet = mode == "GameBet"
    local isDualSkill = FoodGames.isDualSkilled(mode)

    if (isMagKneeToe or isGameBet) and skillNum == 2 then
        if not pl:HasTrait(mode) then return end
        if not FoodGames.consumeEnergy(pl, skillNum) then return end
        FoodGames.doAoE(skillNum)
        getSoundManager():playUISound(FoodGames.sfxTable_On[mode])
        return
    end

    if isDualSkill then
        local otherSkill = FoodGames.getOtherSkill(skillNum)
        local otherActive = FoodGames.isActiveSkill(mode, otherSkill)
        if otherActive then
            FoodGames.disableSkill(pl, otherSkill, mode)
        end
    end

    if isActive then
        sfx = FoodGames.sfxTable_Off[mode]
        FoodGames.disableAllSkills()
    else
        if not pl:HasTrait(mode) then return end
        sfx = FoodGames.sfxTable_On[mode]
        if FoodGames.isHasEnergy(pl, skillNum) then
            if mode == "Wolferine" then
                FoodGames.doHealRandPart(pl)
            end
            FoodGames.setActiveSkill(mode, skillNum, true)
        end
    end
    getSoundManager():playUISound(sfx)
end



-----------------------            ---------------------------
--[[ 
function FoodGames.onSkill(skillNum)
    local pl = getPlayer(); 
    if not pl then return end 
    skillNum = skillNum or 1
    local data = FoodGames.getData(pl)
    local mode = FoodGames.getMode(pl)
    print(FoodGames.getMode(pl))
    local isActive = FoodGames.isActiveSkill(mode, skillNum)
    
    local sfx = "UIActivateMainMenuItem"

    if not FoodGames.isHasEnergy(pl, skillNum) then
        FoodGames.disableSkill(pl, skillNum, mode)
        return
    end
    
    local isMagKneeToe = mode == "MagKneeToe"
    local isGameBet = mode == "GameBet"
    local isDualSkill =  FoodGames.isDualSkilled(mode)

    if isDualSkill then
        --local otherSkill = (skillNum == 1) and 2 or 1
        local otherSkill = FoodGames.getOtherSkill(skillNum)
        local otherActive = FoodGames.isActiveSkill(mode, otherSkill)
        if otherActive then
            FoodGames.disableSkill(pl, otherSkill, mode)
        end     
    end
    if isActive then
        sfx = FoodGames.sfxTable_Off[mode]
        FoodGames.disableAllSkills()
    else
        if not pl:HasTrait(mode) then return end
        sfx = FoodGames.sfxTable_On[mode]
        if FoodGames.isHasEnergy(pl, skillNum) then            
            if mode == "Wolferine" then
                FoodGames.doHealRandPart(pl)
            end
            FoodGames.setActiveSkill(mode, skillNum, true)
        end
    end
    getSoundManager():playUISound(sfx)
    --print(self.mode)
end
 ]]

--[[ function FoodGames.doDualSkill2Action(isMagKneeToe, isGameBet, mode)
    local pl = getPlayer(); if not pl then return end 
    if FoodGames.consumeEnergy(pl, 2, mode) then
        if isMagKneeToe or isGameBet then
            FoodGames.doShotgun2()            
        end
        self.Btn_Skill_1:setEnable(false)
        self.Btn_Skill_2:setEnable(false)
        timer:Simple(1.5, function()
            FoodGames.disableSkill(self.player, 2, self.mode)
            self.Btn_Skill_1:setEnable(true)
            self.Btn_Skill_2:setEnable(true)
        end)
    end
end
 ]]
-----------------------            ---------------------------

function FoodGamesPanel:new(x, y, width, height, player)
    local o = ISCollapsableWindow.new(self, x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.user = player:getUsername()

    o.drawFrame = true
	o.clearStentil = true;
    o.anchorLeft = true
    o.anchorRight = true
    o.anchorTop = true
    o.anchorBottom = true
    o.borderColor = { r = 0.76, g = 0.59, b = 0.11, a = 1}
    o.backgroundColor = { r = 0, g = 0, b = 0, a =  0.9}--{ r = 0.12, g = 0.39, b = 0.77,  a = 1}
    o.buttonBorderColor = {r = 0.7, g = 0.7, b = 0.7, a = 1}


    o.moveWithMouse = true


    o.data = player:getModData()['FoodGames']
    o.mode = o.data['Mode']

    

    o:setResizable(false)
    o.resizable = false

    return o
end
-----------------------            ---------------------------
function FoodGamesPanel:close()
    if FoodGamesPanel.instance ~= nil then
        FoodGamesPanel.instance:setVisible(false)
        FoodGamesPanel.instance:removeFromUIManager()
        FoodGamesPanel.instance = nil
    end
end
function FoodGames.toggle()
    if FoodGamesPanel.instance ~= nil then
        FoodGamesPanel:close()
    else
        FoodGames.open()
    end
end


function FoodGames.open()
    local pl = getPlayer();
    if not pl then return end 
    FoodGames.dataInit()
    local fg = pl:getModData()["FoodGames"]
    
    if type(fg.StoredMetal) ~= "number" then
        fg.StoredMetal = 0
    end
    if type(fg.StoredCalories) ~= "number" then
        fg.StoredCalories = 0
    end
    if FoodGamesPanel.instance == nil then
        local sW = getCore():getScreenWidth()
        local sH = getCore():getScreenHeight()
        local sX = sW / 3 - 100
        local sY = sH / 2 - 350
        local W =  345  -- 322

        local H = 210  -- 172
        FoodGamesPanel.instance = FoodGamesPanel:new(sX, sY, W, H, pl)
        FoodGamesPanel.instance:initialise()
        FoodGamesPanel.instance:addToUIManager()
        return FoodGamesPanel.instance
    else
        FoodGamesPanel.instance:close()
    end
end


function FoodGames.refresh()
    if FoodGamesPanel.instance ~= nil then
        FoodGamesPanel:close()
        FoodGames.open()
    end
end
-----------------------            ---------------------------

function FoodGamesPanel:render()
    ISCollapsableWindow.render(self)
    
    self:update()
end

function FoodGamesPanel:drawTextWithBG(text, x, y, font)
    local lines = {}
    for line in string.gmatch(text, "([^\n]*)\n?") do
        table.insert(lines, line)
    end
    local textWidth = 0
    for _, line in ipairs(lines) do
        local w = getTextManager():MeasureStringX(font, line)
        if w > textWidth then textWidth = w end
    end
    local textHeight = (#lines * getTextManager():getFontHeight(font))

    local col = FoodGames.colorList[self.mode]
    local heroColor = {r=col.r, g=col.g, b=col.b, a=col.a}
    self.themeCol = {r=col.r, g=col.g, b=col.b, a=0.6}

    local bgR, bgG, bgB, bgA = 0, 0, 0, 0.8 
   

    if FoodGames.isActiveSkill(self.mode, 1) or FoodGames.isActiveSkill(self.mode, 2) then
        self.backgroundColor  = { r = 0, g = 0, b = 0, a = 0.8}
        self:drawRect(x - 2, y - 2, textWidth + 4, textHeight + 4, 0.9, heroColor.r, heroColor.g, heroColor.b)
        self:drawText(text, x, y,  0, 0, 0, 1, font)
    else
        self.backgroundColor  = { r = 0.2, g = 0.2, b = 0.2, a = 0.4}
        self:drawRect(x - 2, y - 2, textWidth + 4, textHeight + 4, 0.9, 0, 0, 0)    
        self:drawText(text, x, y, heroColor.r, heroColor.g, heroColor.b, 1, font)
    end
end

function FoodGamesPanel:prerender()
    ISCollapsableWindow.prerender(self)
    self.data = self.player:getModData()['FoodGames']
    self.mode = self.data['Mode']

    self.bgTexture = getTexture("media/ui/BG_"..tostring(self.isSkillActiveStr).."_" .. self.mode .. ".png")
    if self.bgTexture then
        self.bgX = (self.width / 2) - (self.bgTexture:getWidth() / 2)
        self.bgY = self:titleBarHeight() + 4
        self:drawTexture(self.bgTexture, self.bgX, self.bgY, 1, 1, 1, 1, 0.3)
    end
   
    self.headerFont = UIFont.Small
    self.infoFont = UIFont.Medium
    if SandboxVars.FoodGames.LargeFonts then
        self.headerFont = UIFont.Medium
        self.infoFont = UIFont.Large
    end

    local sliderEnergy = nil

    if self.mode == "GameBet" then
        local cards = tonumber(self.data["StoredCards"]) or 0
        local max = SandboxVars.FoodGames.MaxCardsQty or 46080
        self.EnergySlider.maxValue = max
        cards = math.max(0, math.min(max, cards))
        self:drawTextWithBG("Cards: \n" .. tostring(math.floor(cards)) .. " / " .. tostring(max), self.margin+4, self.sliderRow+self.margin+5, self.infoFont)
        sliderEnergy = cards

    elseif self.mode == "MagKneeToe" then
        local metal = tonumber(self.data["StoredMetal"]) or 0
        local max = SandboxVars.FoodGames.MaxMetalCapacity or 46080
        self.EnergySlider.maxValue = max
        metal = math.max(0, math.min(max, metal))
        self:drawTextWithBG("Metal Stored: \n" .. tostring(math.floor(metal)) .. " / " .. tostring(max), self.margin+4, self.sliderRow+self.margin+5, self.infoFont)
        sliderEnergy = metal

    else     
        local calories = tonumber(self.data["StoredCalories"]) or 0
        local max = SandboxVars.FoodGames.DailyMaxCalories or 99999
        self.EnergySlider.maxValue = max
        calories = math.max(0, math.min(max, calories))
        local storedFood = FoodGames.convertDaysToYMD(calories)
        self:drawTextWithBG("Food Stored: " .. tostring(math.floor(calories)) .. "\n" .. tostring(storedFood), self.margin+4, self.sliderRow+self.margin+5, self.infoFont)
        sliderEnergy = calories
    end

    if sliderEnergy then
        self.EnergySlider.currentValue = sliderEnergy
    end
    self.EnergySlider.sliderColor = self:getColor()

    self.activeSkill_1 = FoodGames.getActiveSkillStr(self.mode, 1)    
    self.activeSkill_2 = FoodGames.getActiveSkillStr(self.mode, 2)   
    self.isSkillActiveStr = FoodGames.getAnySkillActiveStr(self.mode)


    
    self.Btn_Skill_1:setEnable(FoodGames.isActiveSkill(self.mode, 1))
    self.Btn_Skill_2:setEnable(FoodGames.isActiveSkill(self.mode, 2))
    

    local prevIndex, prevMode = FoodGames.getPrevMode(self.player, self.modeIndex)
    local nextIndex, nextMode = FoodGames.getNextMode(self.player, self.modeIndex)
    self.arrowLeft.tooltip = prevMode
    self.arrowRight.tooltip = nextMode

    local col = self:getColor()
    self:update()
    self.header = self:drawTextCentre(self.headStr, self.width/2, 4, col.r,  col.g,  col.b, 1, self.headerFont)
end
