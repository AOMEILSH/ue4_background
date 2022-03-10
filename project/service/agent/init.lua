local skynet = require "skynet"
local s = require "service"
s.client = {}
s.gate = nil
require "scene"
require "unattended"
function getday(timestamp)
	local day = (timestamp+3600*8)/(3600*24)
	return math.ceil(day)
end

function first_login_day()
end

s.resp.client = function(source,cmd,msg)
	s.gate = source
	if s.client[cmd] then
		local ret_msg = s.client[cmd](msg,source)
		if ret_msg then
			skynet.send(source, "lua", "send", s.id, ret_msg)
		end
	else
			skynet.error("s.resp.client fail",cmd)
	end
end

s.init = function()
	skynet.sleep(200)
	local last_login_time = nil
	if s.data then
		last_login_time = s.data.last_login_time 
	else
		last_login_time = os.time()
	end
	local last_day = getday(last_login_time)
	s.data = {
		coin = 100,
		hp = 200,
		last_login_time = os.time() 
	}
	local day = getday(os.time())
	if day>last_day then
		first_login_day()
	end
end


s.resp.kick = function(source)
	s.leave_scene()
	skynet.sleep(200)
end

s.resp.send = function(source,msg)
	skynet.send(s.gate,"lua","send",s.id,msg)
end

s.resp.exit = function(source)
	skynet.exit()
end

s.client.work = function(msg)
	s.data.coin = s.data.coin + 1
	return {"work",s.data.coin}
end



s.start(...)
