local util = dofile(core.get_modpath(core.get_current_modname()) .. "/util.lua")
local assets = util.require("assets")
local entities = util.require("entities")

core.register_node(entities.TUNG.TREE_LEAVES, {
    description = "Tung Tree Leaves",
    tiles = { assets.TUNG.TEXTURES.TREE_LEAVES },
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
                rarity = 100,
                items  = { "default:coal_lump" }
            },
            {
                rarity = 50,
                items = { entities.TUNG.TREE_SAPLING },
            }
        }
    }
})


core.register_node(entities.TUNG.TREE, {
    description = "Tung Tree",
    tiles = {
        assets.TUNG.TEXTURES.TREE_INNER, assets.TUNG.TEXTURES.TREE_INNER, -- +Y, -Y
        assets.TUNG.TEXTURES.TREE_SIDE, assets.TUNG.TEXTURES.TREE_SIDE,   -- +X, -X
        assets.TUNG.TEXTURES.TREE_SIDE, assets.TUNG.TEXTURES.TREE_SIDE }, -- +Z, -Z
    groups = { tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2 },
    drop = {
        max_items = 1,
        items = {
            {
                rarity = 880,
                tool_groups = { "tung_tool" },
                items = {
                    "default:tree", entities.TUNG.ORE,
                    "default:diamond",
                    "default:gold_lump",

                }
            },
            {
                rarity = 420,
                tool_groups = { "tung_tool" },
                items = { "default:tree", entities.TUNG.ORE, "default:diamond", "default:coal_lump" }
            },
            {
                rarity = 350,
                tool_groups = { "tung_tool" },
                items = { "default:tree", entities.TUNG.ORE }
            },
            {
                rarity = 250,
                items = { "default:tree", "default:tree" }
            },
            {
                rarity = 1,
                items = { "default:tree" }
            }
        }
    },
    sounds = default.node_sound_wood_defaults()
})

default.register_leafdecay({
    trunks = { entities.TUNG.TREE },
    leaves = { entities.TUNG.TREE_LEAVES },
    radius = 3
})

core.register_node(entities.TUNG.TREE_SAPLING, {
    description = "Tung Tree Sapling",
    tiles = { assets.TUNG.TEXTURES.TREE_SAPLING },
    drawtype = "plantlike",
    inventory_image = assets.TUNG.TEXTURES.TREE_SAPLING,
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
    core.place_schematic({
            x = pos.x - 2,
            y = pos.y,
            z = pos.z - 2
        },
        assets.TUNG.SCHEMATICS.TREE,
        "random",
        nil,
        false)
end

if util.table_contains(util.enabled_mods, "bonemeal") then
    bonemeal:add_sapling({
        { entities.TUNG.TREE_SAPLING, grow_tung_tree, "soil" }
    })
end

default.register_sapling_growth(entities.TUNG.TREE_SAPLING, {
    can_grow       = default.can_grow,
    on_grow_failed = default.on_grow_failed,
    grow           = grow_tung_tree,
})

local function generate_smoke_particles(pos)
    local smoke_definition = {
        amount = 2,
        time = 3,
        texture = assets.EFFECTS.TEXTURES.SMOKE,
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
        minpos = { x = pos.x - 0.1, y = pos.y + 0.6, z = pos.z - 0.1 },
        maxpos = { x = pos.x + 0.2, y = pos.y + 1.2, z = pos.z + 0.2 },
    }

    local node_above = core.get_node({ x = pos.x, y = pos.y + 1, z = pos.z }).name

    if node_above == "air" then
        core.add_particlespawner(smoke_definition)
    end
end

local function generate_fire_particles(pos)
    local fire_definition = {
        amount = 1,
        time = 1,
        texture = assets.EFFECTS.TEXTURES.FIRE,
        minsize = 2,
        maxsize = 4,
        vertical = true,
        glow = core.LIGHT_MAX,
        object_collision = true,
        collisiondetection = true,
        collision_removal = true,
        maxacc = { x = 0, y = 0.2, z = 0 },
        minexptime = 0.6,
        maxexptime = 0.9,
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

    local node_above = core.get_node({ x = pos.x, y = pos.y + 1, z = pos.z }).name

    if node_above == "air" then
        core.add_particlespawner(fire_definition)
    end
end


core.register_abm({
    name = util.modname .. ":generate_fire_particles",
    nodenames = { entities.TUNG.TREE_LEAVES },
    interval = 0,
    chance = 15,
    action = generate_fire_particles
})

core.register_abm({
    name = util.modname .. ":generate_smoke_particles",
    nodenames = { entities.TUNG.TREE_LEAVES },
    interval = 1,
    chance = 20,
    action = generate_smoke_particles
})
