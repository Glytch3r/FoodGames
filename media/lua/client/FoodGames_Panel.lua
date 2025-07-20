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

function FoodGamesPanel:titleBarHeight()
    return 24   
end
--[[ 
function FoodGamesPanel:onSliderChange(_newval, _slider)
print('---------')
  print(_newval)
print(_slider)
     print('---------')
    if getCore():getDebug() then
        if self.mode == "MagKneeToe" and self.player:HasTrait("MagKneeToe") then
            self.data['StoredMetal'] = self.EnergySlider:getCurrentValue()       
            print(self.data['StoredMetal'])
        else
            self.data['StoredCalories'] = self.EnergySlider:getCurrentValue()
            print(self.data['StoredCalories'])
        end
    end
     print('---------')

         print(self.EnergySlider:getCurrentValue())
-- self.EnergySlider:setValues(0, max, math.floor(val))
   -- self.EnergySlider:setValues(0, 99999, math.floor(val)) 
end
 ]]

function FoodGamesPanel:createChildren()
    ISCollapsableWindow.createChildren(self)
    self.modes = { "HomeLender", "Wolferine", "MagKneeToe" }
--[[     self.data = self.player:getModData()['FoodGames']
    self.mode = getMode() ]]

    self.data = FoodGames.getData(self.player)
    self.mode = FoodGames.getMode(self.player)

    self.modeNum = { ["HomeLender"]=1,["Wolferine"]=2, ["MagKneeToe"]=3 }
    
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
    self.buttonsRow =  self.margin + (btnSize/2) - 5 --self.height - self:titleBarHeight() - self.margin - btnSize  -5
    self.sliderRow =   self.height /2  - divider + sliderH 
    self.sliderCol =   self.margin
    
    --local buttonsRow = self.height - btnSize - self.margin
    local col1 = self.margin 
    local col2 = self.margin  + gap
    local col3 = divider + col2 + gap
    local col4 = divider + col2 + (gap*2)
    self.arrowLeft = ISButton:new(col1, self.buttonsRow, btnSize, btnSize, "", self, function() self:onArrowLeft() end)
    self.arrowLeft:setImage(getTexture("media/ui/Arrow_Left_" .. self.mode .. ".png"))
    self.arrowLeft:initialise();
    self.arrowLeft:instantiate()
    self.arrowLeft:forceImageSize(27, 33)
    self.arrowLeft.borderColor.a = 0
    self.arrowLeft.displayBackground = false
    self:addChild(self.arrowLeft)
    
    self.arrowRight = ISButton:new(col2, self.buttonsRow, btnSize, btnSize, "", self,function() self:onArrowRight() end)
    self.arrowRight:setImage(getTexture("media/ui/Arrow_Right_" .. self.mode .. ".png"))
    self.arrowRight:initialise();
    self.arrowRight:instantiate()
    self.arrowRight:forceImageSize(27, 33)
    self.arrowRight.borderColor.a = 0
    self.arrowRight.displayBackground = false
    self:addChild(self.arrowRight)


    --local col3 = self.width / 2 - btnSize
    --self.data[tostring(self.mode)][1] or FoodGames.getSkil1(self.mode)
    self.Btn_Skill_1 = ISButton:new( col3, self.buttonsRow, btnSize, btnSize, "", self,function() self:onSkill(1) end)
    self.activeSkill_1 = FoodGames.getActiveSkillStr(self.mode, 1)    
    self.Btn_Skill_1:setImage(getTexture("media/ui/Icon_"..self.activeSkill_1.."_" .. self.mode .. ".png"))
    self.Btn_Skill_1:forceImageSize(32, 32)
    self.Btn_Skill_1.borderColor.a = 0
    self.Btn_Skill_1:initialise()
    self.Btn_Skill_1.displayBackground = false
    self:addChild(self.Btn_Skill_1)

    --self.activeSkill_1 = self.data[tostring(self.mode)][2] or  FoodGames.getSkil2(self.mode)
    -- self.activeSkill_2 = FoodGames.getSkil2(self.mode)
    self.Btn_Skill_2 = ISButton:new(col4, self.buttonsRow, btnSize, btnSize, "", self,function() self:onSkill(2) end)
    self.activeSkill_2 = FoodGames.getActiveSkillStr(self.mode, 2)    
    self.Btn_Skill_2:setImage(getTexture("media/ui/Icon_"..self.activeSkill_2.."_MagKneeToe.png"))
    self.Btn_Skill_2:forceImageSize(32, 32)
    self.Btn_Skill_2.borderColor.a = 0
    self.Btn_Skill_2:initialise()
    self.Btn_Skill_2.displayBackground = false
    self:addChild(self.Btn_Skill_2)


    self.EnergySlider = ISSliderPanel:new(self.sliderCol, self.sliderRow, sliderW, sliderH, self, self.onSliderChange)
    self.EnergySlider:initialise()
    self.EnergySlider:instantiate()
    --self.EnergySlider:setValues(0.0, 999, 1, 1, true)
    self.EnergySlider:setHeight(sliderH)
    self:addChild(self.EnergySlider)
    

   -- self.EnergySlider.sliderColor = self:getColor()

