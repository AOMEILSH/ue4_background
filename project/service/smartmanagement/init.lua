
local skynet = require "skynet"
local s = require "service"
local mysql = require "skynet.db.mysql"
local pb = require "protobuf"
local db = nil






function s.init()
                pb.register_file("./proto/smartmanagement.pb")
                s.connect()
end

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

s.start(...)


-- 接收温湿度传感器数据
s.resp.set_wet_temp_record = function(source,playerid,record_id,id,time,tempature,wet)
	if not db then
             s.connect()
        end
	print(record_id)
        local sql = string.format("insert into wet_temp_record (record_id,id,time,tempature,wet) values ('%s',%d,'%s',%d,%d)",record_id,id,time,tempature,wet)
        print (sql)
	local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end 
        return "true"

end

s.resp.set_camera_record = function(source,playerid,record_id,id,place,kind,time,video_address)
	
	if not db then
		s.connect()
	end
	local sql  = string.format("insert into camera_record (record_id,id,place,kind,time,video_address) values ('%s',%d,'%s','%s','%s','%s')",record_id,id,place,kind,time,video_address)
	

	        local res = db:query(sql)       
        if res.err then
             print("error:"..res.err)        
             return "false"
        else
             print("ok")
        end 
        return "true"  	
end



s.resp.set_somke_record = function(source, playerid,record_id, id, time,smoke_data )

	


	if not db then

                s.connect()
        end 
        local sql  = string.format("insert into smoke_record (record_id,id,time,smoke_data) values ('%s',%d,'%s',%d)",record_id,id,time,smoke_data)
    
                local res = db:query(sql)    
        if res.err then
             print("error:"..res.err)    
             return "false"
        else
             print("ok")
        end 
        return "true"    
end


s.resp.set_rescue_platform_record = function(source,playerid,name,place,status,time)

        if not db then

                s.connect()
     end
        local sql  = string.format("insert into rescue_platform_record (name,place,status,time) values ('%s','%s','%s','%s')",name,place,status,time)

                local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end
        return "true" 

end

s.resp.set_theft_against_record = function(source,playerid,source,info,time)
	
        if not db then

                s.connect()
     end
        local sql  = string.format("insert into rescue_platform_record (source,info,time) values ('%s','%s','%s')",source,info,time)

                local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end
        return "true"

end



s.resp.set_property_guarantee_record = function(source,playerid,owner,info,time)
    
        if not db then

                s.connect()
     end 
        local sql  = string.format("insert into property_guarantee_record (owner,info,time) values ('%s','%s','%s')",owner,info,time)

                local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end 
        return "true"

end


s.resp.set_police_service_record = function(source,playerid,type_data,time,place)

        if not db then

                s.connect()
     end
        local sql  = string.format("insert into police_service_record (type_data,time,place) values ('%s','%s','%s')",type_data,time,place)

                local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end
        return "true"

end



s.resp.set_fire_control_record = function(source,playerid,id,equipment_address,kind,time)

        if not db then

                s.connect()
     end
        local sql  = string.format("insert into fire_control_record (id,equipment_address,kind,time) values (%d,'%s','%s','%s')",id,equipment_address,kind,time)

                local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end
        return "true"

end


s.resp.set_elevator_record = function(source,playerid,record_id,id,elevator_address,kind,time,video_address)

        if not db then

                s.connect()
     end
        local sql  = string.format("insert into evevator_record (record_id,id,elevator_address,kind,time,video_address) values ('%s',%d,'%s','%s','%s','%s')",record_id,id,elevator_address,kind,time,video_address)

                local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end
        return "true"

end



s.resp.set_equipment_record = function(source,playerid,record_id,id,place,time,status)

        if not db then

                s.connect()
     end 
        local sql  = string.format("insert into equipment_record (record_id,id,place,time,status) values ('%s',%d,'%s','%s','%s')",record_id,id,place,time,status)

                local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end 
        return "true"

end




s.resp.set_comfort_service_record = function(source,playerid,wet,temp,alarm)

        if not db then

                s.connect()
     end
        local sql  = string.format("insert into comfort_service_record (wet,temp,alarm) values (%d,%d,'%s')",wet,temp,alarm)

                local res = db:query(sql)
        if res.err then
             print("error:"..res.err)
             return "false"
        else
             print("ok")
        end
        return "true"

end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--获取当前某个温湿度传感器的数据
s.resp.get_wet_temp_record = function(source,playerid,record_id)

           local sql = string.format("select * from wet_temp_record where record_id = '%s' LIMIT 1",record_id)
	   print(sql)
        local res = db:query(sql)
	print(res[1].record_id)
        if res.err then
                print("error:"..res.err)
                return "false"
        else
                print("ok")
        end
        local data = {}
	data.record_id = res[1].record_id
        data.id = res[1].id
        data.time = res[1].time
        data.tempature = res[1].tempature
	data.wet = res[1].wet
        local result = pb.encode("smart_management.get_wet_temp_record",data)
        return result 
	
