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
FoodGames = FoodGames or {}

function FoodGames.isZombieNearby(pl, rad)
    if not pl or not rad then return false end
    local cx, cy, cz = round(pl:getX()), round(pl:getY()), pl:getZ()
    local zeds = getCell():getZombieList()
    for i = 0, zeds:size() - 1 do
        local zed = zeds:get(i)
        if zed and not zed:isDead() and zed:getZ() == cz then
            local zx, zy = round(zed:getX()), round(zed:getY())
            local dx, dy = zx - cx, zy - cy
            if (dx * dx + dy * dy) <= (rad * rad) then
                return true
            end
        end
    end
    return false
end

function FoodGames.isUnarmed(pl)
    return tostring(WeaponType.getWeaponType(pl)) == 'barehand'
end

function FoodGames.doShotgun()
    local pl = getPlayer()
	if not pl or not FoodGames.isHero(pl) then return end
    if not FoodGames.isUnarmed(pl) then return end
    
    local mode = FoodGames.getMode()
    if not mode then return end
    FoodGames.disableSkill(pl, 2, mode)
    if not (pl:HasTrait(mode) and FoodGames.getMode() == mode) then         
        FoodGames.disableSkill(pl, 1, mode)
        return
    end
    if not FoodGames.isActiveSkill(mode, 1) then return end
    local rad = FoodGames.getRad(mode, 1)
    if FoodGames.isZombieNearby(pl, rad) then   
        FoodGames.doAoE(1)  
    end
end
Events.EveryOneMinute.Remove(FoodGames.doShotgun)

Events.EveryOneMinute.Add(FoodGames.doShotgun)

function FoodGames.doShotgun2()
    local pl = getPlayer()
    if not pl then return end
    if not FoodGames.isUnarmed(pl) then return end
    
    local skillNum = 2 
    local mode = FoodGames.getMode()
    FoodGames.disableSkill(pl, 1, mode)

    if not (pl:HasTrait(mode) and mode == FoodGames.getMode()) then         
        FoodGames.disableSkill(pl, 2, mode)
        return
    end

    if not FoodGames.isActiveSkill(mode, skillNum) then return end
    if not FoodGames.isHasEnergy(pl, skillNum) then
        FoodGames.disableSkill(pl, skillNum, mode)
        return
    end

    local rad = FoodGames.getRad(mode, skillNum)
    FoodGames.doAoE(skillNum)
    FoodGames.doPulse(pl:getCurrentSquare(), rad, skillNum)

    timer:Simple(1.5, function() 
        FoodGames.disableSkill(pl, skillNum, mode)
    end)
end

function FoodGames.doRoll(percent)
    return percent >= ZombRand(1, 101)
end

function FoodGames.doDmg(zed, skillNum)
    local pl = getPlayer()
    if not pl or not zed or not zed:isAlive() then return end
    
    local min, max, rad
    local dmg = 0
    local isMagKneeToe = FoodGames.getMode() == "MagKneeToe"
    local isGameBet = FoodGames.getMode() == "GameBet"

    if isMagKneeToe then
        if skillNum == 2 then
            min = SandboxVars.FoodGames.MetalMinZedDmg2
            max = SandboxVars.FoodGames.MetalMaxZedDmg2
            rad = SandboxVars.FoodGames.MetalSkillRadius2
            dmg = ZombRand(min, max)
        else
            min = SandboxVars.FoodGames.MetalMinZedDmg1
            max = SandboxVars.FoodGames.MetalMaxZedDmg1
            rad = SandboxVars.FoodGames.MetalSkillRadius1
            dmg = ZombRand(min, max)
            FoodGames.doPulse(pl:getCurrentSquare(), rad, 1)
        end
    elseif isGameBet then
        if skillNum == 2 then    
            dmg = SandboxVars.FoodGames.CardsZedDmg2
            rad = SandboxVars.FoodGames.CardsSkillRadius2
        else
            dmg = SandboxVars.FoodGames.CardsZedDmg1
            rad = SandboxVars.FoodGames.CardsSkillRadius1
            FoodGames.doPulse(pl:getCurrentSquare(), rad, 1)
        end
    else
        return
    end
    zed:setAttackedBy(pl)
    zed:setHealth(zed:getHealth() - dmg)
    zed:playSound("KatanaHit")

    if FoodGames.doRoll(50) then
        zed:setHitReaction("ShotBelly")
    else
        zed:setKnockedDown(true)
    end
end