--[[     self.EnergySlider.texBtn_Left = self.ArrowLeft
    self.EnergySlider.texBtn_Right = self.ArrowRight
 ]]
    self:updateSliderValue()
    --self:update()
    


end
-----------------------            ---------------------------
function FoodGamesPanel:onSliderChange(val, _slider)

    if getCore():getDebug() then
        if self.mode == "MagKneeToe" and self.player:HasTrait("MagKneeToe") then
            self.data['StoredMetal'] = val
            print(tostring(self.data['StoredMetal']))
        else
            self.data['StoredCalories'] = val
            print(tostring(self.data['StoredCalories']))
        end
    end
    
--[[     self.EnergySlider:setValues(0, max, math.floor(val))
    self.EnergySlider:setValues(0, 99999, math.floor(val)) ]]
end


function FoodGamesPanel:updateSliderValue()
--[[ 
    self.data = self.player:getModData()['FoodGames']
    local max = 0
    local charge = 0
    if self.mode == "MagKneeToe" and self.player:HasTrait("MagKneeToe") then
        max = SandboxVars.FoodGames.MaxMetalCapacity or 46080
        charge = self.data["StoredMetal"]

    else
        max = SandboxVars.FoodGames.DailyCalories or 99999
        charge = self.data["StoredCalories"]       
    end
    self.EnergySlider:setCurrentValue(math.min(max, math.max(0, tonumber(charge))))
 ]]
    self.EnergySlider.sliderColor = self:getColor()

    --self:update()
end
--[[ 
function FoodGamesPanel:update()
    local hasTrait = self.player:HasTrait(tostring(self.mode))
    if self.mode == self._lastButtonMode then return end
    self._lastButtonMode = self.mode

    self.Btn_Skill_1:setEnable(hasTrait)
    self.Btn_Skill_2:setEnable(hasTrait)
   

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

    if self.mode == "MagKneeToe" and self.player:HasTrait("MagKneeToe") then
        self.activeSkill_2 = FoodGames.getActiveSkillStr("MagKneeToe", 2)
        self.Btn_Skill_2:setImage(getTexture("media/ui/Icon_" .. tostring(self.activeSkill_2) .. "_MagKneeToe.png"))
    end

    self.arrowLeft:setImage(getTexture("media/ui/Arrow_Left_" .. tostring(self.mode) .. ".png"))
    self.arrowRight:setImage(getTexture("media/ui/Arrow_Right_" .. tostring(self.mode) .. ".png"))

    local isEnabled_1 = hasTrait and not FoodGames.isActiveSkill(self.mode, 1) and FoodGames.isHasEnergy(self.player, 1)
    local isEnabled_2 = hasTrait and self.mode == "MagKneeToe" and not FoodGames.isActiveSkill("MagKneeToe", 2) and FoodGames.isHasEnergy(self.player, 2)

    self.Btn_Skill_1:setEnable(isEnabled_1)
    self.Btn_Skill_1:setVisible(isEnabled_1)

    self.Btn_Skill_2:setEnable(isEnabled_2)
    self.Btn_Skill_2:setVisible(isEnabled_2)
end

 ]]
