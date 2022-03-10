
local skynet = require "skynet"
local cjson = require "cjson"
local mysql = require "skynet.db.mysql"
local pb = require "protobuf"
local db = nil
function test1()
	pb.register_file("./storage/playerdata.pb")
	local playerdata = {
		playerid = 108,
		coin = 97,
		name = "Tiny",
		level = 4,
		last_login_time = os.time(),
	}

	local sql = string.format("select * from baseinfo where playerid = 108")
	local res = db:query(sql)
	local data = res[1].data	
	local udata = pb.decode("playerdata.BaseInfo",data)
	if not udata then
		print("error:"..res.err)
		return false
	end

	print("coin:"..udata.coin)
	print("name:"..udata.name)
	print("time:"..playerdata.last_login_time)
end

skynet.start(function()

	db=mysql.connect({
		host="120.77.58.14",
		port=3306,
		database="player_data",
		user="root",
		password="123456",
		max_packet_size = 1024 * 1024,
		on_connect = nil
    	})	


	test1()
end)
