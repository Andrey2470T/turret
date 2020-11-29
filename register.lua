
-- REGISTRATIONS --

minetest.register_entity("turret:ray", {
    visual = "mesh",
    visual_size = {x=5, y=5, z=5},
    mesh = "ray_segment.b3d",
    textures = {"turret_ray.png"},
    collisionbox = {0, 0, 0, 0, 0, 0},
    glow = 10
}) 

minetest.register_entity("turret:fiery_dart", {
    visual = "mesh",
    visual_size = {x=25, y=25, z=25},
    physical = true,
    pointable = false,
    mesh = "fiery_dart.b3d",
    textures = {"turret_fiery_dart.png"},
    collisionbox = {-0.05, -0.05, -0.15, 0.05, 0.05, 0.15},
    selectionbox = {0, 0, 0, 0, 0, 0},
    glow = 15,
    on_step = function(self, dtime, moveresult)
        if moveresult.collides then
            local cols = moveresult.collisions
            
            for _, collision in ipairs(cols) do
                if collision.type == "object" then
                    collision.object:set_hp(collision.object:get_hp()-DAMAGE, "punch")
                end
            end
                                              
            self.object:remove()
        end
    end
})


minetest.register_node("turret:turret_off", {
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
        turret.spread_ray(pos, turret.get_turret_unitdir(pos))
        
        local timer = minetest.get_node_timer(pos)
        timer:start(0.1)
    end,
    on_destruct = function(pos)
        turret.delete_ray(pos)
    end,
    on_timer = function(pos, elapsed)
        --[[local ray_dir = minetest.deserialize(minetest.get_meta(pos):get_string("ray_dir"))
        local dir = turret.get_turret_unitdir(pos)
        if not target_objs[pos] and not vector.are_co_directional(dir, ray_dir) then
            turret.release(pos)
        end]]
                            
        turret.direct_ray_to_entity(pos)
                                        
        return true
    end
})


minetest.register_node("turret:turret_on", {
    description = "Turret",
    drawtype = "mesh",
    mesh = "turret_unfold2.b3d",
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
    drop = "turret:turret_off",
    groups = {cracky=2, not_in_creative_inventory=1},
    sounds = default.node_sound_metal_defaults(),
    on_construct = function(pos)
        turret.spread_ray(pos, turret.get_turret_unitdir(pos))
        
        local timer = minetest.get_node_timer(pos)
        timer:start(0.1)
    end,
    on_destruct = function(pos)
        turret.delete_ray(pos)
    end,
    on_timer = function(pos, elapsed)
        local ray_dir = minetest.deserialize(minetest.get_meta(pos):get_string("ray_dir"))
        local dir = turret.get_turret_unitdir(pos)
        if not target_objs[minetest.pos_to_string(pos)] and not vector.are_co_directional(dir, ray_dir) then
            minetest.debug("Release!")
            turret.release(pos)
        end
                            
        turret.direct_ray_to_entity(pos)
                                        
        return true
    end
})

minetest.register_craftitem("turret:turret_eye", {
    description = "Turret Eye",
    inventory_image = "turret_eye.png"
})

minetest.register_craftitem("turret:red_led", {
    description = "Red LED",
    inventory_image = "red_led.png"
}) 
