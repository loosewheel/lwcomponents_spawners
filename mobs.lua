
if minetest.global_exists ("mobs") then



local function register_spawner (mob)

	lwcomponents.register_spawner (mob .. "_set",
	function (spawn_pos, itemstack, owner, spawner_pos, spawner_dir, force)
		if minetest.registered_entities[mob] then
			local data = itemstack:get_metadata ()
			local smob = minetest.add_entity (spawn_pos, mob, data)

			if smob then
				local ent = smob:get_luaentity ()

				if ent then
					-- set owner if not a monster
					if owner:len () > 0 and ent.type ~= "monster" then
						ent.owner = owner
						ent.tamed = true
					end
				end

				smob:set_velocity (vector.multiply (spawner_dir, force))
			end

			return smob, false
		end

		return nil, false
	end)



	lwcomponents.register_spawner (mob,
	function (spawn_pos, itemstack, owner, spawner_pos, spawner_dir, force)
		if minetest.registered_entities[mob] then
			local smob = minetest.add_entity (spawner_pos, mob)

			if smob then
				local ent = smob:get_luaentity ()

				if ent then
					-- set owner if not a monster
					if owner:len () > 0 and ent.type ~= "monster" then
						ent.owner = owner
						ent.tamed = true
					end
				end

				smob:set_velocity (vector.multiply (spawner_dir, force))
			end

			return smob, false
		end

		return nil, false
	end)

end



for mob, def in pairs (minetest.registered_craftitems) do
	if def and def.groups and def.groups.spawn_egg then
		register_spawner (mob)
	end
end


--[[ doesn't spawn if thrown against wall and kills chickens when hit
lwcomponents.register_spawner ("mobs:egg",
function (spawn_pos, itemstack, owner, spawner_pos, spawner_dir)
	if minetest.registered_entities["mobs_animal:egg_entity"] then
		local obj = minetest.add_entity (spawn_pos, "mobs_animal:egg_entity")
		local ent = obj and obj:get_luaentity ()

		if ent then
			ent.velocity = 25 -- needed for api internal timing
			ent.switch = 1 -- needed so that egg doesn't despawn straight away
			ent._is_arrow = true -- tell advanced mob protection this is an arrow

			obj:setacceleration({
				x = spawner_dir.x * -3,
				y = -9, -- egg_GRAVITY,
				z = spawner_dir.z * -3
			})

			-- set owner
			if owner:len () > 0 then
				ent.playername = owner
			end

			return obj, false
		end
	end

	return nil, false
end)
]]



lwcomponents.register_spawner ("mobs:egg",
function (spawn_pos, itemstack, owner, spawner_pos, spawner_dir, force)
	if math.random (1, 10) == 5 then
		if minetest.registered_entities["mobs_animal:chicken"] then
			local smob = minetest.add_entity (spawn_pos, "mobs_animal:chicken")

			if smob then
				local ent = smob:get_luaentity ()

				if ent then
					-- set owner if not a monster
					if owner:len () > 0 and ent.type ~= "monster" then
						ent.owner = owner
						ent.tamed = true
					end
				end

				smob:set_velocity (vector.multiply (spawner_dir, force))
			end

			return smob, false
		end
	end

	return nil, false
end)



end
