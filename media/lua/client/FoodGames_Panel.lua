FoodGamesPanel = ISCollapsableWindow:derive("FoodGamesPanel")
--[[
function FoodGamesPanel:initialise()
    ISCollapsableWindow.initialise(self)

    self:setResizable(false)
    --self:setDrawFrame(true)




   -- self:createChildren()
end ]]
function FoodGamesPanel:getColor()
    if self.mode == "HomeLender" then      
        self.themeCol =  { r = 0.8, g = 0.3, b = 0.3 }
        return { r = 0.8, g = 0.3, b = 0.3, a = 1 }
    elseif self.mode == "Wolferine" then
        self.themeCol = { r = 0.76, g = 0.47, b = 0.10 }
        return { r = 0.76, g = 0.47, b = 0.10,  a = 1 }
    elseif self.mode == "MagKneeToe" then
        self.themeCol = { r = 0.86, g = 0.36, b = 0.89  , a = 1}
        return { r = 0.86, g = 0.36, b = 0.89  , a = 1}
    end
    self.themeCol =  { r = 1, g = 1, b = 1 }
    return { r = 1, g = 1, b = 1, a = 1 }
end

-----------------------            ---------------------------
--[[ function FoodGamesPanel.TitleBarHeight()
    return 42
end ]]
function FoodGamesPanel:titleBarHeight()
    return 42   
end
function FoodGamesPanel:createChildren()
    ISCollapsableWindow.createChildren(self)
    self.modes = { "HomeLender", "Wolferine", "MagKneeToe" }
    self.data = self.player:getModData()['FoodGames']
    self.mode = self.data['Mode']
    self.modeNum = { ["HomeLender"]=1,["Wolferine"]=2, ["MagKneeToe"]=3 }
    
    self.modeIndex = self.modeNum[self.mode]
    self._lastButtonMode = nil
    self:setTitle("")

    self.borderColor.a = 0
   -- self.displayBackground = false
    self.backgroundColor.a = 0.9
    self.buttonBorderColor.a = 0
    local btnSize = 40

    self.sliderRow =  btnSize + 20 + self:titleBarHeight()
    self.margin = 15
    local btnW, btnH = 40, 40
    self.buttonsRow = btnSize + self.margin - 5 --self.height - self:titleBarHeight() - self.margin - btnH  -5
   
    local baseX, baseY = 24, 30
    --local buttonsRow = self.height - btnH - self.margin
    self.sliderCol = self.margin + 23

    
    self.arrowLeft = ISButton:new(self.margin, self.buttonsRow, btnW, btnH, "", self, function() self:onArrowLeft() end)
    self.arrowLeft:setImage(getTexture("media/ui/Arrow_Left_" .. self.mode .. ".png"))
    self.arrowLeft:initialise();
    self.arrowLeft:instantiate()
    self.arrowLeft:forceImageSize(27, 33)
    self.arrowLeft.borderColor.a = 0
    self.arrowLeft.displayBackground = false
    self:addChild(self.arrowLeft)
    --local arrow2Col = self.width - margin - btnW - 5
    local arrow2Col = 70
    self.arrowRight = ISButton:new(self.margin*2+btnSize, self.buttonsRow, btnW, btnH, "", self,function() self:onArrowRight() end)
    self.arrowRight:setImage(getTexture("media/ui/Arrow_Right_" .. self.mode .. ".png"))
    self.arrowRight:initialise();
    self.arrowRight:instantiate()
    self.arrowRight:forceImageSize(27, 33)
    self.arrowRight.borderColor.a = 0
    self.arrowRight.displayBackground = false
    self:addChild(self.arrowRight)



    --self.data[tostring(self.mode)][1] or FoodGames.getSkil1(self.mode)
    self.Btn_Skill_1 = ISButton:new(self.width / 2 - btnW - 5, self.buttonsRow, btnW, btnH, "", self,function() self:onSkill(1) end)
    self.activeSkill_1 = FoodGames.getActiveSkillStr(self.mode, 1)    
    self.Btn_Skill_1:setImage(getTexture("media/ui/Icon_"..self.activeSkill_1.."_" .. self.mode .. ".png"))
    self.Btn_Skill_1:forceImageSize(32, 32)
    self.Btn_Skill_1.borderColor.a = 0
    self.Btn_Skill_1:initialise()
    self.Btn_Skill_1.displayBackground = false

    self:addChild(self.Btn_Skill_1)

    --self.activeSkill_1 = self.data[tostring(self.mode)][2] or  FoodGames.getSkil2(self.mode)
    -- self.activeSkill_2 = FoodGames.getSkil2(self.mode)
    self.Btn_Skill_2 = ISButton:new(self.width / 2 , self.buttonsRow, btnW, btnH, "", self,function() self:onSkill(2) end)
    self.activeSkill_2 = FoodGames.getActiveSkillStr(self.mode, 2)    
    self.Btn_Skill_2:setImage(getTexture("media/ui/Icon_"..self.activeSkill_2.."_MagKneeToe.png"))
    self.Btn_Skill_2:forceImageSize(32, 32)
    self.Btn_Skill_2.borderColor.a = 0
    self.Btn_Skill_2:initialise()
    self.Btn_Skill_2.displayBackground = false

    self:addChild(self.Btn_Skill_2)

    self.Btn_Skill_1:setEnable(self.modes ~= "MagKneeToe")
    self.Btn_Skill_1:setVisible(self.modes ~= "MagKneeToe")

    self.Btn_Skill_2:setEnable(self.modes ~= "MagKneeToe")
    self.Btn_Skill_2:setVisible(self.modes ~= "MagKneeToe")
    local sliderW = 120
    local sliderH = 20

