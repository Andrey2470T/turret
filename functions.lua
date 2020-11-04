turret.spread_ray = function(pos, rot)
    rot = rot or {x=0, y=0, z=0}
    local node = minetest.get_node(pos)
    local u_dir_vec = vector.rotate(minetest.facedir_to_dir(node.param2), {x=0, y=math.rad(180), z=0})
    
    pos = vector.add(pos, {x=0, y=0.175, z=0})
    
    --[[local nearby_objs = minetest.get_objects_inside_radius(pos, 20)
    local hit_objs = {}
    
    for _, obj in ipairs(nearby_objs) do
        local self = obj:get_luaentity()
        
        local view_ang = vector.angle(pos, obj:get_pos())
        if minetest.registered_entities[self.name].physical and self.name ~= "turret:ray" and view_ang <= math.rad(45) then
            hit_objs[#hit_objs+1] = obj
        end
    end
    
    local rand_obj = hit_objs[math.random(1, #hit_objs)]]
    
    local ray_segments_list = {}
    
    local ray_seg = minetest.add_entity(pos, "turret:ray")
    ray_seg:set_properties({textures = {"turret_ray_seg.png"}})
    
    local ang = vector.angle(u_dir_vec, {x=1, y=0, z=0})
    if vector.length(rot) ~= 0 then
        ray_seg:set_rotation({x=rot.x, y=rot.y+ang, z=rot.z})
    else
        ray_seg:set_yaw(ang)
    end
    ray_segments_list[#ray_segments_list+1] = pos
    
    local next_pos = {x=u_dir_vec.x*math.cos(rot.y) - u_dir_vec.z*math.sin(rot.y),
                      y=u_dir_vec.y,
                      z=u_dir_vec.z*math.cos(rot.y) + u_dir_vec.x*math.sin(rot.y)
                     }
    
    next_pos.x = next_pos.x*math.cos(rot.z) - u_dir_vec.y*math.sin(rot.z)
    next_pos.y = next_pos.y*math.cos(rot.z) + u_dir_vec.x*math.sin(rot.z)
    
    next_pos = vector.add(pos, next_pos)
    local node = minetest.get_node(next_pos)
    
    local counter = 1
    while node.name == "air" do
        if counter > 100 then
            return true
        end
        
        local obj = minetest.add_entity(next_pos, "turret:ray")
        
        if vector.length(rot) ~= 0 then
            obj:set_rotation({x=rot.x, y=rot.y+ang, z=rot.z})
        else
            obj:set_yaw(ang)
        end
        ray_segments_list[#ray_segments_list+1] = next_pos
        
        counter = counter + 1
        next_pos = {x=u_dir_vec.x*counter*math.cos(rot.y) - u_dir_vec.z*counter*math.sin(rot.y),
                      y=u_dir_vec.y*counter,
                      z=u_dir_vec.z*counter*math.cos(rot.y) + u_dir_vec.x*counter*math.sin(rot.y)
                   }
        
        next_pos.x = next_pos.x*math.cos(rot.z) - u_dir_vec.y*math.sin(rot.z)
        next_pos.y = next_pos.y*math.cos(rot.z) + u_dir_vec.x*math.sin(rot.z)
        
        next_pos = vector.add(pos, next_pos)
        node = minetest.get_node(next_pos)
    end
    
    local meta = minetest.get_meta(pos)
    meta:set_string("ray_segments_list", minetest.serialize(ray_segments_list))
    return true
end

turret.delete_ray = function(pos)
    local meta = minetest.get_meta(pos)
    local ray_seg_l = minetest.deserialize(meta:get_string("ray_segments_list"))
    
    for _, ray_seg in ipairs(ray_seg_l) do
        local ray = minetest.get_objects_inside_radius(ray_seg, 0.1)
        for _, obj in ipairs(ray) do
            if obj:get_luaentity().name == "turret:ray" then
                obj:remove()
            end
        
            break
        end
    end
end
