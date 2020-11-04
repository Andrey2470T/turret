turret = {}

local modpath = minetest.get_modpath("turret")

dofile(modpath .. "/functions.lua")

minetest.register_entity("turret:ray", {
    visual = "upright_sprite",
    visual_size = {x=1, y=0.25, z=1},
    textures = {"turret_ray.png"},
    collisionbox = {0, 0, 0, 0, 0, 0},
    glow = 10
}) 


minetest.register_node("turret:turret", {
    description = "Turret",
    drawtype = "mesh",
    mesh = "turret2.b3d",
    tiles = {"turret.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    collision_box = {
        type = "fixed",
        fixed = {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4}
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4}
    },
    groups = {cracky=2},
    sounds = default.node_sound_metal_defaults(),
    on_construct = function(pos)
        turret.spread_ray(pos)
        
        local timer = minetest.get_node_timer(pos)
        timer:start(0.1)
    end,
    on_destruct = function(pos)
        turret.delete_ray(pos)
    end,
    on_timer = function(pos, elapsed)
        turret.delete_ray(pos)
        turret.spread_ray(pos)
                            
        return true
    end
})