--[[     local sliderW = 186
    local sliderH = 32
    local sliderX = math.floor((self.width - sliderW) / 2)

    local sliderY1 = baseY + 60
    local sliderY2 = sliderY1 + sliderH
 ]]
    --self.sliderX = (self.width - sliderW) / 2
    self.sliderX = 24
    self.EnergySlider = ISSliderPanel:new(self.sliderX, self.sliderRow-5, sliderW, sliderH, self, self.onSliderChange)
    self.EnergySlider:initialise()
    self.EnergySlider:instantiate()
    --self.EnergySlider:setValues(0.0, 999, 1, 1, true)
    self.EnergySlider:setHeight(sliderH)
    self:addChild(self.EnergySlider)


    self.EnergySlider.sliderColor = self:getColor()

--[[     self.EnergySlider.texBtn_Left = self.ArrowLeft
    self.EnergySlider.texBtn_Right = self.ArrowRight
 ]]
    self:updateSliderValue()
    self:update()
    


end
-----------------------            ---------------------------
function FoodGamesPanel:onSliderChange(_newval, _slider)
  
    if getCore():getDebug() then
        if self.mode == "MagKneeToe" then
            self.player:getModData()['FoodGames']['StoredMetal'] = self.EnergySlider:getCurrentValue()
        else
            self.player:getModData()['FoodGames']['ConsumedCalories'] = self.EnergySlider:getCurrentValue()
        end
    end

--[[     self.EnergySlider:setValues(0, max, math.floor(val))
    self.EnergySlider:setValues(0, 99999, math.floor(val)) ]]
end


function FoodGamesPanel:updateSliderValue()
    local data = self.player:getModData()['FoodGames']
    if self.mode == "MagKneeToe" then
        self.EnergySlider:setCurrentValue(tonumber(data.StoredMetal) or 0)
    else
        self.EnergySlider:setCurrentValue(tonumber(data.ConsumedCalories) or 0)
    end
    self.EnergySlider.sliderColor = self:getColor()
    self:update()
end


function FoodGamesPanel:update()

    local hasTrait = self.player:HasTrait(tostring(self.mode))
    
    if self.mode == self._lastButtonMode then return end
    self._lastButtonMode = self.mode

    self.Btn_Skill_1:setEnable(hasTrait)
    self.Btn_Skill_2:setEnable(hasTrait)

    local isBtn2 = self.mode == "MagKneeToe"
    self.Btn_Skill_2:setVisible(isBtn2)

    if not hasTrait then
        local tip = "Requires " .. tostring(self.mode) .. " trait"
        self.Btn_Skill_1:setTooltip(tip)
        self.Btn_Skill_2:setTooltip(tip)
    else
        self.Btn_Skill_1:setTooltip(nil)
        self.Btn_Skill_2:setTooltip(nil)
    end
    
    self.headStr = "Food Game:    " .. tostring(self.mode)
    self.activeSkill_1 = FoodGames.getActiveSkillStr(tostring(self.mode), 1)
   
    self.Btn_Skill_1:setImage(getTexture("media/ui/Icon_" .. tostring(self.activeSkill_1) .. "_" .. tostring(self.mode) .. ".png"))

    self.activeSkill_2 = FoodGames.getActiveSkillStr(tostring(self.mode), 2)
    self.Btn_Skill_2:setImage(getTexture("media/ui/Icon_" .. tostring(self.activeSkill_2) .. "_MagKneeToe.png"))

    self.arrowLeft:setImage(getTexture("media/ui/Arrow_Left_" .. tostring(self.mode) .. ".png"))
    self.arrowRight:setImage(getTexture("media/ui/Arrow_Right_" .. tostring(self.mode) .. ".png"))
    
end

