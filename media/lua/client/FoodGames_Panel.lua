
FoodGames = FoodGames or {}

require "ISUI/ISCollapsableWindow"

FoodGamesPanel = ISCollapsableWindow:derive("FoodGamesPanel")

function FoodGamesPanel:update()
    ISCollapsableWindow.update(self)

end


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
    modData['FoodGames']['consumedCalories'] = modData['FoodGames']['consumedCalories'] or 0
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

function FoodGamesPanel:close()
    if FoodGamesPanel.instance ~= nil then
        FoodGamesPanel.instance:setVisible(false)
        FoodGamesPanel.instance:removeFromUIManager()
        FoodGamesPanel.instance = nil
    end
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
    print("Mode changed to:", fgData['Mode'])

    local sound = (fgData['Mode'] == mode) and toggleOnSound or toggleOffSound
    getSoundManager():playUISound(sound)

    if fgData['Mode'] == "Wolferine" then
        FoodGames.doHealRandPart(self.player)
    end
end
-----------------------            ---------------------------

function FoodGamesPanel:createChildren()
    ISCollapsableWindow.createChildren(self)

    self:setTitle("Food Game Calories");
    self.HomeLenderBG_0 = getTexture("media/ui/HomeLenderPanel_0.png")
    self.HomeLenderBG_1 = getTexture("media/ui/HomeLenderPanel_1.png")
    self.WolferinelBG_0 = getTexture("media/ui/WolferinePanel_0.png")
    self.WolferinelBG_1 = getTexture("media/ui/WolferinePanel_1.png")

    self.Mode = self.player and self.player:getModData() and self.player:getModData().FoodGames and self.player:getModData().FoodGames.Mode or "off"
    if self.Mode == "HomeLender" then
        self.bgTexture = self.HomeLenderBG_1
    elseif self.Mode == "Wolferine" then
        self.bgTexture = self.WolferinelBG_1
    else
        self.bgTexture = self.HomeLenderBG_0
    end

    local data = self.player:getModData()['FoodGames'] and self.player:getModData()['FoodGames']['consumedCalories'] or 0
    local xOffset = 12
    local yOffset = 20
    --[[
    self.bg = ISImage:new(xOffset, yOffset, 322, 172, self.bgTexture)
    self.bg.scaled = true
    self.bg:initialise()
    self:addChild(self.bg)

 ]]
    self.themecol =  {r = 1, g = 1, b = 1}


    self.Red_ArrowLeft = getTexture("media/ui/Red_ArrowLeft.png")
    self.Yellow_ArrowLeft = getTexture("media/ui/Yellow_ArrowLeft.png")
    self.Gray_ArrowLeft = getTexture("media/ui/Gray_ArrowLeft.png")

    self.Red_ArrowRight = getTexture("media/ui/Red_ArrowRight.png")
    self.Yellow_ArrowRight = getTexture("media/ui/Yellow_ArrowRight.png")
    self.Gray_ArrowRight = getTexture("media/ui/Gray_ArrowRight.png")

    self.hIcon_0 = getTexture("media/ui/HomeLenderIcon_Off.png")
    self.hIcon_1 = getTexture("media/ui/HomeLenderIcon_On.png")

    self.wIcon_0 = getTexture("media/ui/WolferineIcon_Off.png")
    self.wIcon_1 = getTexture("media/ui/WolferineIcon_On.png")

    self.icon_h = ISButton:new(xOffset+32, 35, 32, 32, "", self,
        function(btn)
            self:OnBtnPress(btn, 'Mode_H', 'HomeLender', 'HomeLander_ToggleOn', 'HomeLander_ToggleOff')
        end)
    self.icon_h.internal = "IconH"
    self.icon_h:setImage(self.hIcon_0)
    self.icon_h:forceImageSize(32, 32)
    self.icon_h:initialise()
    self.icon_h:instantiate()
    self:addChild(self.icon_h)
    self.icon_h.borderColor = {r=0, g=0, b=0, a=0}
    self.icon_h.displayBackground = false

    self.icon_w = ISButton:new(xOffset+32, 67, 32, 32, "", self,
        function(btn)
            self:OnBtnPress(btn, 'Mode_W', 'Wolferine', 'Wolferine_ToggleOn', 'Wolferine_ToggleOff')
        end)
    self.icon_w.internal = "IconW"
    self.icon_w:setImage(self.wIcon_0)
    self.icon_w:forceImageSize(32, 32)
    self.icon_w:initialise()
    self.icon_w:instantiate()
    self:addChild(self.icon_w)
    self.icon_w.borderColor = {r=0, g=0, b=0, a=0}
    self.icon_w.displayBackground = false

    self.CalSlider = ISSliderPanel:new(xOffset+35, self.height / 4 + 70, 250, 32, self, self.OnSliderChange)
    self.CalSlider.anchorTop = false
    self.CalSlider.anchorBottom = true
    self.CalSlider:initialise()
    self.CalSlider:instantiate()
    self.CalSlider:setValues(0.0, 99999, 0.1, 1, true)
    self.CalSlider:setHeight(32)
    self:addChild(self.CalSlider)
    self.CalSlider.texBtnLeft = self.ArrowLeft_0
    self.CalSlider.texBtnRight = self.ArrowRight_0
    self.CalSlider:setCurrentValue(data)
    self.CalSlider.sliderColor = self.backgroundColor
    self.CalSlider.sliderMouseOverColor = {r=1.0, g=0, b=0, a=1.0};

