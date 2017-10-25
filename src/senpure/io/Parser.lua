---
--- Created by admin.
--- DateTime: 2017/8/10 16:43
---
Parser = {}

local function writeBytes( _buf, _data, _len )
    for i = 1, _len do
        _buf:writeRawByte(_data:readRawByte())
    end
end

local function printDeatil(_buf)
    _buf:setPos(5)
    print("messageId is " .. _buf:readUInt())
    --print("message is " .. _buf:readStringBytes(_buf:readUInt()))
    --print("message is "..buf:readStringBytes(0))
end
--[[
    解析数据包，处理沾包半包等
    数据格式包长int(不含该字段) ，消息id int ,二进制数据
    [packageLen][messageId][message]
    [10]        [1234]     [666666]
--]]

function Parser:readMessage(_data)

    local _buf = ByteArray.new(ByteArray.ENDIAN_BIG)
    _buf:writeBuf(_data)
    _buf:setPos(1)
   -- print("[ socket data] " .. _buf:toString())
    local _message = {}
    local _messageCount=0
    local _dataLen = _buf:getLen();
    --print("this data length is " .. _dataLen)
    --读取数据
    while true do
      --  print("while able" .. _buf:getAvailable() )
        if _buf:getAvailable() <= 0 then
            break
        end
        if not self._buffer then
          --  print("new buffer")
            self._buffer = ByteArray.new(ByteArray.ENDIAN_BIG)
            self._lenbuffer = ByteArray.new(ByteArray.ENDIAN_BIG)
            -- self.packageLen=-1;
        else
            --上次半包
            --self.buffer:setPos(self.buffer:getLen() + 1)
            --self.buffer:setPos( 1)
        end
       -- print("buffer pos :" .. self._buffer:getPos() .. " , dataPos : " .. _buf:getPos())
        local _bufferLen = self._buffer:getLen()
       -- print("bufferLen is " .. _bufferLen .. ",dataLen is " .. _dataLen)
        if self._packageLen == nil then
            if _dataLen >= 4 then
                local _needLen = 4 - _bufferLen
                writeBytes(self._buffer, _buf, _needLen )
                _bufferLen = _bufferLen + _needLen
                _dataLen = _dataLen - _needLen
            else
                writeBytes(self._buffer, _buf, _dataLen )
                _bufferLen = _bufferLen + _dataLen
                _dataLen = 0
            end
            if _bufferLen >= 4 then
                local _pos = self._buffer:getPos()
                self._buffer:setPos(1)
               -- print("read len :" .. self._buffer:toString())
                local _len = self._buffer:readUInt();
                self._buffer:setPos(_pos)
                --print("readPackageLen " .. _len)
                self._packageLen = _len;
            else
                break
            end
        end

        local _totalLen = _dataLen + _bufferLen
        if _totalLen < 0 then
            return
        end
       -- print("this package length is " .. self._packageLen .. "  totalLen is " .. _totalLen)
        --不够一个数据包
        if self._packageLen > (_totalLen-4) then
           -- print("no data len " .. _dataLen)
           -- print("no dataBuf pos is " .. _buf:getPos())
            writeBytes(self._buffer, _buf, _dataLen)
            --print("no buffer :" .. self._buffer:toString())
           -- print("no dataBuf pos is " .. _buf:getPos())
        else
           -- print("yes buffer bofore Len:" .. _bufferLen)
            local _useLen = self._packageLen - _bufferLen + 4
            writeBytes(self._buffer, _buf, _useLen)
           -- print("yes buffer :" .. self._buffer:toString())
           -- print("yes dataBuf pos is " .. _buf:getPos())
            _dataLen = _dataLen - _useLen;
        --
           -- print("this message " .. self._buffer:toString())
           -- printDeatil(self._buffer)
            _messageCount=_messageCount+1
            _message[_messageCount]=self._buffer
            --print(self._buffer:toString())
            self._buffer = nil;
            self._packageLen = nil;
        end
    end
    return _message
end