--[[ 
function FoodGamesPanel:update()
    local HasTrait = self.player:HasTrait(self.mode)
    
    -- Enable/disable based on trait ownership
    self.Btn_Skill_1:setEnable(HasTrait)
    self.Btn_Skill_2:setEnable(HasTrait)

    -- Show or hide skill 2 depending on mode
    local isBtn2 = self.mode == "MagKneeToe"
    self.Btn_Skill_2:setVisible(isBtn2)

    -- You may also want to visually dim the skill buttons if disabled
    if not traitAllowed then
        self.Btn_Skill_1:setTooltip("Requires " .. self.mode .. " trait")
        self.Btn_Skill_2:setTooltip("Requires " .. self.mode .. " trait")
    else
        self.Btn_Skill_1:setTooltip(nil)
        self.Btn_Skill_2:setTooltip(nil)
    end

    self:update()
end
 ]]
-----------------------            ---------------------------
--[[ 
function FoodGamesPanel:update()
    self.headStr = "Food Game:    ".. tostring(self.mode)

    if self.mode == self._lastButtonMode then return end
    self._lastButtonMode = self.mode
    

    self.activeSkill_1 = FoodGames.isActiveSkill(self.mode, 1)    
    self.Btn_Skill_1:setImage(getTexture("media/ui/Icon_"..tostring(self.activeSkill_1).."_" .. tostring(self.mode) .. ".png"))
    
    self.activeSkill_2 = FoodGames.isActiveSkill(self.mode, 2)    
    self.Btn_Skill_2:setImage(getTexture("media/ui/Icon_"..tostring(self.activeSkill_2).."_MagKneeToe.png"))

   -- self.bgSprite.texture = Texture.getSharedTexture("media/ui/BG_On_" .. self.mode .. ".png")
    self.arrowLeft:setImage(   getTexture("media/ui/Arrow_Left_" .. tostring(self.mode) .. ".png"))
    self.arrowRight:setImage(  getTexture("media/ui/Arrow_Right_" .. tostring(self.mode) .. ".png"))
    if (self.mode == 'MagKneeToe'  and not self.player:HasTrait("MagKneeToe")) or 
    (self.mode == 'Wolferine'   and not self.player:HasTrait("Wolferine")) or
    (self.mode == 'HomeLender'  and not self.player:HasTrait("HomeLender")) then

        self.Btn_Skill_1:setEnable(false)
        self.Btn_Skill_2:setEnable(false)

        self.Btn_Skill_1:setTooltip("Requires " .. self.mode .. " trait")
        self.Btn_Skill_2:setTooltip("Requires " .. self.mode .. " trait")
    end

end
 ]]
function FoodGamesPanel:onSkill(skillNum)
    skillNum = skillNum or 1
    local trait = tostring(self.mode)
    local pl = self.player

    if not FoodGames.isHasEnergy(pl, skillNum) then return end
    if not pl:HasTrait(trait) then return end

    local isActive = FoodGames.isActiveSkill(self.mode, skillNum)
    local newState = not isActive
    
    --FoodGames.isOneShot = false

    FoodGames.setActiveSkill(self.mode, skillNum, newState)
    self:update()
end


  --  self.Btn_Skill_1:setImage( getTexture("media/ui/Icon_On_" .. self.mode .. ".png"))

--[[     print(FoodGames.isActiveSkill(self.mode, 1))
    print(FoodGames.isActiveSkill(self.mode, 2)) ]]

   -- self.EnergySlider.texBtnLeft = self.arrowLeft
   -- self.EnergySlider.texBtnRight = self.arrowRight
    --self.EnergySlider.sliderBarColor = self:getColor()
    --self.EnergySlider.sliderMouseOverColor = { r = 1, g = 1, b = 1, a = 1 }


-----------------------            ---------------------------
function FoodGamesPanel:onArrowLeft()
	if not FoodGames.isHero(self.player) then return end
    self.modeIndex = self.modeIndex - 1
    if self.modeIndex < 1 then self.modeIndex = #self.modes end
    self.mode = self.modes[self.modeIndex]
    self.player:getModData()['FoodGames']['Mode'] = self.mode
    if not self.player:HasTrait(tostring(self.mode)) then 
        return self:onArrowLeft() 
    end
    self:update()
end

function FoodGamesPanel:onArrowRight()
	if not FoodGames.isHero(self.player) then return end
    self.modeIndex = self.modeIndex + 1
    if self.modeIndex > #self.modes then self.modeIndex = 1 end
    self.mode = self.modes[self.modeIndex]
    self.player:getModData()['FoodGames']['Mode'] = self.mode 
    if not self.player:HasTrait(tostring(self.mode)) then 
        return self:onArrowRight() 
    end
    self:update()
end

function FoodGamesPanel:onSkill(skillNum)

    skillNum = skillNum or 1
  
