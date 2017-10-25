---
--- Created by admin.
--- DateTime: 2017/8/15 14:29
---
MessageParser = {

    _message_parser = {}
}
function MessageParser:regMessageParser(_id, _clazz,_target)
    if MessageParser._message_parser[_id] then
        assert(false, "\n_id [" .. _id .." ] duplicate exist parse"..MessageParser._message_parser[_id.."_target"]
        .."  ||  new parse ".._target)
    end
    print("reg parser ".._id.." to parse ".._target )

    MessageParser._message_parser[_id] = _clazz
    MessageParser._message_parser[_id.."_target"] = _target
end

function MessageParser:parse(_bufs,_len)
    local message = {}
    local _len = _len or #_bufs
    for i = 1, _len do
        local _buf = _bufs[i]
        _buf:setPos(5)
        local _id = _buf:readUInt()
        local clazz = MessageParser._message_parser[_id]
        local index=0
        if clazz then
            index=index+1
            local obj = clazz:emptyMessage()
            obj:read(_buf)
            message[index] = obj
            print(obj:toString())
        else
            print( "messsage id is not exist [" .. _id .. "]")
            --assert(clazz, "messsage id is not exist [" .. _id .. "]")
        end
    end
    return message
end

