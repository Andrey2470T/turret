
-- CRAFTINGS --

if minetest.get_modpath("basic_materials") then
    minetest.register_craft({
        output = "turret:turret_off",
        recipe = {
            {"basic_materials:plastic_sheet", "basic_materials:ic", "basic_materials:steel_bar"},
            {"basic_materials:plastic_sheet", "turret:turret_eye", "basic_materials:steel_bar"},
            {"basic_materials:plastic_sheet", "dye:black", "basic_materials:steel_bar"}
        }
    })
    
    minetest.register_craft({
        type = "shapeless",
        output = "turret:red_led",
        recipe = {"basic_materials:silicon", "basic_materials:plastic_sheet", "dye:red"}
    })
elseif minetest.get_modpath("luxury_decor") then
    minetest.register_craft({
        output = "turret:turret_off",
        recipe = {
            {"luxury_decor:plastic_sheet", "default:steelblock", "luxury_decor:brass_stick"},
            {"luxury_decor:plastic_sheet", "turret:turret_eye", "luxury_decor:brass_stick"},
            {"luxury_decor:plastic_sheet", "dye:black", "luxury_decor:brass_stick"}
        }
    })
    
    minetest.register_craft({
        type = "shapeless",
        output = "turret:red_led",
        recipe = {"luxury_decor:wolfram_wire_reel", "luxury_decor:plastic_sheet", "dye:red"}
    })
else
    error("From 'turret' mod: No one required dependency is avaialble!")
end

minetest.register_craft({
    output = "turret:turret_eye",
    recipe = {
        {"turret:red_led", "turret:red_led", "turret:red_led"},
        {"turret:red_led", "xpanes:pane_flat", "turret:red_led"},
        {"turret:red_led", "turret:red_led", "turret:red_led"}
    }
}) 