function FoodGamesPanel:update()
    local hasTrait = self.player:HasTrait(tostring(self.mode))
    self._lastButtonMode = self.mode

    -- Button 1: Always available
    local isEnabled_1 = FoodGames.isHasEnergy(self.player, 1)
    self.Btn_Skill_1:setEnable(isEnabled_1)
    self.Btn_Skill_1:setVisible(true)

    -- Tooltip only shown if trait is missing
    if not hasTrait then
        local tip = "Requires " .. tostring(self.mode) .. " trait"
        self.Btn_Skill_1:setTooltip(tip)
    else
        self.Btn_Skill_1:setTooltip(nil)
    end

    -- Refresh image
    self.activeSkill_1 = FoodGames.getActiveSkillStr(tostring(self.mode), 1)   
    self.Btn_Skill_1:setImage(getTexture("media/ui/Icon_" .. tostring(self.activeSkill_1) .. "_" .. tostring(self.mode) .. ".png"))

    -- Button 2: Only visible/enabled if MagKneeToe and has energy
    local isMag = self.mode == "MagKneeToe"
    local isEnabled_2 = isMag and FoodGames.isHasEnergy(self.player, 2)

    self.Btn_Skill_2:setVisible(isMag)
    self.Btn_Skill_2:setEnable(isEnabled_2)

    if isMag then
        self.activeSkill_2 = FoodGames.getActiveSkillStr("MagKneeToe", 2)
        self.Btn_Skill_2:setImage(getTexture("media/ui/Icon_" .. tostring(self.activeSkill_2) .. "_MagKneeToe.png"))
        self.Btn_Skill_2:setTooltip(nil)
    else
        self.Btn_Skill_2:setTooltip("Only available for MagKneeToe")
    end

    -- Update arrows
    self.arrowLeft:setImage(getTexture("media/ui/Arrow_Left_" .. tostring(self.mode) .. ".png"))
    self.arrowRight:setImage(getTexture("media/ui/Arrow_Right_" .. tostring(self.mode) .. ".png"))

    -- Update header
    self.headStr = "Food Game:    " .. tostring(self.mode)
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


-----------------------            ---------------------------

function FoodGamesPanel:onSkill(skillNum)
    skillNum = skillNum or 1
    local trait = tostring(self.mode)
    local pl = self.player

    if not FoodGames.isHasEnergy(pl, skillNum) then return end
    if not pl:HasTrait(trait) then return end

    local isActive = FoodGames.isActiveSkill(self.mode, skillNum)
    local newState = not isActive
    FoodGames.setActiveSkill(self.mode, skillNum, newState)
end

-----------------------            ---------------------------

function FoodGamesPanel:new(x, y, width, height, player)
    local o = ISCollapsableWindow.new(self, x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.user = player:getUsername()
--[[     if y == 0 then
        o.y = o:getMouseY() - (height / 2)
        o:setY(o.y)
    end
    if x == 0 then
        o.x = o:getMouseX() - (width / 2)
        o:setX(o.x)
    end ]]

    o.drawFrame = true
	o.clearStentil = true;
    

    --o.width = 322;
    --o.height = 172;
--[[     local txtWidth = getTextManager():MeasureStringX(UIFont.Medium, text) + 10;
    if width < txtWidth then
        o.width = txtWidth;
    end ]]
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

-----------------------            ---------------------------
function FoodGamesPanel:prerender()
    ISCollapsableWindow.prerender(self)
    --backgroundColorMouseOver
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
    
    if self.mode == "MagKneeToe" then
        local metal = tonumber(self.data["StoredMetal"]) or 0
        local max = SandboxVars.FoodGames.MaxMetalCapacity or 46080
        self.EnergySlider.maxValue = max
        metal = math.max(0, math.min(max, metal))
        self:drawText("Metal Stored: \n"..tostring(tostring(math.floor(metal))).." / "..tostring(max), self.margin+4, self.sliderRow+self.margin+5, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Large)
        --self:drawTextCentre(tostring(math.floor(metal)), 60, self.sliderRow+5, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Large)
    else     
        local calories = tonumber(self.data["StoredCalories"]) or 0
        local max =SandboxVars.FoodGames.DailyCalories or 99999
        self.EnergySlider.maxValue = max
        calories = math.max(0, math.min(max, calories))        
        local storedFood = FoodGames.convertDaysToYMD(calories)
        self:drawText("Food Stored: "..tostring(math.floor(calories)).. "\n"..tostring(storedFood), self.margin+4,  self.sliderRow+self.margin+5, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Large)
       -- self:drawTextCentre(tostring(math.floor(calories)), 60, self.sliderRow+5, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Large)
    end
    
    self.EnergySlider.sliderColor = self:getColor()
    self.isSkillActiveStr = FoodGames.getActiveSkillStr(tostring(self.mode), 1) or (self.mode == "MagKneeToe" and FoodGames.getActiveSkillStr(tostring(self.mode), 2))
    self.bgTexture = getTexture("media/ui/BG_"..tostring(self.isSkillActiveStr).."_" .. self.mode .. ".png")
    if self.bgTexture then
        self.bgX = (self.width / 2) - (self.bgTexture:getWidth() / 2)
        self.bgY = self:titleBarHeight() + 4 -- (self.width / 2) - (self.bgTexture:getHeight() / 2)
        self:drawTexture(self.bgTexture, self.bgX, self.bgY, 1)
        self:drawTexture(self.bgTexture, self.bgX, self.bgY, 1)
    end
    self:update()
    self.header = self:drawTextCentre(self.headStr, self.width/2, 4, 1, 1, 1, 1, UIFont.Medium);
end
