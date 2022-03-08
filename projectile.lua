
if minetest.global_exists ("projectile") then



local function shoot (spawn_pos, itemstack, owner, spawner_pos, spawner_dir, force, catagory)
	local pos = spawn_pos
	local level = 1
	local ammo_entity = projectile.registered_projectiles[catagory][itemstack:get_name ()]

	if not itemstack:is_empty() and ammo_entity then
		local adef = minetest.registered_entities[ammo_entity]

		-- Fire an amount of projectiles at once according to the ammo's defined "count".
		for n = 1, (adef.count or 1) do
			local projectile = minetest.add_entity (pos, ammo_entity)
			local luapro = projectile:get_luaentity()

			-- Set velocity according to the direction it was fired.
			-- Speed is determined by the ammo. No weapon and always fully charged.
			projectile:set_velocity(vector.multiply (spawner_dir, luapro.speed))
			-- An acceleration of -9.81y is how gravity is applied.
			projectile:set_acceleration ({ x = 0, y = -9.81, z = 0 })

			--If the ammo defines a spread, randomly rotate the direction of velocity by that given radius.
			if adef.spread then
				local rx = (math.random() * adef.spread * 2 - adef.spread) * math.pi / 180
				local ry = (math.random() * adef.spread * 2 - adef.spread) * math.pi / 180

				projectile:set_velocity(vector.rotate(projectile:get_velocity(), {x = rx, y = ry, z = 0}))
			end

			-- Store level for later, to determine impact damage
			luapro.level = level
			-- Also store the projectile's damage itself.
			luapro.damage = adef.damage
			-- The player's name is stored to prevent hitting yourself
			-- And by "hitting yourself" I mean accidentally being hit by the arrow just by firing it at a
			-- somewhat low angle, the moment it spawns.
			luapro.owner = owner
			-- Store the initial velocity for passing by objects when needed.
			luapro.oldvel = projectile:get_velocity()
		end

		return projectile, false
	end

	return nil, false
end



local function register_spawner (ammo, catagory)

	lwcomponents.register_spawner (ammo,
	function (spawn_pos, itemstack, owner, spawner_pos, spawner_dir, force)
		return shoot (spawn_pos, itemstack, owner, spawner_pos, spawner_dir, force, catagory)
	end)

end


for weapon, wdef in pairs (projectile.registered_projectiles) do
	for ammo, adef in pairs (projectile.registered_projectiles[weapon]) do
		if adef then
			register_spawner (ammo, weapon)
		end
	end
end



end
