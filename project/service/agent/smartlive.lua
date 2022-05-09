local skynet  = require"skynet"
local s = require "service"
local runconfig = require "runconfig"
local mynode = skynet.getenv("node")
 local snode = "node1"
 local sname = "smartlive"
s.client.set_com_env = function(msg)
	local id = msg[2] 
	local time = msg[3] 
	local temp = msg[4]
	local wet = msg[5]
	local pm_ten = msg[6] 
	local pm_tpf = msg[7]
        local isok =  s.call(snode,sname,"set_com_env",s.id,id,time,temp,wet,pm_ten,pm_tpf)
        if not isok then
                return false
        else
                return {isok}
        end 
end
s.client.set_humantemp_record  = function(msg)
	local staff_id = msg[2]
	local time = msg[3]
	local tempature = msg[4]
	local place = msg[5]
         local isok =  s.call(snode,sname,"set_humantemp_record",s.id,staff_id,time,tempature,place)
        if not isok then
                return false
        else
                return {isok}
        end 
end
s.client.set_personnel_mobility_record = function(msg)
	local time = msg[2]
	local trand = msg[3]
        local isok = s.call(snode,sname,"set_personnel_mobility_record",s.id,time,trand)
        if not isok then
                return false
        else
                return {isok}
        end     
end
s.client.set_electricity_record = function(msg)
        local date = msg[2]
        local day_use = msg[3]
        local week_use = msg[4]
        local month_use = msg[5]
	local year_use = msg[6]
        local isok = s.call(snode,sname,"set_electricity_record",s.id,date,day_use,week_use,month_use,year_use)
        if not isok then
                return false
        else
                return {isok}
        end 
end



s.client.set_water_record = function(msg)
        local date = msg[2]
        local day_use = msg[3]
        local week_use = msg[4]
        local month_use = msg[5]
        local year_use = msg[6]
        local isok = s.call(snode,sname,"set_water_record",s.id,date,day_use,week_use,month_use,year_use)
        if not isok then
                return false
        else
                return {isok}
        end 
end




s.client.set_garbage_record = function(msg)
        local record_id = msg[2]
        local id = msg[3]
        local capacity = msg[4]
        local clean = msg[5]
        local place = msg[6]
	local time = msg[7]
        local isok = s.call(snode,sname,"set_garbage_record",s.id,record_id,id,capacity,clean,place,time)
        if not isok then
                return false
        else
                return {isok}
        end 
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------



s.client.get_com_env_record = function(msg)
        local id = msg[2]
        local isok = s.call(snode,sname,"get_com_env_record",s.id,id)
        if not isok then
                return false
        else
                return {isok}
        end 
end


s.client.get_ten_com_env_records = function(msg)
        local id = msg[2]
        local isok = s.call(snode,sname,"get_ten_com_env_records",s.id,id)
        if not isok then
                return false
        else
                return {isok}
        end 
end


s.client.get_temp_total_record = function()
        local isok = s.call(snode,sname,"get_temp_total_record",s.id)
        if not isok then
                return false
        else
                return {isok}
        end 
end



s.client.get_ten_temp_total_records = function()
        local isok = s.call(snode,sname,"get_ten_temp_total_records",s.id)
        if not isok then
                return false
        else
                return {isok}
        end 
end

s.client.get_humantemp_record = function(msg)
        local staff_id = msg[2]
        local isok = s.call(snode,sname,"get_humantemp_record",s.id,staff_id)
        if not isok then
                return false
        else
                return {isok}
        end 
end
s.client.get_elepower_record  = function()
        local isok = s.call(snode,sname,"get_elepower_record",s.id)
        if not isok then
                return false
        else
                return {isok}
        end 
end

s.client.get_ten_elepower_records  = function()
        local isok = s.call(snode,sname,"get_ten_elepower_records",s.id)
        if not isok then
                return false
        else
                return {isok}
        end 
end


s.client.get_waterpower_record = function()
        local isok = s.call(snode,sname,"get_waterpower_record",s.id)
        if not isok then
                return false
        else
                return {isok}
        end 
end

s.client.get_ten_waterpower_records = function()
        local isok = s.call(snode,sname,"get_ten_waterpower_records",s.id)
        if not isok then
                return false
        else
                return {isok}
        end 
end

s.client.get_garbage_record = function(msg)
        local record_id = msg[2]
        local isok = s.call(snode,sname,"get_humantemp_record",s.id,record_id)
        if not isok then
                return false
        else
                return {isok}
        end 
end
