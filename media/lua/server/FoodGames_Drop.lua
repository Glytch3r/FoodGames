
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


--server
if isClient() then return; end

FoodGames = FoodGames or {}

function FoodGames.ZedItemDropHandler(zed)
   local qty =  SandboxVars.FoodGames.MaxZedDrops or 5
   local inv = zed:getInventory();
   inv:AddItems("Base.ZeeVeeMutagen",  ZombRand(0, qty + 1))
end

Events.OnZombieDead.Add(FoodGames.ZedItemDropHandler);