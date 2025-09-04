local util = dofile(core.get_modpath(core.get_current_modname()) .. "/util.lua")

local function entity(name)
    return util.modname .. ":" .. name
end

local entities = {
    PENDULUM = {
        CLOUD = entity("pendulum_cloud"),
    },
    TUNG = {
        TREE = entity("tung_tree"),
        TREE_LEAVES = entity("tung_tree_leaves"),
        TREE_SAPLING = entity("tung_tree_sapling"),
        ORE = entity("tung_ore"),
        INGOT = entity("tung_ingot"),
        PICKAXE = entity("tung_pickaxe"),
        AXE = entity("tung_axe"),
        SHOVEL = entity("tung_shovel"),
        BIOMES = {
            TUNG_FOREST = "tung_forest"
        }
    }
}

return entities