end
--获取某个温湿度传感器历史数据（前十个）
s.resp.get_ten_wet_temp_records = function(source,playerid,record_id)

           local sql = string.format("select * from wet_temp_record where record_id = '%s' LIMIT 10",record_id)
        local res = db:query(sql)
        if res.err then
        
	        print("error:"..res.err)
        	 return "false"
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
		data.record_id = res[i].record_id
        	data.id = res[i].id
        	data.time = res[i].time
        	data.tempature = res[i].tempature
        	data.wet = res[i].wet
		 table.insert(msg.records,data)
	end 
        local result = pb.encode("smart_management.get_ten_wet_temp_records",msg)
        return result 
    
end

s.resp.get_camera_record = function(source,playerid,record_id)

           local sql = string.format("select * from camera_record where record_id = '%s' LIMIT 1",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end 
        
                local data = {}
                data.record_id = res[1].record_id
                data.id = res[1].id
                data.place = res[1].place
		data.time = res[1].time
		data.kind = res[1].kind
		data.video_address = res[1].video_address
        
        local result = pb.encode("smart_management.get_camera_record",data)
        return result 
    
end


s.resp.get_ten_camera_records = function(source,playerid,record_id)

           local sql = string.format("select * from camera_record where record_id = '%s' LIMIT 10",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
                data.record_id = res[i].record_id
                data.id = res[i].id
                data.place = res[i].place
                data.time = res[i].time
                data.kind = res[i].kind
                data.video_address = res[i].video_address
                table.insert(msg.records,data)
	end
        local result = pb.encode("smart_management.get_ten_camera_records",msg)
        return result

end








s.resp.get_smoke_record = function(source,playerid,record_id)

           local sql = string.format("select * from somke_record where record_id = '%s' LIMIT 1",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
		 return "false"        
	else
                print("ok")
        end
    
                local data = {}
		data.record_id = res[1].record_id
                data.id = res[1].id
                data.time = res[1].time
                data.smoke_data = res[1].smoke_data
        
        local result = pb.encode("smart_management.get_smoke_record",data)
        return result

end

s.resp.get_ten_smoke_records = function(source,playerid,record_id)

           local sql = string.format("select * from somke_record where record_id = '%s' LIMIT 10",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
		data.record_id = res[i].record_id
                data.id = res[i].id
                data.time = res[i].time
                data.smoke_data = res[i].smoke_data
                table.insert(msg.records,data)
        end
        local result = pb.encode("smart_management.get_ten_smoke_records",msg)
        return result

end




s.resp.get_rescue_platform_record = function(source,playerid,name)

           local sql = string.format("select * from rescue_platform_record where name = '%s' LIMIT 1",name)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end 
    
                local data = {}
                data.name = res[1].name
                data.time = res[1].time
                data.place = res[1].place
		data.status = res[1].status
    
        local result = pb.encode("smart_management.get_rescue_platform_record",data)
        return result

end

s.resp.get_ten_rescue_platform_records = function(source,playerid,name)

           local sql = string.format("select * from rescue_platform_record where name = '%s' LIMIT 10",name)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
                data.name = res[i].name
                data.time = res[i].time
                data.place = res[i].place
                data.status = res[i].status
		table.insert(msg.records,data)
        end
        local result = pb.encode("smart_management.get_ten_rescue_platform_records",msg)
        return result

end

s.resp.get_theft_against_record = function(source,playerid,source)

           local sql = string.format("select * from theft_against_record where source = '%s' LIMIT 1",source)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end

                local data = {}
                data.source = res[1].source
		data.info = res[1].info
                data.time = res[1].time

        local result = pb.encode("smart_management.get_theft_against_record",data)
        return result

end

s.resp.get_ten_theft_against_records = function(source,playerid,source)

           local sql = string.format("select * from theft_against_record where source = '%s' LIMIT 10",source)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
                data.source = res[i].source
                data.info = res[i].info
		data.time = res[i].time 
                table.insert(msg.records,data)
        end
        local result = pb.encode("smart_management.get_ten_theft_against_records",msg)
        return result

end


s.resp.get_property_guarantee_record = function(source,playerid,owner)

           local sql = string.format("select * from property_guarantee_record where owner = '%s' LIMIT 1",owner)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end

                local data = {}
                data.owner = res[1].owner
                data.info = res[1].info
                data.time = res[1].time

        local result = pb.encode("smart_management.get_property_guarantee_record",data)
        return result

end

s.resp.get_ten_property_guarantee_records = function(source,playerid,owner)

           local sql = string.format("select * from property_guarantee_record where owner = '%s' LIMIT 10",owner)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
                data.owner = res[i].owner
                data.info = res[i].info
                data.time = res[i].time
                table.insert(msg.records,data)
        end
        local result = pb.encode("smart_management.get_ten_property_guarantee_records",msg)
        return result

end






s.resp.get_police_service_record = function(source,playerid)

           local sql = string.format("select * from police_service_record LIMIT 1")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end

                local data = {}
		data.place = res[1].place
                data.time = res[1].time
                data.type_data = res[1].type_data

        local result = pb.encode("smart_management.get_police_service_record",data)
        return result

end

s.resp.get_ten_police_service_records = function(source,playerid)

           local sql = string.format("select * from property_guarantee_record LIMIT 10")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
                data.place = res[i].place
                data.time = res[i].time
                data.type_data = res[i].type_data
		table.insert(msg.records,data)
        end
        local result = pb.encode("smart_management.get_ten_police_service_records",msg)
        return result

end

s.resp.get_fire_control_record = function(source,playerid,id)

           local sql = string.format("select * from fire_control_record where id = %d LIMIT 1",id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end 

                local data = {}
                data.equipment_address = res[1].equipment_address
                data.kind = res[1].kind
                data.id = res[1].id
                data.time = res[1].time
        local result = pb.encode("smart_management.get_fire_control_record",data)
        return result

end

s.resp.get_ten_fire_control_records = function(source,playerid,id)

           local sql = string.format("select * from fire_control_record where id = %d LIMIT 10",id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
                data.equipment_address = res[i].equipment_address
                data.kind = res[i].kind
                data.id = res[i].id
                data.time = res[i].time
                table.insert(msg.records,data)
        end 
        local result = pb.encode("smart_management.get_ten_fire_control_records",msg)
        return result

end


s.resp.get_elevator_record = function(source,playerid,record_id)

           local sql = string.format("select * from elevator_record where record_id = '%s' LIMIT 1",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end

                local data = {}
                data.time = res[1].time
                data.video_address = res[1].video_address
                data.elevator_address = res[1].elevator_address
                data.kind = res[1].kind
                data.id = res[1].id
                data.record_id = res[1].record_id

        local result = pb.encode("smart_management.get_elevator_record",data)
        return result

end

s.resp.get_ten_elevator_records = function(source,playerid,record_id)

           local sql = string.format("select * from elevator_record where record_id = '%s' LIMIT 10",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
		data.time = res[i].time
		data.video_address = res[i].video_address
                data.elevator_address = res[i].elevator_address
                data.kind = res[i].kind
                data.id = res[i].id
                data.record_id = res[i].record_id
                table.insert(msg.records,data)
        end
        local result = pb.encode("smart_management.get_ten_elevator_records",msg)
        return result

end



s.resp.get_equipment_record = function(source,playerid,record_id)

           local sql = string.format("select * from equipment_record where record_id = '%s' LIMIT 1",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end

                local data = {}
		data.record_id = res[1].record_id
                data.time = res[1].time
                data.place = res[1].place
                data.status = res[1].status
                data.id = res[1].id

        local result = pb.encode("smart_management.get_equipment_record",data)
        return result

end

s.resp.get_ten_equipment_records = function(source,playerid,record_id)

           local sql = string.format("select * from equipment_record where record_id = '%s' LIMIT 10",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
                data.time = res[i].time
                data.place = res[i].place
                data.status = res[i].status
                data.id = res[i].id
		data.record_id = res[i].record_id
                table.insert(msg.records,data)
        end
        local result = pb.encode("smart_management.get_ten_equipment_records",msg)
        return result

end



s.resp.get_comfort_service_record = function(source,playerid)

           local sql = string.format("select * from comfort_service_record LIMIT 1")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
	else
                print("ok")
        end

                local data = {}
                data.wet = res[1].wet
                data.temp = res[1].temp
                data.alarm = res[1].alarm
                data.record_id = res[1].record_id

        local result = pb.encode("smart_management.get_comfort_service_record",data)
        return result

end

s.resp.get_ten_comfort_service_records = function(source,playerid)

           local sql = string.format("select * from comfort_service_record LIMIT 10")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	 return "false"
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
                data.wet = res[i].wet
                data.temp = res[i].temp
                data.alarm = res[i].alarm
                table.insert(msg.records,data)
        end
        local result = pb.encode("smart_management.get_ten_comfort_service_records",msg)
        return result

end
