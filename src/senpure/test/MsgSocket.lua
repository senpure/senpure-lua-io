
local socket = require("socket")
require("senpure.test.Require")
host = "127.0.0.1"
port = 1111
--打开一个TCP连接
c = assert(socket.connect(host, port))
c:settimeout(0)
local login = MSG.CSLoginMessage:new();
login._token="7889"
c:send( Bulider:pack(login))
local msg = MSG.CSQuickGameMessage:new();
c:send( Bulider:pack(msg))
local recive = false
while (true) do
    local message
    local s, status, partial = c:receive(1280)
    if s then
        recive = true
        message = Parser:readMessage(s)
    end
    if partial and #partial > 0 then
        recive = true
        message = Parser:readMessage(partial)
    end
    if message then
        local _len = #message
        if _len > 0 then
            MessageParser:parse(message)
        end
    end
    --  print("data"..s or "null"..",partial"..partial or "null")
    if status == "closed" then
        break
    end
    if status == "timeout" then
        if not recive then
          --  c:send( Bulider:pack(msg))
        end
        --
    end
end
c:close()