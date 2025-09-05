local util = dofile(core.get_modpath(core.get_current_modname()) .. "/util.lua")
local assets = util.require("assets")
local entities = util.require("entities")

local items = {}

core.register_node(entities.TUNG.ORE, {
    description = "Tung Ore",
    tiles = { assets.TUNG.TEXTURES.ORE },
    is_ground_content = true,
    groups = { cracky = 3, stone = 1 },
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
    ore_type       = "scatter",
    ore            = entities.TUNG.ORE,
    wherein        = "default:stone",
    clust_scarcity = 13 * 13 * 13,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
})

minetest.register_ore({
    ore_type       = "scatter",
    ore            = entities.TUNG.ORE,
    wherein        = "default:stone",
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = -64,
    y_min          = -255,
})

minetest.register_ore({
    ore_type       = "scatter",
    ore            = entities.TUNG.ORE,
    wherein        = "default:stone",
    clust_scarcity = 13 * 13 * 13,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -256,
    y_min          = -31000,
})



core.register_craftitem(entities.TUNG.INGOT, {
    description = "Tung Ingot",
    inventory_image = assets.TUNG.TEXTURES.INGOT,
})

core.register_tool(entities.TUNG.PICKAXE, {
    description       = "Tung Pickaxe",
    inventory_image   = assets.TUNG.TEXTURES.PICKAXE,
    tool_capabilities = {
        full_punch_interval = 1.5,
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                maxlevel = 2,
                uses = 20,
                times = { [1] = 0.45, [2] = 0.35, [3] = 0.25 }
            },
        },
        damage_groups = {
            fleshy = 2
        }
    },
    sound             = { breaks = "default_tool_breaks" },
    groups            = { pickaxe = 1, flammable = 2, tung_tool = 1 }
})

core.register_tool(entities.TUNG.AXE, {
    description       = "Tung Axe",
    inventory_image   = assets.TUNG.TEXTURES.AXE,
    tool_capabilities = {
        full_punch_interval = 1.5,
        max_drop_level = 1,
        groupcaps = {
            choppy = {
                maxlevel = 2,
                uses = 20,
                times = { [1] = 0.50, [2] = 0.40, [3] = 0.30 }
            },
        },
        damage_groups = {
            fleshy = 2
        }
    },
    sound             = { breaks = "default_tool_breaks" },
    groups            = { axe = 1, flammable = 2, tung_tool = 1 }
})


core.register_tool(entities.TUNG.SHOVEL, {
    description       = "Tung Shovel",
    inventory_image   = assets.TUNG.TEXTURES.SHOVEL,
    tool_capabilities = {
        full_punch_interval = 1.5,
        max_drop_level = 1,
        groupcaps = {
            crumbly = {
                maxlevel = 2,
                uses = 20,
                times = { [1] = 0.5, [2] = 0.10, [3] = 0.15 }
            },
        },
        damage_groups = {
            fleshy = 2
        }
    },
    sound             = { breaks = "default_tool_breaks" },
    groups            = { shovel = 1, flammable = 2, tung_tool = 1 }
})

core.register_craft({
    type = "shaped",
    output = entities.TUNG.PICKAXE .. " 1",
    recipe = {
        { entities.TUNG.INGOT, entities.TUNG.INGOT, entities.TUNG.INGOT },
        { "",                  "default:stick",     "" },
        { "",                  "default:stick",     "" }
    }
})


core.register_craft({
    type = "shaped",
    output = entities.TUNG.AXE .. " 1",
    recipe = {
        { entities.TUNG.INGOT, entities.TUNG.INGOT, "" },
        { entities.TUNG.INGOT, "default:stick",     "" },
        { "",                  "default:stick",     "" }
    }
})

core.register_craft({
    type = "shaped",
    output = entities.TUNG.SHOVEL .. " 1",
    recipe = {
        { "", entities.TUNG.INGOT, "" },
        { "", "default:stick",     "" },
        { "", "default:stick",     "" }
    }
})

core.register_craft({
    type = "cooking",
    output = entities.TUNG.INGOT,
    recipe = entities.TUNG.ORE,
    cooktime = 30
})

return items
