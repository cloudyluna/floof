-- See README.md for licensing and other information.

local PARTICLE_AMOUNT = 1
local SPAWN_INTERVAL = 1
local PARTICLE_EXPIRED_TIME = 5

-- File must be in textures directory.
local SMOKE_PARTICLE_TEXTURE = "smoke.png"

local function update_particles_on(pos)
    local meta = minetest.get_meta(pos)
    local id1 =
        minetest.add_particlespawner({
            amount = PARTICLE_AMOUNT,
            time = SPAWN_INTERVAL,
            exptime = PARTICLE_EXPIRED_TIME,
            texture = SMOKE_PARTICLE_TEXTURE,
            minsize = 2,
            maxsize = 4,
            vertical = true,
            object_collision = true,
            collisiondetection = true,
            collision_removal = true,
            maxacc = { x = 0, y = 0.5, z = 0 },
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
            minpos = { x = pos.x - 0.1, y = pos.y - 0.2, z = pos.z - 0.1 },
            maxpos = { x = pos.x + 0.2, y = pos.y + 0.4, z = pos.z + 0.2 },
        })

    meta:set_int("layer_1", id1)
end

local function update_particles_off(pos)
    local meta = minetest.get_meta(pos)
    local id1 = meta:get_int("layer_1")

    minetest.delete_particlespawner(id1)
end

minetest.register_abm({
    name = "leaves_burning_particles:update_particles",
    nodenames = { "group:leaves" },
    interval = 1.0,
    chance = 50,
    action = function(pos)
        update_particles_on(pos)
    end
})
