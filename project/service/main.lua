
local skynet = require "skynet"
local skynet_manager = require "skynet.manager"
local runconfig = require "runconfig"
local cluster = require "skynet.cluster"


skynet.start(function()
	--初始化
	local mynode = skynet.getenv("node")
	local nodecfg = runconfig[mynode]
	--节点管理
	local nodemgr = skynet.newservice("nodemgr","nodemgr", 0)
	skynet.name("nodemgr", nodemgr)
	--集群
	cluster.reload(runconfig.cluster)
	cluster.open(mynode)
	--gate
	for i, v in pairs(nodecfg.gateway or {}) do
		local srv = skynet.newservice("gateway","gateway", i)
		skynet.name("gateway"..i, srv)
	end
	--login
	for i, v in pairs(nodecfg.login or {})  do
	local srv = skynet.newservice("login","login", i)
		skynet.name("login"..i, srv)
	end
	--agentmgr和admin
	local anode = runconfig.agentmgr.node
	if mynode == anode then
		local srv = skynet.newservice("agentmgr", "agentmgr", 0)
		skynet.name("agentmgr", srv)
		local admin = skynet.newservice("admin","admin",0)
	else
		local proxy = cluster.proxy(anode, "agentmgr")
		skynet.name("agentmgr", proxy)
	end
	--scene (sid->sceneid)
	--for _, sid in pairs(runconfig.scene[mynode] or {}) do
	--	local srv = skynet.newservice("scene", "scene", sid)
	--	skynet.name("scene"..sid, srv)
	--end

	--退出自身
	--unattended系统开启
	local unode = runconfig.unattended.node
	if mynode == unode then
		local srv = skynet.newservice("unattended","unattended",0)
		skynet.name("unattended",srv)
		skynet.error(unode)
	end

	--smart_management系统开启
	local smnode = runconfig.smartmanagement.node
	if mynode == smnode then
	        local srv = skynet.newservice("smartmanagement","smartmanagement",0)
                skynet.name("smartmanagement",srv)
                skynet.error(smnode)	
	end
        skynet.exit()
end)
