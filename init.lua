-- See README.md for licensing and other information.

local mod_name                  = core.get_current_modname()
local mod_path                  = core.get_modpath(mod_name)
local enabled_mods              = core.get_modnames()
local BIOMES                    = { tung_forest = "tung_forest" }

-- File must be in `textures` directory.
local SMOKE_PLOOM_TEXTURE       = mod_name .. "_smoke.png"
local FIRE_TEXTURE              = mod_name .. "_fire.png"
local TUNG_TREE_LEAVES_TEXTURE  = mod_name .. "_tree_leaves.png"
local TUNG_TREE_SAPLING_TEXTURE = mod_name .. "_tree_sapling.png"
local TUNG_TREE_SCHEMATIC_PATH  = mod_path .. "/schematics/" .. mod_name .. "_tung_tree.mts"
local CLOUD_OF_PENDULUM_TEXTURE = mod_name .. "_cloud_of_pendulum.png"


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

    local fire_definition = {
        amount = 2,
        time = 1,
        texture = FIRE_TEXTURE,
        minsize = 2,
        maxsize = 4,
        vertical = true,
        glow = core.LIGHT_MAX,
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

core.register_node(mod_name .. ":tung_tree_sapling", {
    description = "Tung Tree Sapling",
    tiles = { TUNG_TREE_SAPLING_TEXTURE },
    drawtype = "plantlike",
    inventory_image = TUNG_TREE_SAPLING_TEXTURE,
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    on_timer = nil,
    selection_box = {
        type = "fixed",
        fixed = { -4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16 }
    },
    groups = {
        snappy = 2,
        dig_immediate = 3,
        flammable = 2,
        attached_node = 1,
        sapling = 1
    },
    sounds = default.node_sound_leaves_defaults(),
})

local function grow_tung_tree(pos)
    core.remove_node(pos) -- Remove the planted tree sapling first.
    minetest.place_schematic({
            x = pos.x - 2,
            y = pos.y,
            z = pos.z - 2
        }, TUNG_TREE_SCHEMATIC_PATH, "random", nil,
        false)
end

default.register_sapling_growth(mod_name .. ":tung_tree_sapling", {
    can_grow       = default.can_grow,
    on_grow_failed = default.on_grow_failed,
    grow           = grow_tung_tree,
})

core.register_node(mod_name .. ":tung_tree_leaves", {
    description = "Tung Tree Leaves",
    tiles = { TUNG_TREE_LEAVES_TEXTURE },
    drawtype = "allfaces_optional",
    sunlight_propagates = true,
    walkable = true,
    light_source = core.LIGHT_MAX - 10,
    waving = 2,
    groups = { snappy = 3, leafdecay = 3, flammable = 2, leaves = 1 },
    drop = {
        max_items = 1,
        items = {
            {
                items = { mod_name .. ":tung_tree_sapling" },
                rarity = 20,
            },
            {
                items = { mod_name .. ":tung_tree_leaves" },
            }
        }
    }
})

default.register_leafdecay({
    trunks = { "default:tree" },
    leaves = { mod_name .. ":tung_tree_leaves" },
    radius = 7
})

local function table_contains(tbl, x)
    local found = false
    for _, v in pairs(tbl) do
        if v == x then
            found = true
        end
    end
    return found
end

if table_contains(enabled_mods, "bonemeal") then
    bonemeal:add_sapling({
        { mod_name .. ":tung_tree_sapling", grow_tung_tree, "soil" }
    })
end

-- The cloud block is bouncy from all sides. This enable
-- player to collect the blocks and build bouncy structures,
-- say a bouncy castle.
core.register_node(mod_name .. ":cloud_of_pendulum", {
    description = "Cloud of Pendulum",
    tiles = { CLOUD_OF_PENDULUM_TEXTURE },
    drawtype = "glasslike",
    use_texture_alpha = "blend",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = true,
    groups = {
        oddly_breakable_by_hand = 3,
        fall_damage_add_percent = -100,
        bouncy = 100
    }
})

local function spawn_clouds_of_pendulum(rand, spawn_chance, volume, radius)
    for direction_x = -radius.x, radius.x do
        for direction_y = -radius.y, radius.y do
            for direction_z = -radius.z, radius.z do
                local distance =
                    (direction_x * direction_x) / (radius.x * radius.x)
                    + (direction_y * direction_y) / (radius.y * radius.y)
                    + (direction_z * direction_z) / (radius.z * radius.z)

                if distance <= 1 then
                    if rand:next(1, 100) < spawn_chance then
                        local pos = {
                            x = volume.width + direction_x,
                            y = volume.height + direction_y,
                            z = volume.depth + direction_z
                        }

                        local biome_id = core.get_biome_data(pos).biome
                        local current_biome_name = core.get_biome_name(biome_id)

                        if current_biome_name ~= nil and current_biome_name == BIOMES.tung_forest then
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

core.register_on_generated(
    function(minp, maxp, seed)
        local rand = PseudoRandom(seed)

        local cloud_blobs_per_chunk = 4
        for _ = 1, cloud_blobs_per_chunk do
            spawn_clouds_of_pendulum(rand,
                10,
                {
                    width = rand:next(minp.x, maxp.x),
                    height = rand:next(40, 140),
                    depth = rand:next(minp.z, maxp.z)
                },
                {
                    x = rand:next(2, 21),
                    y = rand:next(1, 4),
                    z = rand:next(2, 20)
                })
        end
    end)


core.register_biome({
    name = BIOMES.tung_forest,
    node_top = "default:dirt_with_grass",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    y_min = 1,
    y_max = 31000,
    heat_point = 50,
    humidity = 50,
})

core.register_decoration({
    name = mod_name .. ":tung_tree",
    deco_type = "schematic",
    place_on = "default:dirt_with_grass",
    sidelen = 16,
    -- This is the same generation noise for apple tree from "default".
    noise_params = {
        offset = 0.024,
        scale = 0.015,
        spread = { x = 250, y = 250, z = 250 },
        seed = 2,
        octaves = 3,
        persist = 0.66
    },
    y_min = 1,
    y_max = 31000,
    schematic = TUNG_TREE_SCHEMATIC_PATH,
    flags = "place_center_x, place_center_z",
    rotation = "random",
    biomes = {
        BIOMES.tung_forest,
    },
})
