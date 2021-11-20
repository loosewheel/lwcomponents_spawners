local version = "0.1.0"



lwcomponents_spawners = { }



function lwcomponents_spawners.version ()
	return version
end


local utils = { }
local modpath = minetest.get_modpath ("lwcomponents_spawners")

loadfile (modpath.."/settings.lua") (utils)
loadfile (modpath.."/mobs.lua") (utils)
loadfile (modpath.."/projectile.lua") (utils)



--
