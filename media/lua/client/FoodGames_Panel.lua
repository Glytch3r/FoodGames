
FoodGames = FoodGames or {}

require "ISUI/ISCollapsableWindow"

FoodGamesPanel = ISCollapsableWindow:derive("FoodGamesPanel")
FoodGames.modeList = {
    ["HomeLender"] = true,
    ["Wolferine"] = true,
    ["MagKneeToe"] = true,
}
FoodGames.modesStr = {
    "HomeLender",
    "Wolferine",
    "MagKneeToe",
}


FoodGames.modeConfig = {
    HomeLender = {
        last = "HomeLender",
        icons = {
            HomeLender = "HomeLenderIcon_On",
            Wolferine = "WolferineIcon_Off",
            MagKneeToe = "MagKneeToeIcon_Off",
        },
        bg = "HomeLenderBG_1",
        left = "HomeLender_ArrowLeft",
        right = "HomeLender_ArrowRight",
        color = "HomeLender",
    },
    Wolferine = {
        last = "Wolferine",
        icons = {
            HomeLender = "HomeLenderIcon_Off",
            Wolferine = "WolferineIcon_On",
            MagKneeToe = "MagKneeToeIcon_Off",
        },
        bg = "WolferineBG_1",
        left = "Wolferine_ArrowLeft",
        right = "Wolferine_ArrowRight",
        color = "Wolferine",
    },
    MagKneeToe = {
        last = "MagKneeToe",
        icons = {
            HomeLender = "MagKneeToeIcon_Off",
            Wolferine = "MagKneeToeIcon_Off",
            MagKneeToe = "MagKneeToeIcon_On",
        },
        bg = "MagKneeToeBG_1",
        left = "MagKneeToe_ArrowLeft",
        right = "MagKneeToe_ArrowRight",
        color = "MagKneeToe",
    },
}
function FoodGames.toggle()
    if FoodGamesPanel.instance ~= nil then
        FoodGamesPanel:close()
    else
        FoodGames.open()
    end
end

function FoodGames.open()
    local modData = getPlayer():getModData()
    modData['FoodGames'] = modData['FoodGames'] or {}
    modData['FoodGames']['ConsumedCalories'] = modData['FoodGames']['ConsumedCalories'] or 0
    modData['FoodGames']['Mode'] = modData['FoodGames']['Mode'] or false
    modData['FoodGames']['Mode'] = modData['FoodGames']['Mode'] or "off"


    if FoodGamesPanel.instance == nil then
        local sW = getCore():getScreenWidth()
        local sH = getCore():getScreenHeight()
        local sX = sW / 3 - 100
        local sY = sH / 2 - 350
        local W = 345
        local H = 210

        FoodGamesPanel.instance = FoodGamesPanel:new(sX, sY, W, H, getPlayer())
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



    o.width = width;
    local txtWidth = getTextManager():MeasureStringX(UIFont.Medium, text) + 10;
    if width < txtWidth then
        o.width = txtWidth;
    end
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = true;
    o.anchorTop = true;
    o.anchorBottom = true;
    player:getModData()['FoodGames']['ConsumedCalories'] =  player:getModData()['FoodGames']['ConsumedCalories'] or 0
    o.calData =  player:getModData()['FoodGames']['ConsumedCalories']
    player:getModData()['FoodGames']['StoredMetal'] =  player:getModData()['FoodGames']['StoredMetal'] or 0
    o.metalData = player:getModData()['FoodGames']['StoredMetal']

    o.consume = SandboxVars.FoodGames.CalConsume or 500
    o.variableColor = {r = 1, g = 0.55, b = 1, a = 1}
    --o.borderColor = {r = 0, g = 0, b = 0.6, a = 1}
    o.borderColor = { r = 0.76, g = 0.59, b = 0.11, a = 1}
    o.backgroundColor = { r = 0.30, g = 0.30, b = 0.30, a =  0.1}--{ r = 0.12, g = 0.39, b = 0.77,  a = 1}
    o.buttonBorderColor = {r = 0.7, g = 0.7, b = 0.7, a = 1}
    o:setResizable(true)
    o.resizable = true
    o.moveWithMouse = true

    o.HomeLender_Color  = {r = 1, g = 0, b = 0}
    o.Wolferine_Color   = {r = 1, g = 1, b = 0}
    o.MagKneeToe_Color  = { r = 0.60, g = 0.20, b = 0.70 }
    o.HomeLenderIcon_Off =  getTexture("media/ui/HomeLenderIcon_Off.png")
    o.WolferineIcon_Off =  getTexture("media/ui/WolferineIcon_Off.png")
    o.MagKneeToeIcon_Off =  getTexture("media/ui/MagKneeToeIcon_Off.png")
    o.HomeLenderIcon_On =  getTexture("media/ui/HomeLenderIcon_On.png")
    o.WolferineIcon_On =  getTexture("media/ui/WolferineIcon_On.png")
    o.MagKneeToeIcon_On =  getTexture("media/ui/MagKneeToeIcon_On.png")


    --o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
    return o
