local skynet = require "skynet"
local s = require "service"
local mysql = require "skynet.db.mysql"
local pb = require "protobuf"
local db = nil 




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


function s.init()
                pb.register_file("./proto/smartlive.pb")
                s.connect()
end

s.start(...)

s.resp.set_com_env = function(source, playerid, id, time, temp,wet, pm_ten, pm_tpf)
	if not db then
	 s.connect()
 	end 
	local sql = string.format("insert into community_environment_record (id, time, temp, wet, pm_ten, pm_tpf) values (%d,'%s','%s','%s',%d)",id, time, temp, wet, pm_ten, pm_tpf)
	local res = db:query(sql)
	if res.err then
		 print("error:"..res.err)
	 	 return {"false"}
	else
		print("ok")
	 end 
	return {"true"}     
end



s.resp.set_humantemp_record = function(source, playerid, staff_id,time,tempature,place)
	if not db then
         s.connect()
        end 
        local sql = string.format("insert into human_temp_record (staff_id,date,time,temp,place) values (%d,'%s','%s',%d,'%s')",staff_id,date,time,tempature,place)
        local res = db:query(sql)       
        if res.err then
                 print("error:"..res.err)        
                 return {"false"}
        else
                print("ok")
         end 
        return {"true"}   	
end





s.resp.set_personnel_mobility_record = function(source, playerid, time,trand)
        if not db then
         s.connect()
        end
        local sql = string.format("insert into personnel_mobility_record (time,trand) values ('%s','%s')",time,trand)
        local res = db:query(sql)
        if res.err then
                 print("error:"..res.err)
                 return {"false"}
        else
                print("ok")
         end
        return {"true"}
end



s.resp.set_electricity_record = function(source,playerid,date,day_use,week_use,month_use,year_use)
        if not db then
         s.connect()
        end 
        local sql = string.format("insert into electricity_record (date,day_use,week_use,month_use,year_use) values ('%s',%d,%d,%d,%d)",date,day_use,week_use,month_use,year_use)
        local res = db:query(sql)
        if res.err then
                 print("error:"..res.err)
                 return {"false"}
        else
                print("ok")
         end 
        return {"true"}
end



s.resp.set_water_record = function(source,playerid,date,day_use,week_use,month_use,year_use)
        if not db then
         s.connect()
        end
        local sql = string.format("insert into water_record (date,day_use,week_use,month_use,year_use) values ('%s',%d,%d,%d,%d)",date,day_use,week_use,month_use,year_use)
        local res = db:query(sql)
        if res.err then
                 print("error:"..res.err)
                 return {"false"}
        else
                print("ok")
         end
        return {"true"}
end



s.resp.set_garbage_record = function(source,playerid,record_id,id,capacity,clean,place,time)
        if not db then
         s.connect()
        end 
        local sql = string.format("insert into garbage_record (record_id,id,capacity,clean,place,time) values (%d,%d,%d,%d,'%s','%s')",record_id,id,capacity,clean,place,time)

        local res = db:query(sql)
        if res.err then
                 print("error:"..res.err)
                 return {"false"}
        else
                print("ok")
         end 
        return {"true"}
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






