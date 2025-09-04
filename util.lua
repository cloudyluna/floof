local util        = {}

util.modname      = core.get_current_modname()
util.modpath      = core.get_modpath(util.modname)
util.enabled_mods = core.get_modnames()

function util.require(mod_path)
    return dofile(util.modpath .. "/" .. mod_path .. ".lua")
end

function util.table_contains(tbl, to_find)
    local found = false
    for _, v in pairs(tbl) do
        if v == to_find then
            found = true
        end
    end
    return found
end

return util
