local skynet  = require"skynet"
local s = require "service"
local runconfig = require "runconfig"
local mynode = skynet.getenv("node")
 local snode = "node1"
 local sname = "smartmanagement"
--传入门禁数据
s.client.set_wet_temp_record = function(msg)
        local record_id = msg[2]
	local id = msg[3]
        local time = msg[4]
        local tempature = msg[5]
        local wet = msg[6]
        local isok = s.call(snode,sname,"set_wet_temp_record",s.id,record_id,id,time,tempature,wet)
        if not isok then 
                return false
        else 
                return {isok}
        end 
end


s.client.set_camera_record = function(msg)
        local record_id = msg[2]
        local id = msg[3]
        local place = msg[4]
        local kind = msg[5]
        local time = msg[6]
	local video_address = msg[7]
        local isok = s.call(snode,sname,"set_camera_record",s.id,record_id,id,place,kind,time,video_address)
        if not isok then 
                return false
        else 
                return {isok}
        end 
end

s.client.set_somke_record  = function(msg)
        local record_id = msg[2]
        local id = msg[3]
        local time = msg[4]
        local smoke_data = msg[5]
        local isok = s.call(snode,sname,"set_somke_record",s.id,record_id,id, time,smoke_data)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.set_rescue_platform_record = function(msg)
        local name = msg[2]
        local place = msg[3]
        local status = msg[4]
        local time = msg[5]
        local isok = s.call(snode,sname,"set_rescue_platform_record",s.id,name,place,status,time)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.set_theft_against_record = function(msg)
        local source = msg[2]
        local info = msg[3]
        local time = msg[4]
        local isok = s.call(snode,sname,"set_theft_against_record",s.id,source,info,time)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.set_property_guarantee_record = function(msg)
        local owner = msg[2]
        local info = msg[3]
        local time = msg[4]
        local isok = s.call(snode,sname,"set_property_guarantee_record",s.id,owner,info,time)
        if not isok then
                return false
        else
                return {isok}
        end
end




s.client.set_police_service_record = function(msg)
        local type_data = msg[2]
        local time = msg[3]
        local place = msg[4]
        local isok = s.call(snode,sname,"set_police_service_record",s.id,type_data,time,place)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.set_fire_control_record = function(msg)
        local id = msg[2]
        local equipment_address = msg[3]
        local kind = msg[4]
	local time = msg[5]
        local isok = s.call(snode,sname,"set_fire_control_record",s.id,id,equipment_address,kind,time)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.set_elevator_record = function(msg)
        local record_id = msg[2]
        local id = msg[3]
        local elevator_address = msg[4]
        local kind = msg[5]
	local time = msg[6]
	local video_address = msg[7]
        local isok = s.call(snode,sname,"set_elevator_record",s.id,record_id,id,elevator_address,kind,time,video_address)
        if not isok then
                return false
        else
                return {isok}
        end
end




s.client.set_equipment_record = function(msg)
        local record_id = msg[2]
        local id = msg[3]
        local place = msg[4]
        local time = msg[5]
        local status = msg[6]
        local isok = s.call(snode,sname,"set_equipment_record",s.id,record_id,id,place,time,status)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.set_comfort_service_record = function(msg)
        local wet = msg[2]
        local temp = msg[3]
        local alarm = msg[4]
        local isok = s.call(snode,sname,"set_comfort_service_record",s.id,wet,temp,alarm)
        if not isok then
                return false
        else
                return {isok}
        end
end


--------------------------------------------------------------------------------------------------------------------------------------------------------



s.client.get_wet_temp_record = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_wet_temp_record",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.get_ten_wet_temp_records = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_ten_wet_temp_records",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end



s.client.get_camera_record = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_camera_record",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.get_ten_camera_records = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_ten_camera_records",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.get_smoke_record = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_smoke_record",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.get_ten_smoke_records = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_ten_smoke_records",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end




s.client.get_rescue_platform_record = function(msg)
        local name = msg[2]
        local isok = s.call(snode,sname,"get_rescue_platform_record",s.id,name)
        if not isok then
                return false
        else
                return {isok}
        end
end




s.client.get_ten_rescue_platform_records = function(msg)
        local name = msg[2]
        local isok = s.call(snode,sname,"get_ten_rescue_platform_records",s.id,name)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.get_theft_against_record = function(msg)
        local source = msg[2]
        local isok = s.call(snode,sname,"get_theft_against_record",s.id,source)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.get_ten_theft_against_records = function(msg)
        local source = msg[2]
        local isok = s.call(snode,sname,"get_ten_theft_against_records",s.id,source)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.get_property_guarantee_record = function(msg)
        local owner = msg[2]
        local isok = s.call(snode,sname,"get_property_guarantee_record",s.id,owner)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.get_ten_property_guarantee_records = function(msg)
        local owner = msg[2]
        local isok = s.call(snode,sname,"get_ten_property_guarantee_records",s.id,owner)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.get_police_service_record = function()
        local isok = s.call(snode,sname,"get_police_service_record",s.id)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.get_ten_police_service_records = function()
        local isok = s.call(snode,sname,"get_ten_police_service_records",s.id)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.get_fire_control_record = function(msg)
	local id = msg[2]
        local isok = s.call(snode,sname,"get_ten_police_service_records",s.id,id)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.get_ten_fire_control_records = function(msg)
        local id = msg[2]
        local isok = s.call(snode,sname,"get_ten_fire_control_records",s.id,id)
        if not isok then
                return false
        else
                return {isok}
        end
end

s.client.get_elevator_record = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_elevator_record",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end 
end


s.client.get_ten_elevator_records = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_ten_elevator_records",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.get_equipment_record = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_equipment_record",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.get_ten_equipment_records = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_ten_equipment_records",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end


s.client.get_comfort_service_record = function()
        local isok = s.call(snode,sname,"get_comfort_service_record",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end
end

