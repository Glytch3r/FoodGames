
FoodGames = FoodGames or {}

function FoodGames.initModData(plNum, pl)
    if not pl or not instanceof(pl, "IsoPlayer") then return end

    local playerMd = pl:getModData()
    playerMd.FoodGames = playerMd.FoodGames or {}
    local fg = playerMd.FoodGames

    fg.consumedCalories = fg.consumedCalories or 0
    fg.Mode = fg.Mode or "off"
    fg.Catapult = fg.Catapult or false
end

Events.OnCreatePlayer.Add(FoodGames.initModData)

function FoodGames.getMode(pl)
    pl = pl or getPlayer()
    if not pl then return "off" end

    local modData = pl:getModData()
    if not modData or not modData.FoodGames then return "off" end

    local mode = modData.FoodGames.Mode
    if mode ~= "HomeLender" and mode ~= "Wolferine" then
        return "off"
    end

    return mode
end

function FoodGames.isHeroMode(pl)
    pl = pl or getPlayer()
    local mode = FoodGames.getMode(pl)
    return (mode == "HomeLender" or  mode == "Wolferine") or false
end
function FoodGames.isHero(pl)
    pl = pl or getPlayer()
    return (pl:HasTrait("HomeLender") or pl:HasTrait("Wolferine")) or false
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

function FoodGames.clearFoodGamesModData()
    local player = getPlayer()
    local playerMd = player:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    playerMd['FoodGames']['consumedCalories'] = playerMd['FoodGames']['consumedCalories'] or 0
    playerMd['FoodGames']['consumedCalories'] = 0
    playerMd['FoodGames']['Mode'] = 'off'
    playerMd['FoodGames']['Catapult'] = false
end

function FoodGames.printFoodGames()
    local player = getPlayer()
    local playerMd = player:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    print(playerMd['FoodGames']['consumedCalories'])
end

