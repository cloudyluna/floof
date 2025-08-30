-- See README.md for licensing and other information.

-- File must be in `textures` directory.
local SMOKE_PLOOM_TEXTURE = "smoke.png"
local FIRE_TEXTURE        = "fire.png"

local function spawn_particles_on(pos)
    minetest.add_particlespawner({
        amount = 3,
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
        maxexptime = 0.8,
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
    })


    minetest.add_particlespawner({
        amount = 2,
        time = 1,
        texture = FIRE_TEXTURE,
        minsize = 2,
        maxsize = 4,
        vertical = true,
        object_collision = true,
        collisiondetection = true,
        collision_removal = true,
        maxacc = { x = 0, y = 0.2, z = 0 },
        minexptime = 0.6,
        maxexptime = 0.8,
        minvel = { x = 0, y = 0, z = 0 },
        maxvel = { x = 0, y = 0.1, z = 0 },
        animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 0.7
        },
        minpos = { x = pos.x - 0.1, y = pos.y + 0.2, z = pos.z - 0.1 },
        maxpos = { x = pos.x + 0.2, y = pos.y + 1.0, z = pos.z + 0.2 },
    })
end

minetest.register_abm({
    name = "leaves_burning_particles:spawn_particles",
    nodenames = { "leaves_burning_particles:tung_leaf" },
    interval = 1.0,
    chance = 30,
    action = function(pos, node)
        spawn_particles_on(pos)
    end
})

-- Crafitem

-- Item
core.register_node("leaves_burning_particles:tung_leaf", {
    description = "Tung Leaf",
    sunlight_propagates = true,
    walkable = true,
    waving = 2,
    groups = { snappy = 3 }
})