end
-----------------------            ---------------------------
--[[ function FoodGamesPanel:update()
    ISCollapsableWindow.update(self)
end ]]

function FoodGamesPanel:update()
    ISCollapsableWindow.update(self)

    local mode = self.player:getModData().FoodGames.Mode or "off"
    if mode == self._lastButtonMode then return end
    self._lastButtonMode = mode

    local baseX, baseY = 24, 30
    local w, h = 32, 32
    local c2OffsetX = 36

    self.btn_HL:setVisible(false)
    self.btn_WF:setVisible(false)
    self.btn_MK1:setVisible(false)
    self.btn_MK2:setVisible(false)

    if mode == "HomeLender" then
        self.btn_HL:setX(baseX); self.btn_HL:setY(baseY)
        self.btn_HL:setVisible(true)

    elseif mode == "Wolferine" then
        self.btn_WF:setX(baseX); self.btn_WF:setY(baseY)
        self.btn_WF:setVisible(true)

    elseif mode == "MagKneeToe" then
        self.btn_MK1:setX(baseX); self.btn_MK1:setY(baseY)
        self.btn_MK2:setX(baseX + c2OffsetX); self.btn_MK2:setY(baseY)
        self.btn_MK1:setVisible(true)
        self.btn_MK2:setVisible(true)
    end
end


function FoodGamesPanel:render()
    ISCollapsableWindow.render(self)
end

function FoodGamesPanel:initialise()
    ISCollapsableWindow.initialise(self)
    self:createChildren()
end

-----------------------            ---------------------------
function FoodGamesPanel:close()
    if FoodGamesPanel.instance ~= nil then
        FoodGamesPanel.instance:setVisible(false)
        FoodGamesPanel.instance:removeFromUIManager()
        FoodGamesPanel.instance = nil
    end
end

-----------------------        press*         ---------------------------

function FoodGamesPanel:OnCyclePress(isLeft)
    local modeOrder = {  "HomeLender", "Wolferine", "MagKneeToe" }
    local fgData = self.player:getModData()['FoodGames']
    local cur = self.previewMode or fgData['Mode']

    local index = 1
    for i, v in ipairs(modeOrder) do
        if v == cur then index = i break end
    end

    local nextIndex = isLeft and (index - 1) or (index + 1)
    if nextIndex < 1 then nextIndex = #modeOrder end
    if nextIndex > #modeOrder then nextIndex = 1 end

    self.previewMode = modeOrder[nextIndex]
    getSoundManager():playUISound("UIActivateMainMenuItem")
    self:clearIcons()
end
-----------------------       press*     ---------------------------
function FoodGamesPanel:OnBtnPress(btn, key, mode, toggleOnSound, toggleOffSound)
    local modData = self.player:getModData()
    local fgData = modData['FoodGames']

    if fgData['Mode'] == mode then
        fgData['Mode'] = 'off'
    else
        fgData['Mode'] = mode
    end

    btn.internal = key
    print("Mode: ", fgData['Mode'])

    local sound = (fgData['Mode'] == mode) and toggleOnSound or toggleOffSound
    getSoundManager():playUISound(sound)

    if fgData['Mode'] == "Wolferine" then
    end


    if fgData['Mode'] == "HomeLender" then
        self.CalSlider.sliderBarColor = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 }
    elseif fgData['Mode'] == "Wolferine" then

        FoodGames.doHealRandPart(self.player)

        self.CalSlider.sliderBarColor = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }
    elseif fgData['Mode'] == "MagKneeToe" then
        self.CalSlider.sliderBarColor = { r = 0.6, g = 0.2, b = 0.7, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 0.8, g = 0.4, b = 1.0, a = 1.0 }
    else
        self.CalSlider.sliderBarColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
    end






