
-- API FUNCTIONS -- 

target_objs = {}

local ANGLE_SPEED_RELEASE   = 5    -- in degrees
local ANGLE_SPEED_DIRECT    = 15    -- in degrees
DAMAGE = 2

    
turret.spread_ray = function(pos, target_dir)
    target_dir = vector.normalize(target_dir)
    
    local ray_segments_list = {}
    local ray_rot = vector.dir_to_rotation(target_dir)
    
    local next_obj = minetest.add_entity(pos, "turret:ray")
    next_obj:set_properties({textures={"turret_ray_seg.png"}})
    next_obj:set_rotation({x=ray_rot.x, y=ray_rot.y, z=0})
    
     
    ray_segments_list[#ray_segments_list+1] = pos
    
    local next_pos = vector.add(pos, target_dir)
    local next_node = minetest.get_node(next_pos)
    
    while next_node.name == "air" do
        next_obj = minetest.add_entity(next_pos, "turret:ray")
        next_obj:set_rotation({x=ray_rot.x, y=ray_rot.y, z=0})
        ray_segments_list[#ray_segments_list+1] = next_pos
        
        
        next_pos = vector.add(next_pos, target_dir)
        next_node = minetest.get_node(next_pos)
    end
    
    local meta = minetest.get_meta(pos)
    meta:set_string("ray_segments_list", minetest.serialize(ray_segments_list))
    meta:set_string("ray_dir", minetest.serialize(target_dir))
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

vector.are_co_directional = function(vec1, vec2)
    return vector.angle(vec1, vec2) == 0
end
    
turret.get_state = function(pos)
    local node = minetest.get_node(pos)
    local state = node.name:match("_on$") or node.name:match("_off$")
    
    return state and state:sub(2)
end

turret.direct_ray_to_entity = function(pos)
    local meta = minetest.get_meta(pos)
    local strpos = minetest.pos_to_string(pos)
    local eye_pos = {x=pos.x, y=pos.y+0.175, z=pos.z}
    
    local ray_seg_list = minetest.deserialize(meta:get_string("ray_segments_list"))
    local u_dir_vec = turret.get_turret_unitdir(pos)
    local cur_ray_dir = minetest.deserialize(meta:get_string("ray_dir"))
    local node = minetest.get_node(pos)
    local state = turret.get_state(pos)
    if not target_objs[strpos] then
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
            turret.spread_ray(eye_pos, vector.normalize(cur_ray_dir))
            local rseg_l = minetest.deserialize(meta:get_string("ray_segments_list"))
            --minetest.debug("Updated ray dir: x: " .. rseg_l[1].x .. ", y: " .. rseg_l[1].y .. ", z: " .. rseg_l[1].z)
            
            return 
        end
        
        local rand_obj = hit_objs[math.random(1, #hit_objs)]
        target_objs[strpos] = rand_obj
        
        if state == "off" then
            minetest.set_node(pos, {name=node.name:gsub("_off$", "_on"), param1=node.param1, param2=node.param2})
            return true
        end
    else
        local is_object_inside_view_radius = turret.is_obj_inside_field_of_sight(pos, target_objs[strpos]:get_pos())
        if not is_object_inside_view_radius then
            target_objs[strpos] = nil
            return
        end
        
        --minetest.debug("gdkjkdjgkjgdjkg")
        --minetest.debug("angle: " .. math.deg(vector.angle(vector.subtract(target_objs[strpos]:get_pos(), eye_pos), cur_ray_dir)))
        if vector.are_co_directional(vector.subtract(target_objs[strpos]:get_pos(), eye_pos), cur_ray_dir) then
            minetest.debug("Turret has targeted!")
            if state == "on" then
                minetest.debug("Turret is shooting!")
                turret.shoot(pos)
            end
            return true
        end
    end
    
    local rel_tpos = vector.subtract(target_objs[strpos]:get_pos(), eye_pos)
    local pivot_vec = vector.cross(rel_tpos, cur_ray_dir)
    local ang = vector.angle(cur_ray_dir, rel_tpos)
             
    local new_ray_dir
    if ang < math.rad(ANGLE_SPEED_DIRECT) then
        new_ray_dir = vector.normalize(rel_tpos)
        minetest.debug("ang: " .. ang)
        minetest.debug("tpos_dir: " .. minetest.pos_to_string(vector.normalize(rel_tpos)))
        minetest.debug("new_ray_dir: " .. minetest.pos_to_string(new_ray_dir))
        minetest.debug("ANGLE: " .. vector.angle(rel_tpos, new_ray_dir))
        
    else
        new_ray_dir = vector.rotate_around_axis(cur_ray_dir, pivot_vec, math.rad(ANGLE_SPEED_DIRECT))
    end
        
    turret.delete_ray(pos)
    turret.spread_ray(eye_pos, vector.normalize(new_ray_dir))
end
                                 
turret.release = function(pos)
    if target_objs[minetest.pos_to_string(pos)] then return end
    
    local u_dir_vec = turret.get_turret_unitdir(pos)
    
    local meta = minetest.get_meta(pos)
    local ray_seg_list = minetest.deserialize(meta:get_string("ray_segments_list"))
    local rel_ray_seg_dir = minetest.deserialize(meta:get_string("ray_dir"))
    local ang = vector.angle(rel_ray_seg_dir, u_dir_vec)
    
    local turn_step = (ang < math.rad(ANGLE_SPEED_RELEASE) and ang or math.rad(ANGLE_SPEED_RELEASE))
    local pivot_vec = vector.cross(u_dir_vec, rel_ray_seg_dir)
    local new_rseg_dir = vector.rotate_around_axis(rel_ray_seg_dir, pivot_vec, turn_step)
        
    turret.delete_ray(pos)
    turret.spread_ray(pos, vector.normalize(new_rseg_dir))
    
    rel_ray_seg_dir = minetest.deserialize(meta:get_string("ray_dir"))
    
    if vector.are_co_directional(rel_ray_seg_dir, u_dir_vec) then
        local node = minetest.get_node(pos)
        minetest.set_node(pos, {name=node.name:gsub("_on$", "_off"), param1=node.param1, param2=node.param2})
    end
end
        
turret.shoot = function(pos)
    local node = minetest.get_node(pos)
    if turret.get_state(pos) ~= "on" then return end
    
    local ray_dir = minetest.deserialize(minetest.get_meta(pos):get_string("ray_dir"))
    local vel = vector.multiply(ray_dir, 10)
    
    local offset_horiz = {-0.2, 0.2}
    local offset_vert = {-0.1, 0, 0.4}
    
    local rand_offset = {x=offset_horiz[math.random(1, 2)], y=offset_vert[math.random(1, 2)]+0.175, z=0}
    local yaw = vector.angle({x=0, y=0, z=1}, turret.get_turret_unitdir(pos))
    local res_pos = vector.add(pos, vector.rotate(rand_offset, {x=0, y=yaw, z=0}))
    
    local dart = minetest.add_entity(res_pos, "turret:fiery_dart")
    local rot = vector.dir_to_rotation(ray_dir)
    dart:set_rotation({x=rot.x, y=rot.y, z=0})
    dart:set_velocity(vel)
end
