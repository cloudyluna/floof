local util = dofile(core.get_modpath(core.get_current_modname()) .. "/util.lua")

local function texture(texture_filename)
    local texture_string = util.modname .. "_" .. texture_filename .. ".png"

    assert(texture_string ~= nil, texture_filename .. " path is invalid!")
    return texture_string
end

local assets = {
    EFFECTS = {
        TEXTURES = {
            FIRE = texture("effects_fire"),
            SMOKE = texture("effects_smoke"),
        }
    },
    PENDULUM = {
        TEXTURES = {
            CLOUD = texture("pendulum_cloud"),
        }
    },
    TUNG = {
        TEXTURES = {
            TREE_INNER = texture("tung_tree_inner"),
            TREE_SIDE = texture("tung_tree_side"),
            -- FIXME: Use consistent path.
            TREE_LEAVES = texture("tung_tree_leaves"),
            TREE_SAPLING = texture("tung_tree_sapling"),
            ORE = texture("tung_ore"),
            INGOT = texture("tung_ingot"),
            PICKAXE = texture("tung_pickaxe"),
            AXE = texture("tung_axe"),
            SHOVEL = texture("tung_shovel")
        },
        SCHEMATICS = {
            TREE = util.modpath .. "/schematics/" .. util.modname .. "_tung_tree.mts"
        }
    }

}

return assets
