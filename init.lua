turret = {}

local modpath = minetest.get_modpath("turret")

dofile(modpath .. "/functions.lua")

minetest.register_entity("turret:ray", {
    visual = "mesh",
    visual_size = {x=5, y=5, z=5},
    mesh = "ray_segment.b3d",
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
        --[[local node = minetest.get_node(pos)
        local unit_dir = vector.rotate(minetest.facedir_to_dir(node.param2), {x=0, y=math.rad(180), z=0})]]
        --[[turret.spread_ray(pos, unit_dir, {x=0, y=1, z=0})
        local random_pos = {x=0, y=-2.0, z=13.4}
        minetest.debug("angle_to_target: " .. math.deg(vector.angle(unit_dir, random_pos)))
        local axis = vector.rotate(unit_dir, {x=0, y=math.pi/2, z=0})
        minetest.debug("angle: " .. math.deg(vector.angle(unit_dir, axis)))]]
        --turret.spread_ray(pos, unit_dir, axis, math.rad(-45))--math.asin(vector.length(axis)/(vector.length(unit_dir)*vector.length(random_pos))))
        --[[local found_objs = minetest.get_objects_inside_radius(pos, 20)
        
        local nearby_players = {}
        if found_objs then
            for _, obj in ipairs(found_objs) do
                if obj:is_player() then
                    nearby_players[#nearby_players+1] = obj
                end
            end
            
            if #nearby_players ~= 0 then
                local random_tplayer = nearby_players[math.random(1, #nearby_players)]
                local rel_pos = vector.subtract(random_tplayer:get_pos(), pos)
                                        
                local axis = vector.cross(rel_pos, unit_dir)
                local new_unit_dir = vector.rotate_around_axis(unit_dir, axis, vector.angle(unit_dir, rel_pos))
                
                local ray_segments_list = {}
                local ray_seg = minetest.add_entity(pos, "turret:ray")
                ray_seg:set_properties({textures = {"turret_ray_seg.png"}})]]
                
                --[[local target_unit_dir_yaw = minetest.dir_to_yaw(new_unit_dir)
                --new_unit_dir = vector.rotate(new_unit_dir, {x=0, y=1, z=0}, -target_unit_dir_yaw)
                minetest.debug("length1: " .. vector.length({x=new_unit_dir.x, y=0, z=new_unit_dir.z}))
                minetest.debug("length2: " .. vector.length({x=new_unit_dir.x, y=new_unit_dir.y, z=0}))
                local pitch = math.acos(vector.length({x=new_unit_dir.x, y=0, z=new_unit_dir.z})/vector.length({x=new_unit_dir.x, y=new_unit_dir.y, z=new_unit_dir.z}))
                minetest.debug("pitch: " .. pitch)]]
                --new_unit_dir = vector.rotate(new_unit_dir, {x=0, y=1, z=0}, target_unit_dir_yaw)
                --ray_seg:set_rotation({x=pitch, y=target_unit_dir_yaw, z=0})
                
                --ray_seg:set_rotation({x=new_dir_rot.x, y=new_dir_rot.y+math.pi/2, z=new_dir_rot.z})
                
                --[[ray_segments_list[#ray_segments_list+1] = pos
                
                local ray_seg2 = minetest.add_entity(pos, "turret:ray")
                ray_seg2:set_properties({textures = {"turret_ray_seg.png"}})
                --ray_seg2:set_rotation({x=pitch, y=target_unit_dir_yaw+math.pi/2, z=0})
                --ray_seg2:set_rotation({x=new_dir_rot.x, y=new_dir_rot.y+math.pi/2, z=new_dir_rot.z+math.pi/2})
                ray_segments_list[#ray_segments_list+1] = pos
                                        
                local new_dir_rot = vector.dir_to_rotation(new_unit_dir, axis)
                
                if vector.angle(unit_dir, {x=0, y=0, z=1}) == 0 or vector.angle(unit_dir, {x=0, y=0, z=1}) == math.pi then
                    ray_seg:set_yaw(math.pi/2)
                                        
                    ray_seg2:set_yaw(math.pi/2)
                end
                                        
                local ray_cur_rot = ray_seg:get_rotation()
                local ray2_cur_rot = ray_seg2:get_rotation()
                
                ray_seg:set_rotation(vector.add(ray_cur_rot, new_dir_rot))
                ray_seg2:set_rotation(vector.add(ray2_cur_rot, new_dir_rot))
                    
                local counter = 1
                local next_pos = vector.add(pos, new_unit_dir)
                local node = minetest.get_node(next_pos)
    
                while node.name == "air" do
                    local next_obj = minetest.add_entity(next_pos, "turret:ray")
        
                    --next_obj:set_yaw(minetest.dir_to_yaw(unit_dir)+math.pi/2)
                    --next_obj:set_rotation({x=pitch, y=target_unit_dir_yaw, z=0})
                    --next_obj:set_rotation(new_dir_rot)
                    ray_segments_list[#ray_segments_list+1] = next_pos
                    
                    local next_obj2 = minetest.add_entity(next_pos, "turret:ray")
                    --next_obj2:set_rotation({x=pitch, y=target_unit_dir_yaw+math.pi/2, z=0})
                    --next_obj2:set_rotation({x=new_dir_rot.x, y=new_dir_rot.y, z=new_dir_rot.z+math.pi/2})
                    ray_segments_list[#ray_segments_list+1] = next_pos
                    
                    if vector.angle(unit_dir, {x=0, y=0, z=1}) == 0 or vector.angle(unit_dir, {x=0, y=0, z=1}) == math.pi then
                        next_obj:set_yaw(math.pi/2)
                                        
                        next_obj2:set_rotation({x=0, y=math.pi/2, z=math.pi/2})
                    end
                                        
                    local nobj_cur_rot = next_obj:get_rotation()
                    local nobj2_cur_rot = next_obj2:get_rotation()
                
                    next_obj:set_rotation(vector.add(nobj_cur_rot, new_dir_rot))
                    next_obj2:set_rotation(vector.add(nobj2_cur_rot, new_dir_rot))
                                        
                    counter = counter + 1
        
                    next_pos = vector.add(pos, vector.multiply(new_unit_dir, counter))
                    node = minetest.get_node(next_pos)
                end
                                        
                local meta = minetest.get_meta(pos)
                meta:set_string("ray_segments_list", minetest.serialize(ray_segments_list))
            end
        end]]
    
    --[[local meta = minetest.get_meta(pos)
    meta:set_string("ray_segments_list", minetest.serialize(ray_segments_list))
            
        local axis = vector.rotate(unit_dir, {x=0, y=math.pi/2, z=0})
        local new_unit_dir = vector.rotate_around_axis(unit_dir, axis, math.rad(-45))
                                        
        local ray_segments_list = {}
        local ray_seg = minetest.add_entity(pos, "turret:ray")
        ray_seg:set_properties({textures = {"turret_ray_seg.png"}})
        --ray_seg:set_yaw(minetest.dir_to_yaw(unit_dir)+math.pi/2)
        ray_seg:set_rotation({x=0, y=minetest.dir_to_yaw(unit_dir)+math.pi/2, z=math.rad(-45)})
                                        
        ray_segments_list[#ray_segments_list+1] = pos
                                        
        local counter = 1
        local next_pos = vector.add(pos, new_unit_dir)
        local node = minetest.get_node(next_pos)
    
        while node.name == "air" do
            local next_obj = minetest.add_entity(next_pos, "turret:ray")
        
            --next_obj:set_yaw(minetest.dir_to_yaw(unit_dir)+math.pi/2)
            next_obj:set_rotation({x=0, y=minetest.dir_to_yaw(unit_dir)+math.pi/2, z=math.rad(-45)})
            ray_segments_list[#ray_segments_list+1] = next_pos
        
            counter = counter + 1
        
            next_pos = vector.add(pos, vector.multiply(new_unit_dir, counter))
            node = minetest.get_node(next_pos)
    end
    
    local meta = minetest.get_meta(pos)
    meta:set_string("ray_segments_list", minetest.serialize(ray_segments_list))]]
        
        
        
        --[[local timer = minetest.get_node_timer(pos)
        timer:start(1)]]
                                        
        --[[local found_objs = minetest.get_objects_inside_radius(pos, 20)
        local nearby_players = {}
        if found_objs then
            for _, obj in ipairs(found_objs) do
                if obj:is_player() then
                    nearby_players[#nearby_players+1] = obj
                end
            end
                                        
            local random_player = nearby_players[math.random(1, #nearby_players)]
                                        
            turret.spread_ray(pos, turret.get_turret_unitdir(pos), random_player:get_pos())
        end]]
        turret.spread_ray(pos, turret.get_turret_unitdir(pos))
        
        local timer = minetest.get_node_timer(pos)
        timer:start(0.05)
    end,
    on_destruct = function(pos)
        turret.delete_ray(pos)
    end,
    on_timer = function(pos, elapsed)
        local ray_dir = minetest.deserialize(minetest.get_meta(pos):get_string("ray_dir"))
        --minetest.debug("target_objs[pos]: " .. tostring(target_objs[pos]))
        --minetest.debug("angle: " .. math.deg(vector.angle(turret.get_turret_unitdir(pos), ray_dir)))
        local dir = turret.get_turret_unitdir(pos)
        dir.y = dir.y + 0.175
        if not target_objs[pos] and not vector.are_co_directional(dir, ray_dir) then
            --minetest.debug("turret.release():Returning to the original orientation...")
            turret.release(pos)
        end
                            
        turret.direct_ray_to_entity(pos)
                                        
        return true
    end
})