end
function FoodGamesPanel:onMouseMoveOutside(dx, dy)

	self.mouseover = false;
end

function FoodGamesPanel:onMouseUp(x,y)
    FoodGames.checkCaloriesAndDisable(self.player)
	if self.onclick then
		self.onclick(self.target, self);
	end
end

-----------------------            ---------------------------

function FoodGamesPanel:prerender()
    ISCollapsableWindow.prerender(self)

    if not self.CalSlider then return end
    if not self.player then return end

    local modData = self.player:getModData()
    if not modData then return end

    local foodGames = modData['FoodGames']
    if not foodGames then return end

    local calories = tonumber(foodGames['consumedCalories']) or 0
    calories = math.max(0, math.min(99999, calories))

    if math.abs(self.CalSlider:getCurrentValue() - calories) > 0.01 then
    end

    local mode = foodGames['Mode'] or 'off'
    if mode == 'HomeLender' then
        self.lastMode = 'HomeLender'
        self.icon_h:setImage(self.hIcon_1)
        self.icon_w:setImage(self.wIcon_0)
        self.bgTexture = self.HomeLenderBG_1
        --self.bg:setTexture(self.HomeLenderBG_1)
        self.CalSlider.texBtnLeft = self.Red_ArrowLeft
        self.CalSlider.texBtnRight = self.Red_ArrowRight
        self.themeCol = {r = 1, g = 0, b = 0}

    elseif mode == 'Wolferine' then
        self.lastMode = 'Wolferine'
        self.icon_h:setImage(self.hIcon_0)
        self.icon_w:setImage(self.wIcon_1)
        --self.bg:setTexture(self.WolferinelBG_1)
        self.bgTexture = self.WolferinelBG_1
        self.CalSlider.texBtnLeft = self.Yellow_ArrowLeft
        self.CalSlider.texBtnRight = self.Yellow_ArrowRight
        self.themeCol = {r = 1, g = 1, b = 0}

    else -- off
        self.icon_h:setImage(self.hIcon_0)
        self.icon_w:setImage(self.wIcon_0)
        self.CalSlider.texBtnLeft = self.Gray_ArrowLeft
        self.CalSlider.texBtnRight = self.Gray_ArrowRight
        if self.lastMode == 'HomeLender' then
            self.bgTexture = self.HomeLenderBG_0
            --self.bg:setTexture(self.HomeLenderBG_0)
        elseif self.lastMode == 'Wolferine' then
            self.bgTexture = self.WolferinelBG_0
            --self.bg:setTexture(self.WolferinelBG_0)
        end
        self.themeCol = {r = 1, g = 1, b = 1}
    end

    if self.bgTexture then
        self:drawTexture(self.bgTexture, 12, 20, 1)
    end

    self.borderColor = {r = self.themeCol.r, g = self.themeCol.g, b = self.themeCol.b, a = 1}
    self:drawTextCentre(tostring(math.floor(calories)), self:getWidth() / 2, 32, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Large)

    local storedFood = FoodGames.convertDaysToYMD(calories)
    self:drawTextCentre(tostring(storedFood), self:getWidth() / 2, 70, self.themeCol.r, self.themeCol.g, self.themeCol.b, 1, UIFont.Medium)