function FoodGames.getMultiHitCount(mode, skillNum)
    mode = mode or FoodGames.getMode()
    if not mode or not FoodGames.isDualSkilled(mode) then return 0 end
    local sData = SandboxVars.FoodGames
    local tab = {
        ["MagKneeToe"]  = {
            [1] = sData.MetalMaxHitCount1,
            [2] = sData.MetalHitCount2,
        },
        ["GameBet"] = {
            [1] = sData.CardsMaxHitCount1,
            [2] = sData.CardsMaxHitCount2,
        },
    }
    return tab[tostring(mode)] and tab[tostring(mode)][skillNum] or 0
end

function FoodGames.getRad(mode, skillNum)
    mode = mode or FoodGames.getMode()
    if not mode or not FoodGames.isDualSkilled(mode) then return 0 end
    local sData = SandboxVars.FoodGames
    local tab = {
        ["GameBet"] = {
            [1] = sData.CardsSkillRadius1,
            [2] = sData.CardsSkillRadius2,
        },
        ["MagKneeToe"] = {
            [1] = sData.MetalSkillRadius1,
            [2] = sData.MetalSkillRadius2,
        },
    }
    return tab[tostring(mode)] and tab[tostring(mode)][skillNum] or 0
end
-----------------------            ---------------------------
function FoodGames.doAoE(skillNum)
    local pl = getPlayer()
    if not pl then return end
    local mode = FoodGames.getMode(pl)

    local rad = FoodGames.getRad(mode, skillNum)
    if rad <= 0 then return end

    if not FoodGames.consumeEnergy(pl, skillNum, mode) then
        FoodGames.disableSkill(pl, skillNum, mode)
        return
    end

    if skillNum == 2 then
        FoodGames.doPulse(pl:getCurrentSquare(), rad, 2)
    elseif skillNum == 1 and FoodGames.isZombieNearby(pl, rad) then
        FoodGames.doPulse(pl:getCurrentSquare(), rad, 1)
    end

    local zeds = getCell():getZombieList()
    for i = 0, zeds:size() - 1 do
        local zed = zeds:get(i)
        if zed and zed:isAlive() then
            local dx = zed:getX() - pl:getX()
            local dy = zed:getY() - pl:getY()
            if dx * dx + dy * dy <= rad * rad then
                FoodGames.doDmg(zed, skillNum)
            end
        end
    end
end

-----------------------            ---------------------------
function FoodGames.doPulse(sq, rad, skillNum)
    local pl = getPlayer()
    if not pl or not isIngameState() then return end
    skillNum = skillNum or 1

    local mode = FoodGames.getMode()
    local str
    if mode == "GameBet" then
        str = "GameBet_Skill"
    elseif mode == "MagKneeToe" then
        str = "MagKneeToe_Skill"
    else
        str = "Generic_Skill"
    end

    local sfx = tostring(str)..tostring(skillNum)
    pl:playSound(sfx)
    addSound(pl, pl:getX(), pl:getY(), pl:getZ(), rad, 1)

    sq = sq or pl:getCurrentSquare()
    local col = { r = 0.86, g = 0.36, b = 0.89 }

    FoodGames.animTimer = FoodGames.animTimer or {}
    FoodGames.marker = FoodGames.marker or {}

    if FoodGames.animTimer[skillNum] then
        timer:Stop(FoodGames.animTimer[skillNum])
        FoodGames.animTimer[skillNum] = nil
    end

    if FoodGames.marker[skillNum] then
        FoodGames.marker[skillNum]:remove()
        FoodGames.marker[skillNum] = nil
    end

    local steps = math.max(math.abs(rad - 1) + 1, 1)
    if steps < 1 then return end

    local currentStep = 0

    local function step()
        if FoodGames.marker[skillNum] then
            FoodGames.marker[skillNum]:remove()
            FoodGames.marker[skillNum] = nil
        end

        currentStep = currentStep + 1
        local t = currentStep / steps
        local radius = 1 + (rad - 1) * t

        FoodGames.marker[skillNum] = getWorldMarkers():addGridSquareMarker(
            "circle_only_highlight",
            "circle_only_highlight",
            sq,
            col.r, col.g, col.b,
            true,
            radius
        )

        local frameDelay = 1
        if currentStep < steps then
            FoodGames.animTimer[skillNum] = timer:Simple(frameDelay / 1000, step)
        else
            FoodGames.animTimer[skillNum] = timer:Simple(frameDelay / 1000, function()
                if FoodGames.marker[skillNum] then
                    FoodGames.marker[skillNum]:remove()
                    FoodGames.marker[skillNum] = nil
                end
                FoodGames.animTimer[skillNum] = nil
            end)
        end
    end

    step()
end
