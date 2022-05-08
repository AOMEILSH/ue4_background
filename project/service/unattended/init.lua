
local skynet = require "skynet"
local s = require "service"
local mysql = require "skynet.db.mysql"
local pb = require "protobuf"
require "astar"
require "parkinglothandler"

local db = nil
-- 五分钟内的人流（出和入）
local fivemin_in = 0
local fivemin_out = 0

--本日车流(出和入)
local car_in = 0
local car_out = 0
--总车位数和已占用数
local all_parking_spaces = nil
local used_parking_spaces = nil

--记存停车场地图，以及实现寻路算法
local handler1 = ParkingLotHandler()--第一层停车位
local astar = AStar(handler1)
local parking_car = {}
function s.init()
	        pb.register_file("./proto/unattended.pb")
		s.connect()
		refresh_foot_traffic()
		refresh_car_traffic()
end

s.start(...)

s.connect = function ()
        db = mysql.connect({
                host="120.77.58.14",
                port=3306,
                database="ue4_data",
                user="root",
                password="123456",
                max_packet_size = 1024 * 1024,
                on_connect = nil
        })
end   
--五分钟刷新一次人流数据
function refresh_foot_traffic()
	fivemin_in = 0;
	fivemin_out = 0;
 	skynet.timeout(30000,refresh_foot_traffic)
end
--一日刷新一次车流数据并写入数据库
function refresh_car_traffic()
	local date = tostring(os.time())
	local sql  = string.format("insert into car_record (date, car_in, car_out) values (%s, %d, %d)", date, car_in, car_out)
	car_in = 0
	car_out = 0
	
	local res = db:query(sql)
         if res.err then
                 print("refresh_car_traffic_error:"..res.err)
                 return false
         else
                 print("refresh_car_traffic_ok")
         end
	skynet.timeout(100*3600*24,refresh_car_traffic)
end

--返回最新十个门禁记录
s.resp.get_ten_recent_access_records = function(source, playerid)
	local msg = {
		records = {}
	}
	
	
		
	local sql = string.format("select * from visit_record LIMIT 10 ")
	local data = db:query(sql)

	for i = 1, 10 do	
		local temp_msg = {}
		if data[i] == nil then
			break
		end
		local temp_data = data[i]
		temp_msg.record_id = temp_data.record_id
		temp_msg.id = temp_data.id
		temp_msg.monitor_vedio = temp_data.monitor_vedio
		temp_msg.kind  = temp_data.kind
		temp_msg.in_out = temp_data.in_out
		table.insert(msg.records,data)	
	end
	local result = pb.encode("unattended.Last_ten_people_records",msg)
	return result
end
	
--获得当前人流情况（五分钟内进，出，趋势）
s.resp.get_fivemin_foot_traffic = function(source, playerid)
	
	local trend = "unknown"
	if fivemin_in > fivemin_out  then
			trend = "in"
	elseif fivemin_in<fivemin_out then 
			trend = "out"
	end

	local msg = {
		in_num = fivemin_in,
		out_num = fivemin_out,
		trend = trend,	
	}
 	local result = pb.encode("unattended.Foot_traffic",msg)
	local test = pb.decode("unattended.Foot_traffic",result)
	print(test.trend)
	return result

end

-- 返回车流量数据（十日）
s.resp.get_unattended_car_record = function(source, playerid)
        local sql = string.format("select * from car_record LIMIT 10")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
                return false
        else
                print("ok")
        end 
        local msg = { 
                records = {}
        }   
        for i=1,10 do
                local data = {}  
                if res[i] == nil then
                        break
                end 
                data.date = res[i].date
                data.car_in = res[i].car_in
                data.car_out = res[i].car_out
                table.insert(msg.records,data)
        end 
        local result = pb.encode("unattended.Last_ten_traffic_records",msg)
        local test = pb.decode("unattended.Last_ten_traffic_records",result)
        print(test.records[1].date)
        return result
    
end


-- 获取当前空闲车位和总车位和停车位数据(还没写proto)
s.resp.get_parking_spaces_info = function(source, playerid)
	local msg = {}
	msg.all_parking_spaces = all_parking_spaces
	msg.used_parking_spaces = used_parking_spaces
	 msg.parkinglot_info = handler1:getMaps()
	local result = pb.encode("unattended.Parking_spaces_info",msg)
	return result
end


-- 获取最近车位路径（寻路）
s.resp.get_nearest_parkinglot = function(source,playerid,from)
	local msg = {}
	
			
end
--获取某个车位的信息(没写proto)
s.resp.get_parking_car_info = function(source,playerid,floor,i,j)
	if parking_car[floor]  == nil or parking_car[floor][i] == nil or parking_car[i][j] == nil then
		return "empty"
	end
	local msg = {}
	msg.id = parking_car[floor][i][j][id]
	msg.time = os.time() - parking_car[floor][i][j][time]
	        local result = pb.encode("unattended.Parking_car_info",msg)
        return result
end
--获取地铁剩余时间（没写proto）
s.resp.get_subway_info = function(source,playerid)
	local msg = {}
	local subway_time = os.time() - stime
	msg.subway_time  = subway_time
	local result = pb.encode("unattended.Subway_time",msg)
	return result
end
--获取火车剩余时间（没写proto）
s.resp.get_bus_info = function(source,playerid)
	local msg = {}
	local msg = {}
	local bus_time = os.time() - btime
	msg.bus_time =  bus_time
	local result  = pb.encode("unattended.Bus_time",msg)
	return result
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 从传感器获得车位相关数据（还没写proto）

s.resp.set_parkinglot_record = function(source,playerid,i,j,value,floor,id,time)
	handler1:changeMaps(i,j,value)
	if parking_car[floor] == nil then
		parking_car[floor] = {}
	end
	if parking_car[floor][i] == nil then
		parking_car[i] = {}
	end
	parking_car[floor][i][j][id] = id
 	parking_car[floor][i][j][time] = os.time()
end
-- 从传感器获得门禁数据输入
s.resp.set_unattended_visit_record = function(source, playerid, id, monitor_video , kind, in_out)
        if not db then
		s.connect()
	end
	local sql = string.format("insert into visit_record (id,monitor_video,kind,in_out) values (%d,%s,%s,%s)",id,monitor_video,kind,in_out)
	local res = db:query(sql)
	if res.err then
		print("error:"..res.err)
		return false
	else
		print("ok")
	end
	if in_out == "in" then
		fivemin_in = fivemin_in + 1
	else 
		fivemin_out = fivemin_out + 1
	end
	return true
	
end