s.resp.get_com_env_record = function(source,playerid,id)
	local sql = string.format("select * from community_environment_record where id = %d LIMIT 1",id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
                return {"false"}
        else
                print("ok")
        end 
    
                local data = {}
                data.id = res[1].id
                data.wet = res[1].wet
                data.temp = res[1].temp
                data.pm_ten = res[1].pm_ten
                data.pm_tpf = res[1].pm_tpf
    
        local result = pb.encode("smart_live.get_com_env_record",data)
        return result 
end




s.resp.get_ten_com_env_records = function(source,playerid,id)
        local sql = string.format("select * from community_environment_record where id = %d LIMIT 10",id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
                return {"false"}
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
                local data = {}
                data.id = res[i].id
                data.wet = res[i].wet
                data.temp = res[i].temp
                data.pm_ten = res[i].pm_ten
                data.pm_tpf = res[i].pm_tpf
                table.insert(msg.records,data)
        end 
        local result = pb.encode("smart_live.get_ten_com_env_records",msg)
        return result
end


s.resp.get_temp_total_record = function(source,playerid)
        local sql = string.format("select * from temp_total LIMIT 1")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
                return {"false"}
        else
                print("ok")
        end

                local data = {}
                data.time = res[1].time
                data.normal = res[1].normal
                data.abnormal = res[1].abnormal

        local result = pb.encode("smart_live.get_temp_total_record",data)
        return result
end



s.resp.get_ten_temp_total_records = function(source,playerid)
        local sql = string.format("select * from temp_total where LIMIT 10")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
                return {"false"}
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
                local data = {}
                data.time = res[i].time
                data.normal = res[i].normal
                data.abnormal = res[i].abnormal
		table.insert(msg.records,data)
        end
        local result = pb.encode("smart_live.get_ten_temp_total_records",msg)
        return result
end





s.resp.get_humantemp_record = function(source,playerid,staff_id)
        local sql = string.format("select * from human_temp_record where staff_id = %d LIMIT 1",staff_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	return {"false"}
	else
                print("ok")
        end

                local data = {}
                data.staff_id = res[1].staff_id
		data.date = res[1].date
                data.record_id = res[1].record_id
                data.temp = res[1].temp
		data.time = res[1].time
		data.place = res[1].place
        local result = pb.encode("smart_live.get_humantemp_record",data)
        return result
end

s.resp.get_elepower_record = function(source,playerid)
        local sql = string.format("select * from electricity_record LIMIT 1")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	return {"false"}
	else
                print("ok")
        end

                local data = {}
                
                data.day_use = res[1].day_use
                data.week_use = res[1].week_use
                data.month_use = res[1].month_use
		data.year_use = res[1].year_use
		data.date = res[1].date
        local result = pb.encode("smart_live.get_elepower_record",data)
        return result
end

s.resp.get_ten_elepower_records = function(source,playerid)
        local sql = string.format("select * from electricity_record where LIMIT 10")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	return {"false"}
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
                local data = {}
                data.day_use = res[i].day_use
                data.week_use = res[i].week_use
                data.month_use = res[i].month_use
                data.year_use = res[i].year_use
                data.date = res[i].date
		table.insert(msg.records,data)
        end
        local result = pb.encode("smart_live.get_ten_elepower_records",msg)
        return result
end

s.resp.get_waterpower_record = function(source,playerid)
        local sql = string.format("select * from water_record LIMIT 1")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	return {"false"}
	else
                print("ok")
        end

                local data = {}

                data.day_use = res[1].day_use
                data.week_use = res[1].week_use
                data.month_use = res[1].month_use
                data.year_use = res[1].year_use
                data.date = res[1].date
        local result = pb.encode("smart_live.get_waterpower_records",data)
        return result
end

s.resp.get_ten_waterpower_records = function(source,playerid)
        local sql = string.format("select * from water_record where LIMIT 10")
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	return {"false"}
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
                local data = {}
                data.day_use = res[i].day_use
                data.week_use = res[i].week_use
                data.month_use = res[i].month_use
                data.year_use = res[i].year_use
                data.date = res[i].date
                table.insert(msg.records,data)
        end
        local result = pb.encode("smart_live.get_ten_waterpower_records",msg)
        return result
end



s.resp.get_garbage_record = function(source,playerid,record_id)
        local sql = string.format("select * from garbage_record where record_id = '%s' LIMIT 1",record_id)
        local res = db:query(sql)
        if res.err then
                print("error:"..res.err)
        	return {"false"}
	else
                print("ok")
        end 

                local data = {}

                data.record_id = res[1].record_id
                data.clean = res[1].clean
                data.capacity = res[1].capacity
                data.place = res[1].place
                data.id = res[1].id
                data.time = res[1].time
        local result = pb.encode("smart_live.get_garbage_record",data)
        return result
end

