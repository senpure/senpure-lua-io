---
--- Created by admin.
--- DateTime: 2017/8/14 13:26
---
Bulider ={}

function Bulider:pack(_msg)
    local _buf = ByteArray.new(ByteArray.ENDIAN_BIG)
    _buf:writeUInt(12)
    _buf:writeUInt(_msg._id)
    _msg:write(_buf, _msg)
    _buf:setPos(1)
    _buf:writeUInt(_buf:getLen()-4)
    return _buf:getPack();
end