--[[     local sound = (self.mode == mode) and toggleOnSound or toggleOffSound
    getSoundManager():playUISound(sound)
     ]]
    if FoodGames.isHasEnergy(self.player, skillNum)  then
        
        if self.mode == "HomeLender" and self.player:HasTrait("HomeLender") then
            FoodGames.setActiveSkill(self.mode, skillNum, true)   
        elseif self.mode == "Wolferine" and self.player:HasTrait("Wolferine") then
            FoodGames.doHealRandPart(pl)
            --FoodGames.setActiveSkill(self.mode, skillNum, true)   
            --FoodGames.doHealRandPart(self.player)
        elseif self.mode == "MagKneeToe" and self.player:HasTrait("MagKneeToe")  then
            FoodGames.setActiveSkill(self.mode, skillNum, true)   
            --FoodGames.doShotgun(self.player)
        end
    end
    FoodGames.setActiveSkill(mode, skillNum, val)
end

-----------------------            ---------------------------



-----------------------            ---------------------------

function FoodGamesPanel:new(x, y, width, height, player)
    local o = ISCollapsableWindow.new(self, x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.user = player:getUsername()
    if y == 0 then
        o.y = o:getMouseY() - (height / 2)
        o:setY(o.y)
    end
    if x == 0 then
        o.x = o:getMouseX() - (width / 2)
        o:setX(o.x)
    end

    o.drawFrame = true
	o.clearStentil = true;
    

    o.width = 322;
--[[     local txtWidth = getTextManager():MeasureStringX(UIFont.Medium, text) + 10;
    if width < txtWidth then
        o.width = txtWidth;
    end ]]
    o.height = 172;
    o.anchorLeft = true
    o.anchorRight = true
    o.anchorTop = true
    o.anchorBottom = true


    o.borderColor = { r = 0.76, g = 0.59, b = 0.11, a = 1}
    o.backgroundColor = { r = 0.30, g = 0.30, b = 0.30, a =  0.1}--{ r = 0.12, g = 0.39, b = 0.77,  a = 1}
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
    if type(fg.ConsumedCalories) ~= "number" then
        fg.ConsumedCalories = 0
    end
    if FoodGamesPanel.instance == nil then
        local sW = getCore():getScreenWidth()
        local sH = getCore():getScreenHeight()
        local sX = sW / 3 - 100
        local sY = sH / 2 - 350
        local W = 322-- 345 

        local H = 172-- 210 
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
function FoodGamesPanel:prerender()
    ISCollapsableWindow.prerender(self)

    self.data = self.player:getModData()['FoodGames']
    self.mode = self.player:getModData()['FoodGames']['Mode']
   -- self.themeCol = self.themeCol or { r = 1, g = 1, b = 1, a = 1 }
    --self.bgSprite.texture   = Texture.getSharedTexture("media/ui/BG_Off_" .. self.mode .. ".png")
    
    if self.mode == "HomeLender" then      
        self.themeCol =  { r = 0.8, g = 0.3, b = 0.3 }
       
    elseif self.mode == "Wolferine" then
        self.themeCol = { r = 0.76, g = 0.47, b = 0.10 }
    
    elseif self.mode == "MagKneeToe" then
        self.themeCol =  { r = 0.86, g = 0.36, b = 0.89  }
    else
        self.themeCol = self.themeCol or { r = 1, g = 1, b = 1}
    end
    
    self.header = self:drawTextCentre(self.headStr, self:getWidth() / 2 - 43, 12, 1, 1, 1, 1, self.Large);

    
    if self.mode == "MagKneeToe" then
        local metal = tonumber(self.data["StoredMetal"]) or 0
        local max = SandboxVars.FoodGames.MaxMetalCapacity or 46080
        metal = math.max(0, math.min(max, metal))
        self:drawTextCentre("Metal Stored: \n"..tostring(tostring(math.floor(metal))).." / "..tostring(max), self.width/2-86, self.sliderRow+20, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Medium)
        --self:drawTextCentre(tostring(math.floor(metal)), 60, self.sliderRow+5, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Large)
    else
        local calories = tonumber(self.data["ConsumedCalories"]) or 0
        calories = math.max(0, math.min(99999, calories))
        
        local storedFood = FoodGames.convertDaysToYMD(calories)

        self:drawTextCentre("Food Stored: "..tostring(math.floor(calories)).. "\n"..tostring(storedFood), self.width/2-86,  self.sliderRow+20, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Medium)
       -- self:drawTextCentre(tostring(math.floor(calories)), 60, self.sliderRow+5, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Large)
    
        
        
    end
    self.EnergySlider.sliderColor = self:getColor()
    
    self.bgTexture = getTexture("media/ui/BG_Off_" .. self.mode .. ".png")
    if self.bgTexture then
        self:drawTexture(self.bgTexture, 0, 0, 1)
        self:drawTexture(self.bgTexture, 0, 0, 1)
    end

end
-----------------------            ---------------------------
function FoodGamesPanel:render()
    ISCollapsableWindow.render(self)
    
    self:update()
end