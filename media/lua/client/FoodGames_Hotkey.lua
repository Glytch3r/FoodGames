
function FoodGames.key(key)
    local isAllowKeyBind = SandboxVars.FoodGames.AllowKeyBind or true
	local pl = getPlayer()
    if not pl then return end
    if not isAllowKeyBind or not FoodGames.isHero(pl) then return end       
    local mode = FoodGames.getMode()  
    if not mode then return end    
    if key == getCore():getKey("Food Games Skill 1") then
        FoodGames.onSkill(1)
    end
    if key == getCore():getKey("Food Games Skill 2") and FoodGames.isDualSkilled(mode) then		
        FoodGames.onSkill(2)     
    end
    
	return key
end
Events.OnKeyPressed.Add(FoodGames.key)