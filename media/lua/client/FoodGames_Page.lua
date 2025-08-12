
FoodGames = FoodGames or {}

FoodGames.CircleRadius = 0.5

FoodGames.colorList = {
    ["HomeLender"] = { r = 0.8, g = 0.3, b = 0.3, a = 1 },
    ["Wolferine"] = { r = 0.76, g = 0.7, b = 0.4,  a = 1 },
    ["MagKneeToe"] = { r = 0.86, g = 0.36, b = 0.89, a = 1},
    ["GameBet"] = { r = 0.99, g = 0.32, b = 0.64, a = 1 },
}
FoodGames.modeIndex = {
    [1]="HomeLender",
    [2]="Wolferine",
    [3]="MagKneeToe",
    [4]="GameBet",
}
function FoodGames.isTargCont(targCont)
    local plNum = getPlayer():getPlayerNum() or 0
    return getPlayerLoot(plNum).inventoryPane.inventory == targCont
end
function FoodGames.getHeroColor(mode)
    mode = mode or FoodGames.getMode()    
    return FoodGames.colorList[mode] or { r = 1, g = 1, b = 1, a = 1 }
end

function FoodGames.MarkerHandler()

    if FoodGames.skillMarker then
        FoodGames.skillMarker:remove(); FoodGames.skillMarker = nil
    end

    local pl = getPlayer()
    if not pl then return end
    local csq = pl:getCurrentSquare() 
    local mode = FoodGames.getMode()    
    if not mode then return end
  
    if not SandboxVars.FoodGames.SkillIndicator  then return end
    local col = FoodGames.getHeroColor(mode)
    if col and csq then 
        if FoodGames.isActiveSkill(mode, 1) or FoodGames.isActiveSkill(mode, 2)  then          
            FoodGames.skillMarker = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", csq, col.r, col.g, col.b, true, 0.6);
        end
    end

end
Events.OnPostRender.Remove(FoodGames.MarkerHandler)
Events.OnPostRender.Add(FoodGames.MarkerHandler)
-----------------------            ---------------------------
function FoodGames.getCurIndex(mode)
    local modes = FoodGames.modesStr
    for i, v in ipairs(modes) do
        if v == mode then
            return i
        end
    end
    return nil
end

function FoodGames.getIndexMode(int)
    return FoodGames.modeIndex[int]
end
function FoodGames.getNextMode(pl)
    pl = pl or getPlayer()
    local modes = FoodGames.modesStr
    local mode = FoodGames.getMode()
    local curIndex = FoodGames.getCurIndex(mode)
    curIndex = curIndex + 1
    if curIndex > #modes then curIndex = 1 end
    local mode = modes[curIndex]
    if not pl:HasTrait(tostring(mode)) then
        return FoodGames.getNextMode(pl, modes, curIndex)
    end
    return curIndex, mode
end

function FoodGames.getPrevMode(pl)
    pl = pl or getPlayer()
    local modes = FoodGames.modesStr
    local mode = FoodGames.getMode()
    local curIndex = FoodGames.getCurIndex(mode)
    curIndex = curIndex - 1
    if curIndex < 1 then curIndex = #modes end
    local mode = modes[curIndex]
    if not pl:HasTrait(tostring(mode)) then
        return FoodGames.getPrevMode(pl, modes, curIndex)
    end
    return curIndex, mode
end


-----------------------            ---------------------------
function FoodGames.isActiveCont(obj)
    local cont = obj:getContainer()
    if not cont then return false end
    return FoodGames.isTargCont(cont) or false
end

function FoodGames.getSprName(obj)
    if not obj then return nil end
    local spr = obj:getSprite()
    return spr and spr:getName() or nil
end
-----------------------            ---------------------------
function FoodGames.ISInventoryPageHook()
    --if not isIngameState() then return end
    -----------------------            ---------------------------
    FoodGames.rClickHook = FoodGames.rClickHook or ISInventoryPage.onBackpackRightMouseDown
    function ISInventoryPage:onBackpackRightMouseDown(x, y)
        FoodGames.rClickHook(self, x, y)
        local page = self.parent
        local container = self.inventory
        if not container then return end

        local item = container:getContainingItem()
        if item then return end
        local context = ISContextMenu.get(page.player, getMouseX(), getMouseY())
        local pl = getSpecificPlayer(page.player)

        local count = FoodGames.getMetalItemCount(container)
        local val = FoodGames.getContainerMetalTotal(container)
        local sq = container:getSourceGrid() or pl:getCurrentSquare()

        if not (val or count) then return end
        if val <= 0 or count <= 0 then return end

        local plural = ""
        if count > 1 then plural = "s" end
        local cap = "Store ".. tostring(count) .." Metal Item"..tostring(plural)..": ["..tostring(val).."]"
        context:addOption(tostring(cap), container, function()
            if luautils.walkAdj(pl, sq) then             
                FoodGames.consumeAllMetalFromContainer(container, pl)
                HaloTextHelper.addTextWithArrow(pl, "Stored Metal "..tostring(val), true, HaloTextHelper.getColorGreen())
            end
        end, pl)


    --[[     context:addOption(tostring(cap), container, function()
            if luautils.walkAdj(pl, sq) then
                getSoundManager():playUISound("HandShovelHit")

                pl:Say(tostring(sub))
            end
        end, pl) ]]

        --print(cap)
    end



    FoodGames.updatehook = FoodGames.updatehook or ISInventoryPage.update
    function ISInventoryPage:update()
        FoodGames.updatehook(self, self.player)
        local obj = self.inventory:getParent()
        if not obj then return end
        local sprName = FoodGames.getSprName(obj)
--[[
        if self.SealButton then
            self.SealButton:setVisible(true)
        end ]]
        --self.title = "FoodGames"
    end

end
Events.OnCreatePlayer.Add(FoodGames.ISInventoryPageHook)
--[[
FoodGames.ISInventoryPageHook()
]]


function FoodGames.bagContext(player, context, items)
    local pl = getSpecificPlayer(player)
    for i, entry in ipairs(items) do
        local item = type(entry) == "table" and (entry.items and entry.items[1]) or entry
        if not item then  return end

        if instanceof(item, "InventoryContainer") then
            local container = item:getInventory()
            local count = FoodGames.getMetalItemCount(container)
            local val = FoodGames.getContainerMetalTotal(container)
            local sq = container:getSourceGrid() or pl:getCurrentSquare()

            if val > 0 and count > 0 then
                local plural = count > 1 and "s" or ""
                local label = "Store ".. count .." Metal Item".. plural ..": ["..val.."]"

                context:addOptionOnTop(label, container, function()
                    if luautils.walkAdj(pl, sq) then                   
                        FoodGames.consumeAllMetalFromContainer(container, pl)
                        HaloTextHelper.addTextWithArrow(pl, "Stored Metal ".. val, true, HaloTextHelper.getColorGreen())
                    end
                end)
            end
        end
    end

end

Events.OnFillInventoryObjectContextMenu.Remove(FoodGames.bagContext)
Events.OnFillInventoryObjectContextMenu.Add(FoodGames.bagContext);