end

-----------------------            ---------------------------

-----------------------  slider***          ---------------------------

function FoodGamesPanel:OnSliderChange()
    self.CalSlider.sliderColor = self.borderColor

--[[     self.Wolferine_Color   = {r = 1, g = 1, b = 0}
    self.MagKneeToe_Color  = {r = 0.42, g = 0.13, b = 0.24} ]]

    if getCore():getDebug() then
        self.player:getModData()['FoodGames']['ConsumedCalories']  =  self.CalSlider:getCurrentValue()
    end

end
function FoodGamesPanel:OnSliderChange2()
    self.MetalSlider.sliderColor = self.borderColor
    if getCore():getDebug() then
        self.player:getModData()['FoodGames']['StoredMetal']  =  self.MetalSlider:getCurrentValue()
    end
end
-----------------------            ---------------------------
function FoodGamesPanel:updateIcons()
    self:clearIcons()
    local mode = self.player:getModData().FoodGames.Mode or "off"
    if mode == "HomeLender" then
        self.icon_HomeLender:setImage(self.HomeLenderIcon_On)
        self.icon_HomeLender:setVisible(true)
        self.CalSlider.sliderBarColor = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 }
    elseif mode == "Wolferine" then
        self.icon_Wolferine:setImage(self.WolferineIcon_On)
        self.icon_Wolferine:setVisible(true)
        self.CalSlider.sliderBarColor = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }
    elseif mode == "MagKneeToe" then
        if self.icon_MagKneeToe1 then
            self.icon_MagKneeToe1:setImage(self.MagKneeToeIcon_On)
            self.icon_MagKneeToe1:setVisible(true)
            self.CalSlider.sliderBarColor = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }
            self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }
        end
        if self.icon_MagKneeToe2 then
            self.icon_MagKneeToe2:setImage(self.MagKneeToeIcon_On)
            self.icon_MagKneeToe2:setVisible(true)
            self.CalSlider.sliderBarColor = { r = 0.6, g = 0.2, b = 0.7, a = 1.0 }
            self.CalSlider.sliderMouseOverColor = { r = 0.8, g = 0.4, b = 1.0, a = 1.0 }
        end
    else
        self.CalSlider.sliderBarColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
    end
end

function FoodGamesPanel:clearIcons()
    if self.icon_HomeLender then
        self.icon_HomeLender:setImage(self.HomeLenderIcon_Off)
        self.icon_HomeLender:setVisible(false)
    end
    if self.icon_Wolferine then
        self.icon_Wolferine:setImage(self.WolferineIcon_Off)
        self.icon_Wolferine:setVisible(false)
    end
    if self.icon_MagKneeToe1 then
        self.icon_MagKneeToe1:setImage(self.MagKneeToeIcon_Off)
        self.icon_MagKneeToe1:setVisible(false)
    end
    if self.icon_MagKneeToe2 then
        self.icon_MagKneeToe2:setImage(self.MagKneeToeIcon_Off)
        self.icon_MagKneeToe2:setVisible(false)
    end
end

-----------------------            ---------------------------
function FoodGamesPanel:prerender()
    ISCollapsableWindow.prerender(self)

    local modData = self.player:getModData()
    local foodGames = modData and modData["FoodGames"]
    if not foodGames then return end

    local calories = tonumber(foodGames["ConsumedCalories"]) or 0
    calories = math.max(0, math.min(99999, calories))

    local metal = tonumber(foodGames["StoredMetal"]) or 0
    metal = math.max(0, math.min(99999, metal))



    local mode = foodGames["Mode"] or "off"
    local preview = self.previewMode or mode
    local cfg = FoodGames.modeConfig[preview]


    self:clearIcons()
    self.themeCol = { r = 1, g = 1, b = 1 }

    if cfg then
        self.lastMode = cfg.last
        self.themeCol = self[cfg.color .. "_Color"] or self.themeCol

        if mode == preview then
            self.bgTexture = self[cfg.bg] or nil
        else
            self.bgTexture = self[cfg.last .. "BG_0"] or nil
        end

        self.CalSlider.texBtnLeft  = self[cfg.left] or self.Off_ArrowLeft
        self.CalSlider.texBtnRight = self[cfg.right] or self.Off_ArrowRight
    else
        self.bgTexture = self[self.lastMode and (self.lastMode .. "BG_0")] or nil
    end





    if self.bgTexture then
        self:drawTexture(self.bgTexture, 12, 20, 1)
    end

    self.borderColor = {
        r = self.themeCol.r, g = self.themeCol.g,
        b = self.themeCol.b, a = 1
    }


    local storedFood = FoodGames.convertDaysToYMD(calories)
    self:drawTextCentre(tostring(storedFood), self:getWidth() / 2, 70, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Medium)
    self:drawTextCentre(tostring(math.floor(calories)), 64, 105, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Medium)
    self:drawTextCentre(tostring(math.floor(metal)), 64, 140, self.MagKneeToe_Color.r, self.MagKneeToe_Color.g, self.MagKneeToe_Color.b, 1, UIFont.Medium)

    self:updateIcons()

