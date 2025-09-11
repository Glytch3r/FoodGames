
--     ▄▄▄  ▄    ▄   ▄ ▄▄▄▄▄  ▄▄▄  ▄   ▄  ▄▄▄   ▄▄▄     
--    █   ▀ █    █▄▄▄█   █   █   ▀ █▄▄▄█ ▀  ▄█ █ ▄▄▀    
--    █  ▀█ █      █     █   █   ▄ █   █ ▄   █ █   █       
--     ▀▀▀▀ ▀▀▀▀   ▀     ▀    ▀▀▀  ▀   ▀  ▀▀▀  ▀   ▀     
--ᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨ--
--╽        Project   Zomboid    Modding    Commissions       ╽--
--╽  https://steamcommunity.com/id/glytch3r/myworkshopfiles  ╽--
--╽                                                          ╽--
--╽  ▫ Discord꞉  glytch3r                                    ╽--
--╽  ▫ Support꞉  https://ko-fi.com/glytch3r                  ╽--
--╽  ▫ Youtube꞉  https://www.youtube.com/@glytch3r           ╽--
--╽  ▫ Github꞉   https://github.com/Glytch3r                 ╽--
--╽                                                          ╽--
--ᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨᴨ--

FoodGames = FoodGames or {}

Recipe = Recipe or {}
Recipe.GetItemTypes = Recipe.GetItemTypes or {}
Recipe.OnCanPerform = Recipe.OnCanPerform or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.OnGiveXP = Recipe.OnGiveXP or {}
Recipe.OnTest = Recipe.OnTest or {}

function Recipe.OnTest.isGameBet(item)
   return getPlayer():HasTrait("GameBet")
end



function Recipe.OnCreate.ConsumeCards()
   local pl = getPlayer() 
   if pl and pl and pl:HasTrait("GameBet") then
      local modData = pl:getModData()['FoodGames']      
      local maxCards = SandboxVars.FoodGames.CardsCapacity
      modData['StoredCards'] =  math.min(maxCards, (modData['StoredCards'] or 0) + 54)
   end
end


function FoodGames.isCutter(item)
    if not item then return false end
   
    local mgr = getScriptManager()
    local tags = {
        "DullKnife",
        "SharpKnife",
        "Scissors",
        "Razor"
    }

    local itemType = item:getType()
    for _, tag in ipairs(tags) do
        local str = tostring(mgr:getItemsTag(tag))
        if str:contains(itemType) then
            return true
        end
    end
    return false
end


function Recipe.OnTest.CutCheck(item)
   if not item then return false end
   if item:getType() == "PlayCardSheet" then return true end   
	local isCutter =  FoodGames.isCutter(item) 
   return isCutter and not item:isBroken() 
end


function Recipe.OnCreate.BreakCheck(items, result, player)
   for i=0, items:size()-1 do
      local item = items:get(i)
      if FoodGames.isCutter(item) then
         local cond = item:getCondition()
         local subtrahend = item:getConditionMax() * 0.1
         local chance = ZombRand(0, item:getConditionLowerChance())==0
         if chance then
            if not item:isBroken() then
               item:setCondition(cond - subtrahend)
               break
            end
         end
      end
   end
   --return item:isBroken()
end

local function consumeTenPercent(item)
    if not item or not instanceof(item, "DrainableComboItem") then return end

    local currentDelta = item:getUsedDelta()
    local consumeAmount = 0.10
    local newDelta = currentDelta - consumeAmount
    if newDelta < 0 then newDelta = 0 end

    item:setUsedDelta(newDelta)
end

function Recipe.OnCreate.PaintCard(items, result, player)
   local paint = nil
   for i=0, items:size()-1 do
      local item = items:get(i)
      local itemType = item:getType()
      if itemType then         
         if luautils.stringStarts(string.lower(itemType), "paint") then
            paint = item
            break
         end
      end
   end
   if paint then 
      consumeTenPercent(item)
   end
end

-----------------------            ---------------------------

--[[ 
function FoodGames.isWrite(item, pl)
    pl = pl or getPlayer()
    if not pl or not item then return false end

    local str = tostring(getScriptManager():getItemsTag("Write"))
    local itemType = item:getType() 
    return str:contains(itemType)
end
 ]]

-----------------------            ---------------------------


--[[
function Recipe.OnCreate.ZVMutagen(items, result, player)
   local dur = SandboxVars.FoodGames.QueezyDuration
   player:getModData()['QueezyHr'] = tonumber(dur)
end
 ]]



