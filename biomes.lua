local util = dofile(core.get_modpath(core.get_current_modname()) .. "/util.lua")
local assets = util.require("assets")
local entities = util.require("entities")

-- The cloud block is bouncy from all sides. This enable
-- player to collect the blocks and build bouncy structures,
-- say a bouncy castle.
core.register_node(entities.PENDULUM.CLOUD, {
    description = "Cloud of Pendulum",
    tiles = { assets.PENDULUM.TEXTURES.CLOUD },
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

                        if current_biome_name ~= nil and current_biome_name == entities.TUNG.BIOMES.TUNG_FOREST then
                            if core.get_node(pos).name == "air" then
                                core.set_node(pos, { name = entities.PENDULUM.CLOUD })
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
                    height = rand:next(40, 160),
                    depth = rand:next(minp.z, maxp.z)
                },
                {
                    x = rand:next(2, 21),
                    y = rand:next(1, 4),
                    z = rand:next(2, 20)
                })
        end
    end)

core.register_decoration({
    name = entities.TUNG.TREE,
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
    schematic = assets.TUNG.SCHEMATICS.TREE,
    flags = "place_center_x, place_center_z",
    rotation = "random",
    biomes = {
        entities.TUNG.BIOMES.TUNG_FOREST
    },
})

core.register_biome({
    name = entities.TUNG.BIOMES.TUNG_FOREST,
    node_top = "default:dirt_with_grass",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    y_min = 1,
    y_max = 31000,
    heat_point = 50,
    humidity = 50,
})