end

function FoodGamesPanel:OnSliderChange()
    self.CalSlider.sliderColor = self.borderColor
    if getCore():getDebug() then
        self.player:getModData()['FoodGames']['consumedCalories']  =  self.CalSlider:getCurrentValue()
    end

end

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
    o.calData = player:getModData()['FoodGames']['consumedCalories'] or 0
    o.consume = SandboxVars.FoodGames.CalConsume or 500
    o.variableColor = {r = 1, g = 0.55, b = 1, a = 1}
    --o.borderColor = {r = 0, g = 0, b = 0.6, a = 1}
    o.borderColor = { r = 0.76, g = 0.59, b = 0.11, a = 1}
    o.backgroundColor = { r = 0.30, g = 0.30, b = 0.30, a =  0.1}--{ r = 0.12, g = 0.39, b = 0.77,  a = 1}
    o.buttonBorderColor = {r = 0.7, g = 0.7, b = 0.7, a = 1}
    o:setResizable(true)
    o.resizable = true
    --o.moveWithMouse = true
    --o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
    return o
end

function FoodGamesPanel:render()
    ISCollapsableWindow.render(self)
end

function FoodGamesPanel:initialise()
    ISCollapsableWindow.initialise(self)
    self:createChildren()
end



function FoodGames.context(player, context, worldobjects, test)
	local pl = getSpecificPlayer(player)
	--if not pl:HasTrait("HomeLender") then return end
	local sq = clickedSquare
	local targ = clickedPlayer
	local obj = nil
	if not sq then return end
    local csq = pl:getCurrentSquare()
    local Mode =  pl:getModData()['FoodGames']['Mode']
    if not Mode then
        pl:getModData()['FoodGames']['Mode'] = "off"
    end
	if csq == sq then

        local optTip = context:addOptionOnTop("Food Games", worldobjects, function()
            FoodGames.open()
            getSoundManager():playUISound("UIActivateMainMenuItem")
            context:hideAndChildren()
        end)

        local ico = "media/ui/FG_Gray.png"
        if Mode == "HomeLender" then
            ico = "media/ui/FG_Red.png"
        elseif Mode == "Wolferine" then
            ico = "media/ui/FG_Yellow.png"
        end


        optTip.iconTexture = getTexture(ico)
        local tip = ISWorldObjectContextMenu.addToolTip()
        tip:setTexture(ico)
        local calories = pl:getModData()['FoodGames']['consumedCalories']
        local storedFood = FoodGames.convertDaysToYMD(tonumber(calories))
        tip.description = "Hero Mode:\n"..tostring(Mode).."\n\n".."Consumed Calories:\n"..tostring(calories).."\n\n".."Stored Food:\n"..tostring(storedFood)
        optTip.toolTip = tip



--[[
        optTip.notAvailable = true
        optTip:setOptionChecked(optTip,  bool) ]]
    end

end
Events.OnFillWorldObjectContextMenu.Remove(FoodGames.context)
Events.OnFillWorldObjectContextMenu.Add(FoodGames.context)

