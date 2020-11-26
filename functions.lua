target_objs = {}
local ANGLE_SPEED_RELEASE   = 5    -- in degrees
local ANGLE_SPEED_DIRECT    = 15    -- in degrees

--[[turret.init_ray = function(pos)
    local dir = turret.get_turret_unitdir(pos)
    
    local yaw = 0
    
    if vector.angle(dir, {x=0, y=0, z=1}) == 0 or vector.angle(dir, {x=0, y=0, z=1}) == math.pi then
        yaw = math.pi/2
    end
    
    local next_pos = vector.new(pos.x, pos.y+0.175, pos.z)
    
    local ray_segments_list = {}
    
    local next_obj = minetest.add_entity(next_pos, "turret:ray")
    next_obj:set_properties({textures={"turret_ray_seg.png"}})
    next_obj:set_yaw(yaw)
    ray_segments_list[#ray_segments_list+1] = next_pos
    
    next_obj = minetest.add_entity(next_pos, "turret:ray")
    next_obj:set_properties({textures={"turret_ray_seg.png"}})
    next_obj:set_rotation({x=math.pi/2, y=yaw, z=0})
    ray_segments_list[#ray_segments_list+1] = next_pos
    
    
    next_pos = vector.add(next_pos, dir)
    local next_node = minetest.get_node(next_pos)
    
    while next_node.name == "air" do
        next_obj = minetest.add_entity(next_pos, "turret:ray")
        next_obj:set_yaw(yaw)
        ray_segments_list[#ray_segments_list+1] = next_pos
        
        next_obj = minetest.add_entity(next_pos, "turret:ray")
        next_obj:set_rotation({x=math.pi/2, y=yaw, z=0})
        ray_segments_list[#ray_segments_list+1] = next_pos
        
        
        next_pos = vector.add(next_pos, dir)
        next_node = minetest.get_node(next_pos)
    end
    
    local meta = minetest.get_meta(pos)
    meta:set_string("ray_segments_list", minetest.serialize(ray_segments_list))
end]]
    
turret.spread_ray = function(pos, target_dir)
    --pos.y = pos.y + 0.175
    target_dir = vector.normalize(target_dir)
    
    --[[local yaw = minetest.dir_to_yaw(new_ray_dir)+math.pi/2
    
    local pitch = math.acos(vector.length({x=new_ray_dir.x, y=0, z=new_ray_dir.z})/vector.length(new_ray_dir))
    
    local sign = new_ray_dir.y > 0 and -1 or 1
    pitch = pitch*sign]]

    
    local ray_segments_list = {}
    local ray_rot = vector.dir_to_rotation(target_dir)
    
    --local first_ray_seg_pos = vector.add(pos, vector.divide(target_dir, 4))
    local next_obj = minetest.add_entity(pos, "turret:ray")
    next_obj:set_properties({textures={"turret_ray_seg.png"}})
    next_obj:set_rotation({x=ray_rot.x, y=ray_rot.y, z=0})
    
    --minetest.debug("ANGLE: " .. math.deg(vector.angle(target_dir, vector.subtract(next_obj:get_pos(), pos))))
     
    ray_segments_list[#ray_segments_list+1] = pos
    
    --[[next_obj = minetest.add_entity(pos, "turret:ray")
    next_obj:set_properties({textures={"turret_ray_seg.png"}})
    next_obj:set_rotation({x=ray_rot.x+math.pi/2, y=ray_rot.y, z=ray_rot.z})
    next_obj:set_yaw(ray_rot.y+math.pi/2)
    ray_segments_list[#ray_segments_list+1] = pos]]
    
    --[[next_obj:set_rotation({x=pitch, y=yaw, z=0})
    next_obj2:set_rotation({x=pitch+math.pi/2, y=yaw, z=0})]]
    
    local next_pos = vector.add(pos, target_dir)
    local next_node = minetest.get_node(next_pos)
    
    while next_node.name == "air" do
        next_obj = minetest.add_entity(next_pos, "turret:ray")
        next_obj:set_rotation({x=ray_rot.x, y=ray_rot.y, z=0})
        ray_segments_list[#ray_segments_list+1] = next_pos
        
        --[[next_obj = minetest.add_entity(next_pos, "turret:ray")
        next_obj:set_rotation({x=ray_rot.x+math.pi/2, y=ray_rot.y, z=ray_rot.z})
        next_obj:set_yaw(ray_rot.y+math.pi/2)
        ray_segments_list[#ray_segments_list+1] = next_pos]]
        
        next_pos = vector.add(next_pos, target_dir)
        next_node = minetest.get_node(next_pos)
        
    
        --minetest.debug("ANGLE: " .. math.deg(vector.angle(target_dir, vector.subtract(next_obj:get_pos(), pos))))
    end
    
    local meta = minetest.get_meta(pos)
    meta:set_string("ray_segments_list", minetest.serialize(ray_segments_list))
    meta:set_string("ray_dir", minetest.serialize(target_dir))
end
    
--[[turret.get_ray_segment_from_pos = function(pos)
    local objs = minetest.get_objects_inside_radius(pos, 0.1)
    
    if not objs then return end
    
    for _, obj in ipairs(objs) do
        if obj:get_luaentity().name == "turret:ray" then
            return obj
        end
    end
    
    return
end]]

--[[turret.spread_ray = function(pos, unit_ray_dir, rot_axis, rot_step)
    rot_step = rot_step or 0.0
    pos = vector.add(pos, {x=0, y=0.175, z=0})
    
    local meta = minetest.get_meta(pos)
    local ray_seg_list = minetest.deserialize(meta:get_string("ray_segments_list"))]]
    
    --[[local unit_z_dir = {x=1, y=0, z=0}
    local cur_rot = {x=0, 
                     y=vector.angle(unit_z_dir, {x=unit_ray_dir.x, y=0, z=unit_ray_dir.z}),
                     z=vector.angle(unit_z_dir, {x=unit_ray_dir.x, y=unit_ray_dir.y, z=0})
                    }
    
    minetest.debug("cur_rot: y: " .. math.deg(cur_rot.y) .. ", z: " .. math.deg(cur_rot.z))
    local rot_change = vector.new()]]
    --[[local new_unit_ray_dir = {x=unit_ray_dir.x, y=unit_ray_dir.y, z=unit_ray_dir.z}
    minetest.debug("unit_rot_dir: x: " .. new_unit_ray_dir.x .. ", y: " .. new_unit_ray_dir.y .. ", z: " .. new_unit_ray_dir.z)
    if ray_seg_list and #ray_seg_list ~= 0 then
        local found_objs = minetest.get_objects_inside_radius(ray_seg_list[1], 0.1)
        
        local ray_obj
        for _, obj in ipairs(found_objs) do
            local self = obj:get_luaentity()
            
            if self then
                if self.name == "turret:ray" then
                    ray_obj = obj
                end
            end
        end
        
        if not ray_obj then return end
        
        turret.delete_ray(pos)
        
        new_unit_ray_dir = vector.rotate_around_axis(new_unit_ray_dir, rot_axis, rot_step)
        minetest.debug("new_unit_ray_dir: x: " .. new_unit_ray_dir.x .. ", y: " .. new_unit_ray_dir.y .. ", z: " .. new_unit_ray_dir.z)]]
    
        --[[local abs_rot = {x=0,
                         y=vector.angle(unit_z_dir, {x=new_unit_ray_dir.x, y=0, z=new_unit_ray_dir.z}),
                         z=vector.angle(unit_z_dir, {x=new_unit_ray_dir.x, y=new_unit_ray_dir.y, z=0})
                        }
    
        minetest.debug("abs_rot: y: " .. math.deg(abs_rot.y) .. ", z: " .. math.deg(abs_rot.z))
        rot_change = {y=abs_rot.y - cur_rot.y, z=abs_rot.z - cur_rot.z}
        minetest.debug("rot_change: y: " .. math.deg(rot_change.y) .. ", z: " .. math.deg(rot_change.z))]]
    --[[end
    
    local ray_segments_list = {}
    
    local ray_seg = minetest.add_entity(pos, "turret:ray")
    ray_seg:set_properties({textures = {"turret_ray_seg.png"}})
    
    local new_rot = vector.dir_to_rotation(new_unit_ray_dir)
    new_rot.y = new_rot.y + math.pi/2
    
    minetest.debug("new_rot: x: " .. new_rot.x .. ", y: " .. new_rot.y .. ", z: " .. new_rot.z)]]
    
    --[[local cur_yaw = ray_seg:get_rotation().y
    ray_seg:set_yaw(0)
    ray_seg:set_rotation({x=0, y=0, z=new_rot.z})
    ray_seg:set_yaw(new_rot.y)]]
    --[[ray_seg:set_rotation(new_rot)
    
    local cur_rot = ray_seg:get_rotation()
    minetest.debug("cur_rot: x: " .. cur_rot.x .. ", y: " .. cur_rot.y .. ", z: " .. cur_rot.z)]]
    
    
    --[[local cur_rot = ray_seg:get_rotation()
    if vector.length(rot) ~= 0 then
        ray_seg:set_rotation({x=cur_rot.x, y=cur_rot.y+rot+ang, z=cur_rot.z+rot.z})
    else
        ray_seg:set_rotation({x=0, y=ang, z=0})
    end]]
    --ray_segments_list[#ray_segments_list+1] = pos
    
    --[[local next_pos = {x=u_dir_vec.x*math.cos(cur_rot.y+rot.y) - u_dir_vec.z*math.sin(cur_rot.y+rot.y),
                      y=u_dir_vec.y,
                      z=u_dir_vec.z*math.cos(cur_rot.y+rot.y) + u_dir_vec.x*math.sin(cur_rot.y+rot.y)
                     }
    
    next_pos.x = next_pos.x*math.cos(rot.z) - u_dir_vec.y*math.sin(rot.z)
    next_pos.y = next_pos.y*math.cos(rot.z) + u_dir_vec.x*math.sin(rot.z)
    
    next_pos = vector.add(pos, next_pos)
    local node = minetest.get_node(next_pos)]]
    

    
    --[[local counter = 1
    local next_pos = vector.add(pos, new_unit_ray_dir)
    local node = minetest.get_node(next_pos)
    
    while node.name == "air" do
        if counter > 100 then
            return true
        end
        
        local next_obj = minetest.add_entity(next_pos, "turret:ray")]]
        
        --[[next_obj:set_yaw(0)
        next_obj:set_rotation({x=0, y=0, z=new_rot.z})
        next_obj:set_yaw(new_rot.y)]]
        --[[next_obj:set_rotation(new_rot)
        ray_segments_list[#ray_segments_list+1] = next_pos
        
        counter = counter + 1
        
        next_pos = vector.add(pos, vector.multiply(new_unit_ray_dir, counter))
        node = minetest.get_node(next_pos)
    end
    
    meta:set_string("ray_segments_list", minetest.serialize(ray_segments_list))
    return true
end]]

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

--[[turret.rotate_obj_pos_around_center = function(center, unit_direction, obj, rotation)
    if not obj or not obj:get_luaentity() then
        return
    end
    
    local rel_obj_pos = vector.subtract(obj:get_pos(), center)
    local cur_rot = {y=vector.angle({x=unit_direction.x, z=unit_direction.z}, {x=rel_obj_pos.x, z=rel_obj_pos.z}),
                     z=vector.angle({x=unit_direction.x, y=unit_direction.y}, {x=rel_obj_pos.x, y=rel_obj_pos.y})
                    }
    
    local new_rot = {y=cur_rot.y + rotation.y, z=cur_rot.z + rotation.z}
    
    if math.abs(math.deg(new_rot.y)) > 45 or math.abs(math.deg(new_rot.z)) > 45 then
        return
    end
    
    
end]]
turret.get_turret_unitdir = function(pos)
    local node = minetest.get_node(pos)
    local u_dir_vec = vector.rotate(minetest.facedir_to_dir(node.param2), {x=0, y=math.pi, z=0})
    
    return u_dir_vec
end
    
turret.is_obj_inside_field_of_sight = function(pos, obj_pos)
    if not obj_pos then return end
    
    local u_dir_vec = turret.get_turret_unitdir(pos)
    
    local rel_obj_pos = vector.subtract(obj_pos, {x=pos.x, y=pos.y+0.175, z=pos.z})
    
    return vector.length(rel_obj_pos) <= 20 and vector.angle(u_dir_vec, rel_obj_pos) <= math.rad(45)
end

vector.rotation = function(vec1, vec2)
    return {x = vector.angle({x=0, y=vec1.y, z=vec1.z}, {x=0, y=vec2.y, z=vec2.z}),
            y = vector.angle({x=vec1.x, y=0, z=vec1.z}, {x=vec2.x, y=0, z=vec2.z}),
            z = vector.angle({x=vec1.x, y=vec1.y, z=0}, {x=vec2.x, y=vec2.y, z=0})
           }
end

vector.are_co_directional = function(vec1, vec2)
    return vector.angle(vec1, vec2) == 0
end
    
turret.direct_ray_to_entity = function(pos)
    local meta = minetest.get_meta(pos)
    local strpos = minetest.pos_to_string(pos)
    local target_obj = target_objs[strpos]
    local eye_pos = {x=pos.x, y=pos.y+0.175, z=pos.z}
    
    local ray_seg_list = minetest.deserialize(meta:get_string("ray_segments_list"))
    local u_dir_vec = turret.get_turret_unitdir(pos)
    local cur_ray_dir = minetest.deserialize(meta:get_string("ray_dir"))
    if not target_obj then
        local nearby_objs = minetest.get_objects_inside_radius(eye_pos, 20)
        local hit_objs = {}
    
        for _, obj in ipairs(nearby_objs) do
            local view_ang = vector.angle(u_dir_vec, vector.subtract(obj:get_pos(), eye_pos))
            if obj:is_player() and view_ang <= math.pi/4 then
                hit_objs[#hit_objs+1] = obj
            end
        end
        
        if #hit_objs == 0 then 
            --minetest.debug("Current ray dir: x: " .. ray_seg_list[1].x .. ", y: " .. ray_seg_list[1].y .. ", z: " .. ray_seg_list[1].z)
            turret.delete_ray(pos)
            turret.spread_ray(pos, vector.normalize(cur_ray_dir))
            local rseg_l = minetest.deserialize(meta:get_string("ray_segments_list"))
            --minetest.debug("Updated ray dir: x: " .. rseg_l[1].x .. ", y: " .. rseg_l[1].y .. ", z: " .. rseg_l[1].z)
            
            return 
        end
        
        local rand_obj = hit_objs[math.random(1, #hit_objs)]
        target_objs[strpos] = rand_obj
    else
        local is_object_inside_view_radius = turret.is_obj_inside_field_of_sight(pos, target_obj:get_pos())
        if not is_object_inside_view_radius then
            target_objs[strpos] = nil
            return
        end
                                 
        if vector.are_co_directional(vector.subtract(target_obj:get_pos(), eye_pos), cur_ray_dir) then
            return true
        end
    end
    
    local rel_tpos = vector.subtract(target_obj:get_pos(), eye_pos)
    local pivot_vec = vector.cross(rel_tpos, cur_ray_dir)
    local ang = vector.angle(cur_ray_dir, rel_tpos)
             
    local new_ray_dir
    if ang < math.rad(ANGLE_SPEED_DIRECT) then
        new_ray_dir = vector.rotate_around_axis(cur_ray_dir, pivot_vec, ang)
    else
        new_ray_dir = vector.rotate_around_axis(cur_ray_dir, pivot_vec, math.rad(ANGLE_SPEED_DIRECT))
    end
        
    turret.delete_ray(pos)
    turret.spread_ray(pos, vector.normalize(new_ray_dir))
end
                                 
turret.release = function(pos)
    if target_objs[pos] then return end
    
    --minetest.debug("turret.release(): continue to return...")
    local u_dir_vec = turret.get_turret_unitdir(pos)
    --minetest.debug("turret.release(): continue1...")
    local meta = minetest.get_meta(pos)
    local ray_seg_list = minetest.deserialize(meta:get_string("ray_segments_list"))
    local rel_ray_seg_dir = minetest.deserialize(meta:get_string("ray_dir"))
    --minetest.debug("rel_ray_seg_dir: " .. minetest.pos_to_string(rel_ray_seg_dir))
    --minetest.debug("u_dir_vec: " .. minetest.pos_to_string(u_dir_vec))
    local ang = vector.angle(rel_ray_seg_dir, u_dir_vec)
    --minetest.debug("turret.release(): continue2...")
    if vector.are_co_directional(rel_ray_seg_dir, u_dir_vec) then
        return true
    else
        local turn_step = (ang < math.rad(ANGLE_SPEED_RELEASE) and ang or math.rad(ANGLE_SPEED_RELEASE))
        local pivot_vec = vector.cross(u_dir_vec, rel_ray_seg_dir)
        local new_rseg_dir = vector.rotate_around_axis(rel_ray_seg_dir, pivot_vec, turn_step)
        
        turret.delete_ray(pos)
        turret.spread_ray(pos, vector.normalize(new_rseg_dir))
    end
end
        
        
