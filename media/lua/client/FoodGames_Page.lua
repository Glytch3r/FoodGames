
FoodGames = FoodGames or {}

function FoodGames.isTargCont(targCont)
    local plNum = getPlayer():getPlayerNum() or 0
    return getPlayerLoot(plNum).inventoryPane.inventory == targCont
end

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
