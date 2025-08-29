-- Minetest mod: leaves_burning_particles forked from more_particles
-- See README.md for licensing and other information.

local PARTICLE_AMOUNT = 2;
local SPAWN_INTERVAL = 5;
local PARTICLE_MOVEMENT_SPEED = 4;
local PARTICLE_EXPIRED_TIME = 1;
local SMOKE_PARTICLE_TEXTURE = "smoke.png";

local particle_definitions = {
    ["group:leaves"] = {
        checker = function(pos)
            local pos_above = vector.offset(pos, 0, 1, 0)
            local node_above = minetest.get_node(pos_above)
            if (node_above.name == "air") then
                return true
            else
                return false
            end
        end,

    }
}

local scan_box = vector.new(32, 8, 32)
local wind_direction = { x = 0, y = 0 } -- TODO: Apply effect.

local players = {}
minetest.register_on_joinplayer(
    function(player, _)
        table.insert(players, player:get_player_name())
    end
)

local function update_particles()
    -- Show to all players.
    for _, player in pairs(players) do
        local new_player_obj = minetest.get_player_by_name(player)
        if (new_player_obj == nil) then break end
        local new_pos = new_player_obj:get_pos()
        local rounded_pos = vector.new(
            math.floor(new_pos["x"]),
            math.floor(new_pos["y"]),
            math.floor(new_pos["z"])
        )
        local blocks = minetest.find_nodes_in_area(
            rounded_pos - scan_box,
            rounded_pos + scan_box,
            "group:leaves")
        for _, lpos in pairs(blocks) do
            local lnode = minetest.get_node(lpos)
            local lpos_above = vector.offset(lpos, 0, 1, 0)
            local lnode_above = minetest.get_node(lpos_above)
            if (lnode_above.name == "air") then
                minetest.add_particlespawner({
                    amount = PARTICLE_AMOUNT,
                    time = SPAWN_INTERVAL,
                    node = { name = lnode.name },
                    object_collision = true,
                    collisiondetection = true,
                    collision_removal = true,
                    exptime = PARTICLE_EXPIRED_TIME,
                    texture = SMOKE_PARTICLE_TEXTURE,
                    playername = player,
                    pos = {
                        min = vector.offset(lpos_above, -0.5, 0.45, -0.5),
                        max = vector.offset(lpos_above, 0.5, 0.4, 0.5),
                    },
                    vel = vector.new(0, 0, 0),
                    acc = {
                        x = 0.5 + math.random(-1, 1),
                        y = PARTICLE_MOVEMENT_SPEED,
                        z = 0.5 + math.random(-1, 1)
                    },
                })
            end
        end
    end
    minetest.after(5, update_particles)
end

minetest.after(0.2, update_particles)
