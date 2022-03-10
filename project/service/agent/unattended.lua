local skynet  = require"skynet"
local s = require "service"
local runconfig = require "runconfig"
local mynode = skynet.getenv("node")
 local snode = "node1"
 local sname = "unattended"
--查询最新十个门禁访问数据
s.client.get_ten_recent_access_records = function()
	local isok =  s.call(snode,sname,"get_ten_recent_access_records",s.id)
	if not isok then
		return{"查询前十个访问记录失败"}
	end
	return{isok}
end
--获取前十日车流数据
s.client.get_unattended_car_record = function()
	 local isok =  s.call(snode,sname,"get_unattended_car_record",s.id)
          if not isok then
                  return{"查询前十个车流量记录失败"}
          end
          return{isok}	
end
--获取人流数据（五分钟）
s.client.get_fivemin_foot_traffic = function()
	local isok = s.call(snode,sname,"get_fivemin_foot_traffic",s.id)
	if not isok then 
		return {"查询人流失败"}
	end
		
	return {isok}
end
--传入门禁数据
s.client.set_unattended_visit_record = function(msg)
	local id = msg[2]
	local monitor_video = msg[3]
	local kind = msg[4]
	local in_out = msg[5]
	local isok = s.call(snode,sname,"set_unattended_visit_record",s.id,id,monitor_video,kind,in_out)
	if not isok then 
		return false
	else 
		return {isok}
	end
end