end

-----------------------            ---------------------------
function FoodGamesPanel:createChildren()
    ISCollapsableWindow.createChildren(self)
    self:setTitle("Food Game")

    for _, mode in ipairs(FoodGames.modesStr) do
        for state = 0, 1 do
            self[mode .. "BG_" .. state] = getTexture(string.format("media/ui/%sPanel_%d.png", mode, state))
            self[mode .. "Icon_" .. state] = getTexture(string.format("media/ui/%sIcon_%s.png", mode, state == 0 and "Off" or "On"))
        end
        self[mode .. "_ArrowLeft"]  = getTexture(string.format("media/ui/%s_ArrowLeft.png", mode))
        self[mode .. "_ArrowRight"] = getTexture(string.format("media/ui/%s_ArrowRight.png", mode))
    end

    self.Off_ArrowLeft  = getTexture("media/ui/Off_ArrowLeft.png")
    self.Off_ArrowRight = getTexture("media/ui/Off_ArrowRight.png")

    local modData = self.player:getModData().FoodGames or {}
    local ConsumedCalories = modData['ConsumedCalories'] or 0
    local StoredMetal = modData['StoredMetal'] or 0

    self.btn_HL = ISButton:new(32, 32, 32, 32, "", self, function(button)
        self:OnBtnPress(button, "Mode_H", "HomeLender", "HomeLander_ToggleOn", "HomeLander_ToggleOff")
    end)
    self.btn_HL.internal = "Icon_HomeLender"
    self.btn_HL:setImage(self["HomeLenderIcon_Off"])
    self.btn_HL:forceImageSize(32, 32)
    self.btn_HL:initialise(); self.btn_HL:instantiate()
    self.btn_HL.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.btn_HL.displayBackground = false
    self:addChild(self.btn_HL)
    self.icon_HomeLender = self.btn_HL
    self.btn_HL:setVisible(false)

    self.btn_WF = ISButton:new(32, 32, 32, 32, "", self, function(button)
        self:OnBtnPress(button, "Mode_W", "Wolferine", "Wolferine_ToggleOn", "Wolferine_ToggleOff")
    end)
    self.btn_WF.internal = "Icon_Wolferine"
    self.btn_WF:setImage(self["WolferineIcon_Off"])
    self.btn_WF:forceImageSize(32, 32)
    self.btn_WF:initialise(); self.btn_WF:instantiate()
    self.btn_WF.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.btn_WF.displayBackground = false
    self:addChild(self.btn_WF)
    self.icon_Wolferine = self.btn_WF
    self.btn_WF:setVisible(false)

    self.btn_MK1 = ISButton:new(32, 32, 32, 32, "", self, function(button)
        self:OnBtnPress(button, "Skill1", "MagKneeToe", "MagKneeToe_ToggleOn", "MagKneeToe_ToggleOff")
    end)
    self.btn_MK1.internal = "Icon_MagKneeToe_1"
    self.btn_MK1:setImage(self["MagKneeToeIcon_Off"])
    self.btn_MK1:forceImageSize(32, 32)
    self.btn_MK1:initialise(); self.btn_MK1:instantiate()
    self.btn_MK1.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.btn_MK1.displayBackground = false
    self:addChild(self.btn_MK1)
    self.icon_MagKneeToe1 = self.btn_MK1
    self.btn_MK1:setVisible(false)

    self.btn_MK2 = ISButton:new(64, 32, 32, 32, "", self, function(button)
        self:OnBtnPress(button, "Skill2", "MagKneeToe", "MagKneeToe_ToggleOn", "MagKneeToe_ToggleOff")
    end)
    self.btn_MK2.internal = "Icon_MagKneeToe_2"
    self.btn_MK2:setImage(self["MagKneeToeIcon_Off"])
    self.btn_MK2:forceImageSize(32, 32)
    self.btn_MK2:initialise(); self.btn_MK2:instantiate()
    self.btn_MK2.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.btn_MK2.displayBackground = false
    self:addChild(self.btn_MK2)
    self.icon_MagKneeToe2 = self.btn_MK2
    self.btn_MK2:setVisible(false)

    local baseX = 24
    local baseY = 30
    local arrowLeftX = baseX + (3 * 42) + 4
    local arrowRightX = baseX + (4 * 42)

    local btnLeft = ISButton:new(arrowLeftX, baseY, 32, 32, "", self, function() self:OnCyclePress(true) end)
    btnLeft:setImage(self.Off_ArrowLeft)
    btnLeft:forceImageSize(32, 32)
    btnLeft:initialise(); btnLeft:instantiate()
    btnLeft.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    btnLeft.displayBackground = false
    self:addChild(btnLeft)
    self.btn_ModeCycleLeft = btnLeft

    local btnRight = ISButton:new(arrowRightX, baseY, 32, 32, "", self, function() self:OnCyclePress(false) end)
    btnRight:setImage(self.Off_ArrowRight)
    btnRight:forceImageSize(32, 32)
    btnRight:initialise(); btnRight:instantiate()
    btnRight.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    btnRight.displayBackground = false
    self:addChild(btnRight)
    self.btn_ModeCycleRight = btnRight




    local sliderW = 186
    local sliderH = 32
    local sliderX = ((self.width - sliderW) / 2) + 42
    local sliderY1 = baseY + 60
    local sliderY2 = sliderY1 + sliderH + 12

    self.CalSlider = ISSliderPanel:new(sliderX, sliderY1, sliderW, sliderH, self, self.OnSliderChange)
    self.CalSlider:initialise(); self.CalSlider:instantiate()
    self.CalSlider:setValues(0.0, 99999, 0.1, 1, true)
    self.CalSlider:setHeight(sliderH)
    self.CalSlider:setCurrentValue(ConsumedCalories)
    self:addChild(self.CalSlider)
    self.CalSlider.texBtnLeft = self.Off_ArrowLeft
    self.CalSlider.texBtnRight = self.Off_ArrowRight
    self.CalSlider.sliderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.CalSlider.sliderBarColor = { r = 1.0, g = 0, b = 0, a = 1.0 }
    self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 0, b = 0, a = 1.0 }

    self.MetalSlider = ISSliderPanel:new(sliderX, sliderY2, sliderW, sliderH, self, self.OnSliderChange2)
    self.MetalSlider:initialise(); self.MetalSlider:instantiate()
    self.MetalSlider:setValues(0.0, 999, 1, 1, true)
    self.MetalSlider:setHeight(sliderH)
    self.MetalSlider:setCurrentValue(StoredMetal)
    self:addChild(self.MetalSlider)
    self.MetalSlider.texBtnLeft = self.MagKneeToe_ArrowLeft
    self.MetalSlider.texBtnRight = self.MagKneeToe_ArrowRight
    self.MetalSlider.sliderColor = { r = 0.6, g = 0.2, b = 0.7, a = 1.0 }
    self.MetalSlider.sliderBarColor = { r = 0.6, g = 0.2, b = 0.7, a = 1.0 }
    self.MetalSlider.sliderMouseOverColor = { r = 0.8, g = 0.4, b = 1.0, a = 1.0 }
