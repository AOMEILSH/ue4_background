package.cpath = "luaclib/?.so"
package.path = "kualib/?.lua;examples/?.lua"
local socket = require"client.socket"

local fd = socket.connect("127.0.0.1",8888)
socket.usleep(1*1000000)
local bytes = string.pack(">Hc13",13,"login,101,134")
socket.send(fd,bytes)
socket.usleep(1*1000000)
socket.close(fd)
