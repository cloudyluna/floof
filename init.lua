-- See README.md for licensing and other information.

local mod_name                  = core.get_current_modname()

-- File must be in `textures` directory.
local SMOKE_PLOOM_TEXTURE       = mod_name .. "_smoke.png"
local FIRE_TEXTURE              = mod_name .. "_fire.png"
local TUNG_TREE_LEAVES_TEXTURE  = mod_name .. "_tree_leaves.png"
local CLOUD_OF_PENDULUM_TEXTURE = mod_name .. "_cloud_of_pendulum.png^[makealpha:50,50,50"

local function spawn_particles_on(pos)
    local smoke_definition = {
        amount = 2,
        time = 3,
        texture = SMOKE_PLOOM_TEXTURE,
        minsize = 2,
        maxsize = 4,
        vertical = true,
        object_collision = true,
        collisiondetection = true,
        collision_removal = true,
        maxacc = { x = 0, y = 0.2, z = 0 },
        minexptime = 0.6,
        maxexptime = 3,
        minvel = { x = 0, y = 0, z = 0 },
        maxvel = { x = 0, y = 0.1, z = 0 },
        animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 0.9
        },
        minpos = { x = pos.x - 0.1, y = pos.y + 0.4, z = pos.z - 0.1 },
        maxpos = { x = pos.x + 0.2, y = pos.y + 1, z = pos.z + 0.2 },
    }

    -- FIXME: Emit light.
    local fire_definition = {
        amount = 2,
        time = 1,
        texture = FIRE_TEXTURE,
        minsize = 2,
        maxsize = 4,
        vertical = true,
        glow = 14,
        object_collision = true,
        collisiondetection = true,
        collision_removal = true,
        maxacc = { x = 0, y = 0.2, z = 0 },
        minexptime = 0.6,
        maxexptime = 1,
        minvel = { x = 0, y = 0, z = 0 },
        maxvel = { x = 0, y = 0.1, z = 0 },
        animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 0.7
        },
        minpos = { x = pos.x - 0.1, y = pos.y + 0.6, z = pos.z - 0.1 },
        maxpos = { x = pos.x + 0.2, y = pos.y + 0.8, z = pos.z + 0.2 },
    }

    local node_above = minetest.get_node({ x = pos.x, y = pos.y + 1, z = pos.z }).name

    if node_above == "air" then
        minetest.add_particlespawner(smoke_definition)
        minetest.add_particlespawner(fire_definition)
    end
end

minetest.register_abm({
    name = mod_name .. ":spawn_fire_and_smoke_particles",
    nodenames = { mod_name .. ":tung_tree_leaves" },
    interval = 0,
    chance = 10,
    action = function(pos, node)
        spawn_particles_on(pos)
    end
})


-- Item
core.register_node(mod_name .. ":tung_tree_leaves", {
    description = "Tung Tree Leaves",
    tiles = { TUNG_TREE_LEAVES_TEXTURE },
    drawtype = "allfaces_optional",
    sunlight_propagates = true,
    walkable = true,
    light_source = core.LIGHT_MAX - 8,
    waving = 2,
    groups = { snappy = 3 }
})


core.register_node(mod_name .. ":cloud_of_pendulum", {
    description = "Cloud of Pendulum",
    tiles = { CLOUD_OF_PENDULUM_TEXTURE },
    drawtype = "glasslike",
    sunlight_propagates = true,
    walkable = true,
    groups = {
        oddly_breakable_by_hand = 3,
        fall_damage_add_percent = -100,
        bouncy = -100
    }
})

core.register_on_generated(
    function(minp, maxp, seed)
        local rand = PseudoRandom(seed)

        local cloud_blobs_per_chunk = 8
        for chunk = 1, cloud_blobs_per_chunk do
            do
                local min_height = 80
                local max_height = 250
                local x = rand:next(minp.x, maxp.x)
                local y = rand:next(min_height, max_height)
                local z = rand:next(minp.z, maxp.z)

                local rad_x = rand:next(2, 21)
                local rad_y = rand:next(1, 2)
                local rad_z = rand:next(2, 21)

                for direction_x = -rad_x, rad_x do
                    for direction_y = -rad_y, rad_y do
                        for direction_z = -rad_z, rad_z do
                            local distance =
                                (direction_x * direction_x) / (rad_x * rad_x)
                                + (direction_y * direction_y) / (rad_y * rad_y)
                                + (direction_z * direction_z) / (rad_z * rad_z)

                            local spawn_chance = 20
                            if distance <= 1 then
                                if rand:next(1, 100) < spawn_chance then
                                    local pos = { x = x + direction_x, y = y + direction_y, z = z + direction_z }
                                    if minetest.get_node(pos).name == "air" then
                                        minetest.set_node(pos, { name = mod_name .. ":cloud_of_pendulum" })
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
