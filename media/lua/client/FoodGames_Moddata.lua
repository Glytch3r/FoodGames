
FoodGames = FoodGames or {}

function FoodGames.initModData(plNum, pl)
    if not pl or not instanceof(pl, "IsoPlayer") then return end

    local playerMd = pl:getModData()
    playerMd.FoodGames = playerMd.FoodGames or {}
    local fg = playerMd.FoodGames
    fg.StoredMetal = fg.StoredMetal or 0

    fg.ConsumedCalories = fg.ConsumedCalories or 0
    fg.Mode = fg.Mode or "off"
    fg.Catapult = fg.Catapult or false
end

Events.OnCreatePlayer.Add(FoodGames.initModData)

function FoodGames.checkCaloriesAndDisable(pl)
    pl = pl or getPlayer()
    local md = pl:getModData()
    local cal = md.FoodGames and md.FoodGames.ConsumedCalories or 0
    local threshold = SandboxVars.FoodGames.CalConsume or 500
    local cost = threshold -- just incase in the future we change each skill cost
    if md.FoodGames and md.FoodGames.Mode ~= "off" then
        if cal - cost < threshold then
            md.FoodGames.Mode = 'off'
        end
    end
end


function FoodGames.getMode(pl)
    pl = pl or getPlayer()
    if not pl then return "off" end

    local modData = pl:getModData()
    local mode = modData and modData.FoodGames and modData.FoodGames.Mode
    return FoodGames.modeList[mode] and mode or "off"
end

function FoodGames.isHeroMode(pl)
    pl = pl or getPlayer()
    return FoodGames.modeList[FoodGames.getMode(pl)] or false
end

function FoodGames.isHero(pl)
    pl = pl or getPlayer()
    for mode in pairs(FoodGames.modeList) do
        if pl:HasTrait(mode) then
            return true
        end
    end
    return false
end

-----------------------            ---------------------------
--monkey's code i only placed it on a table

function FoodGames.convertDaysToYMD(days)
    local years = math.floor(days / 365)
    days = days % 365
    local months = math.floor(days / 30)
    days = days % 30

    return string.format("Y%d M%d D%d", years, months, days)
end

function FoodGames.clearCaloriesData()
    local pl = getPlayer()
    local playerMd = pl:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    playerMd['FoodGames']['ConsumedCalories'] = playerMd['FoodGames']['ConsumedCalories'] or 0
    playerMd['FoodGames']['ConsumedCalories'] = 0
    playerMd['FoodGames']['Mode'] = 'off'
    playerMd['FoodGames']['Catapult'] = false
end

function FoodGames.clearMetalData()
    local pl = getPlayer()
    local playerMd = pl:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    playerMd['FoodGames']['StoredMetal'] = playerMd['FoodGames']['StoredMetal'] or 0
    playerMd['FoodGames']['StoredMetal'] = 0
    playerMd['FoodGames']['Mode'] = 'off'

end
-----------------------            ---------------------------
function FoodGames.printFoodGames()
    local pl = getPlayer()
    local playerMd = pl:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    print("Consumed Calories: "..playerMd['FoodGames']['ConsumedCalories'])
    print("Stored Metal: "..playerMd['FoodGames']['StoredMetal'])

end