end




-----------------------            ---------------------------
--[[
function FoodGamesPanel:createChildren()
    ISCollapsableWindow.createChildren(self)

    self:setTitle("Food Game")


    for _, mode in ipairs(FoodGames.modesStr) do
        for state = 0, 1 do
            self[mode .. "BG_" .. state] = getTexture(string.format("media/ui/%sPanel_%d.png", mode, state))
            self[mode .. "Icon_" .. state] = getTexture(string.format("media/ui/%sIcon_%s.png", mode, state == 0 and "Off" or "On"))
        end
        self[mode .. "_ArrowLeft"]  = getTexture(string.format("media/ui/%s_ArrowLeft.png", mode))
        self[mode .. "_ArrowRight"] = getTexture(string.format("media/ui/%s_ArrowRight.png", mode))
    end

    self.Off_ArrowLeft  = getTexture("media/ui/Off_ArrowLeft.png")
    self.Off_ArrowRight = getTexture("media/ui/Off_ArrowRight.png")

    self.Mode = self.player:getModData().FoodGames and self.player:getModData().FoodGames.Mode or "off"
    self.bgTexture = self[self.Mode .. "BG_0"] or self.HomeLenderBG_0

    local data = self.player:getModData().FoodGames
    local ConsumedCalories = data and data['ConsumedCalories'] or 0
    local StoredMetal = data and data['StoredMetal'] or 0

    local btnStartX = 24
    local btnSpacingX = 42
    local btnY = 30
    local i = 0

    self.btn_HL = ISButton:new(btnStartX + (i * btnSpacingX), btnY, 32, 32, "", self, function(button)
        self:OnBtnPress(button, "Mode_H", "HomeLender", "HomeLander_ToggleOn", "HomeLander_ToggleOff")
    end)
    self.btn_HL.internal = "Icon_HomeLender"
    self.btn_HL:setImage(self["HomeLenderIcon_Off"])
    self.btn_HL:forceImageSize(32, 32)
    self.btn_HL:initialise(); self.btn_HL:instantiate()
    self.btn_HL.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.btn_HL.displayBackground = false
    self:addChild(self.btn_HL)
    self.icon_HomeLender = self.btn_HL
    i = i + 1

    self.btn_WF = ISButton:new(btnStartX + (i * btnSpacingX), btnY, 32, 32, "", self, function(button)
        self:OnBtnPress(button, "Mode_W", "Wolferine", "Wolferine_ToggleOn", "Wolferine_ToggleOff")
    end)
    self.btn_WF.internal = "Icon_Wolferine"
    self.btn_WF:setImage(self["WolferineIcon_Off"])
    self.btn_WF:forceImageSize(32, 32)
    self.btn_WF:initialise(); self.btn_WF:instantiate()
    self.btn_WF.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.btn_WF.displayBackground = false
    self:addChild(self.btn_WF)
    self.icon_Wolferine = self.btn_WF
    i = i + 1

    self.btn_MK1 = ISButton:new(btnStartX + (i * btnSpacingX), btnY, 32, 32, "", self,
        function(button)
            self:OnBtnPress(button, "Skill1", "MagKneeToe", "MagKneeToe_ToggleOn", "MagKneeToe_ToggleOff")
        end)
    self.btn_MK1.internal = "Icon_MagKneeToe_1"
    self.btn_MK1:setImage(self["MagKneeToeIcon_Off"])
    self.btn_MK1:forceImageSize(32, 32)
    self.btn_MK1:initialise(); self.btn_MK1:instantiate()
    self.btn_MK1.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.btn_MK1.displayBackground = false
    self:addChild(self.btn_MK1)
    self.icon_MagKneeToe1 = self.btn_MK1
    i = i + 1

    self.btn_MK2 = ISButton:new(btnStartX + (i * btnSpacingX), btnY, 32, 32, "", self,
        function(button)
            self:OnBtnPress(button, "Skill2", "MagKneeToe", "MagKneeToe_ToggleOn", "MagKneeToe_ToggleOff")
        end)
    self.btn_MK2.internal = "Icon_MagKneeToe_2"
    self.btn_MK2:setImage(self["MagKneeToeIcon_Off"])
    self.btn_MK2:forceImageSize(32, 32)
    self.btn_MK2:initialise(); self.btn_MK2:instantiate()
    self.btn_MK2.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.btn_MK2.displayBackground = false
    self:addChild(self.btn_MK2)
    self.icon_MagKneeToe2 = self.btn_MK2
    i = i + 1

    local arrowLeftX = btnStartX + (i * btnSpacingX) + 4
    local btnLeft = ISButton:new(arrowLeftX, btnY, 32, 32, "", self, function() self:OnCyclePress(true) end)
    btnLeft:setImage(self.Off_ArrowLeft)
    btnLeft:forceImageSize(32, 32)
    btnLeft:initialise(); btnLeft:instantiate()
    btnLeft.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    btnLeft.displayBackground = false
    self:addChild(btnLeft)
    self.btn_ModeCycleLeft = btnLeft

    local arrowRightX = btnStartX + ((i + 1) * btnSpacingX)
    local btnRight = ISButton:new(arrowRightX, btnY, 32, 32, "", self, function() self:OnCyclePress(false) end)
    btnRight:setImage(self.Off_ArrowRight)
    btnRight:forceImageSize(32, 32)
    btnRight:initialise(); btnRight:instantiate()
    btnRight.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    btnRight.displayBackground = false
    self:addChild(btnRight)
    self.btn_ModeCycleRight = btnRight

    local sliderW = 186
    local sliderH = 32
    local sliderX = ((self.width - sliderW) / 2) + 42
    local sliderY1 = btnY + 60
    local sliderY2 = sliderY1 + sliderH + 12

    self.CalSlider = ISSliderPanel:new(sliderX, sliderY1, sliderW, sliderH, self, self.OnSliderChange)
    self.CalSlider:initialise(); self.CalSlider:instantiate()
    self.CalSlider:setValues(0.0, 99999, 0.1, 1, true)
    self.CalSlider:setHeight(sliderH)
    self.CalSlider:setCurrentValue(ConsumedCalories)
    self:addChild(self.CalSlider)
    self.CalSlider.texBtnLeft = self.Off_ArrowLeft
    self.CalSlider.texBtnRight = self.Off_ArrowRight
    self.CalSlider.sliderColor =  { r = 0, g = 0, b = 0, a = 0 }
    self.CalSlider.sliderBarColor = { r = 1.0, g = 0, b = 0, a = 1.0 }
    self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 0, b = 0, a = 1.0 }

    self.MetalSlider = ISSliderPanel:new(sliderX, sliderY2, sliderW, sliderH, self, self.OnSliderChange2)
    self.MetalSlider:initialise(); self.MetalSlider:instantiate()
    self.MetalSlider:setValues(0.0, 999, 1, 1, true)
    self.MetalSlider:setHeight(sliderH)
    self.MetalSlider:setCurrentValue(StoredMetal)
    self:addChild(self.MetalSlider)
    self.MetalSlider.texBtnLeft = self.MagKneeToe_ArrowLeft
    self.MetalSlider.texBtnRight = self.MagKneeToe_ArrowRight
    self.MetalSlider.sliderColor = { r = 0.6, g = 0.2, b = 0.7, a = 1.0 }
    self.MetalSlider.sliderBarColor = { r = 0.6, g = 0.2, b = 0.7, a = 1.0 }
    self.MetalSlider.sliderMouseOverColor = { r = 0.8, g = 0.4, b = 1.0, a =1 }
    local mode = self.player:getModData().FoodGames.Mode

    if mode == "HomeLender" and self.icon_HomeLender then
        self.icon_HomeLender:setImage(iconTex)
        self.CalSlider.sliderBarColor = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 }
    elseif mode == "Wolferine" and self.icon_Wolferine then
        self.icon_Wolferine:setImage(iconTex)
        self.CalSlider.sliderBarColor = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }
    elseif mode == "MagKneeToe" then
        if self.icon_MagKneeToe1 then self.icon_MagKneeToe1:setImage(iconTex) end
        if self.icon_MagKneeToe2 then self.icon_MagKneeToe2:setImage(iconTex) end
        self.CalSlider.sliderBarColor = { r = 0.6, g = 0.2, b = 0.7, a = 1.0 }
        self.CalSlider.sliderMouseOverColor = { r = 0.8, g = 0.4, b = 1.0, a = 1.0 }
    end

end ]]

-----------------------            ---------------------------

--[[
function FoodGamesPanel:onMouseUpOutside(x, y)
    ISCollapsableWindow.onMouseUpOutside(self, x, y)
    self.mouseOver = true;
    self.moveWithMouse = false;
    if self.moving then
        self.moving = false
        self:bringToTop()
    end
end
function FoodGamesPanel:onMouseMoveOutside(dx, dy)
    ISCollapsableWindow.onMouseMoveOutside(self, dx, dy)
	self.mouseover = false;
    self.moveWithMouse = false;
    if self.moving and not isMouseButtonDown(0) then
        self.moving = false
    end
end


function FoodGamesPanel:onMouseUp(x,y)
    FoodGames.checkCaloriesAndDisable(self.player)
	if self.onclick then
		self.onclick(self.target, self);
	end
    ISMouseDrag.dragView = nil;
end ]]