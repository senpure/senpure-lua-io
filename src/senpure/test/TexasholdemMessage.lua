--[[
com.jhd.game.texasholdem

Bean    :MSG.TexasAction            玩家操作选项
Bean    :MSG.GameRoom               德州扑克房间
Bean    :MSG.TexasCards             德州扑克的牌型
Bean    :MSG.Player                 玩家信息
Bean    :MSG.Seat                   座位信息

Message :MSG.CSLoginMessage         cs_login_message           100101   请求登录
Message :MSG.SCLoginMessage         sc_login_message           100102   登录返回
Message :MSG.CSCreateRoomMessage    cs_create_room_message     100103   请求创建房间
Message :MSG.SCCreateRoomMessage    sc_create_room_message     100104   请求创建房间返回
Message :MSG.CSEntryRoomMessage     cs_entry_room_message      100105   请求进入房间
Message :MSG.SCEntryRoomMessage     sc_entry_room_message      100106   玩家进入房间返回
Message :MSG.CSSitMessage           cs_sit_message             100107   请求坐下
Message :MSG.SCSitMessage           sc_sit_message             100108   玩家坐下通知
Message :MSG.CSBetMessage           cs_bet_message             100109   请求下注
Message :MSG.SCBetMessage           sc_bet_message             100110   玩家下注通知
Message :MSG.CSCheckMessage         cs_check_message           100111   请求过
Message :MSG.SCCheckMessage         sc_check_message           100112   玩家过牌通知
Message :MSG.CSFoldMessage          cs_fold_message            100113   请求弃牌
Message :MSG.SCFoldMessage          sc_fold_message            100114   玩家弃牌通知
Message :MSG.CSAllinMessage         cs_allin_message           100115   请求Allin
Message :MSG.SCAllinMessage         sc_allin_message           100116   玩家Allin通知
Message :MSG.CSQuickGameMessage     cs_quick_game_message      100117   快速游戏
Message :MSG.CSReadyGameMessage     cs_ready_game_message      100119   准备/取消
Message :MSG.SCReadyGameMessage     sc_ready_game_message      100120   准备/取消通知
Message :MSG.CSStandMessage         cs_stand_message           100121   请求站起
Message :MSG.SCStandMessage         sc_stand_message           100122   玩家站起通知
Message :MSG.CSCallMessage          cs_call_message            100123   请求跟注
Message :MSG.SCCallMessage          sc_call_message            100124   请求跟注返回
Message :MSG.SCStartGameMessage     sc_start_game_message      100200   游戏开始
Message :MSG.SCPublicCardsMessage   sc_public_cards_message    100201   当前的所有公共牌
Message :MSG.SCOnlineChangeMessage  sc_online_change_message   100202   玩家在线状态改变
Message :MSG.SCActionTurnMessage    sc_action_turn_message     100203   轮到玩家操作

author senpure-generator
version 2017-9-19 18:22:37
--]]
    MSG =  MSG or {}

function rightPad(_str, _pad)
    local _str_len = #_str
    for i = 1, _pad do
        if i > _str_len then
            _str = _str .. " "
        end
    end
    return _str
end
--[[
    玩家操作选项
--]]
MSG.TexasAction = {
    --类型:String 玩家可操作选项  CALL,FOLD, CHECK,RAISE,ALLIN
    _type = "";
    --格式化时统一字段长度
    _filedPad =5 ;
}
--MSG.TexasAction构造方法
function MSG.TexasAction:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--TexasAction写入字节缓存
function MSG.TexasAction:write(buf)
    --玩家可操作选项  CALL,FOLD, CHECK,RAISE,ALLIN
    local _type = string.pack(buf:_getLC("A"), self._type)
    buf:writeUInt(#_type)
    buf:writeBuf(_type)
end

--MSG.TexasAction读取字节缓存
function MSG.TexasAction:read(buf)
    --玩家可操作选项  CALL,FOLD, CHECK,RAISE,ALLIN
    local _type_len = buf:readUInt()
    if _type_len > 0 then
        self._type= buf:readStringBytes(_type_len)
    else
        self._type= ""
    end
end

--MSG.TexasAction 格式化字符串
function MSG.TexasAction:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."TexasAction" .. "{"
    --玩家可操作选项  CALL,FOLD, CHECK,RAISE,ALLIN
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_type", self._filedPad).. " = "..self._type
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    德州扑克房间
--]]
MSG.GameRoom = {
    --类型:int    房间ID
    _room_id = 0;
    --类型:String 房间状态 CLOSING, CLOSED, READYING, PLAYING
    _state = "";
    --list:double 筹码边池
    _edge_pool = nil;
    --类型:double 筹码池
    _chip_pool = 0;
    --类型:double 大盲注
    _big_blind = 0;
    --类型:int    大盲注位置
    _big_blind_index = 0;
    --类型:int    小盲注位置
    _small_blind_index = 0;
    --类型:int    当前轮到做动作的位置
    _current_index = 0;
    --list:int    公共牌
    _public_cards = nil;
    --list:MSG.Seat座位
    _seats = nil;
    --类型:double 房间创建时间
    _create_time = 0;
    --类型:int    房间创建玩家ID
    _create_player_id = 0;
    --类型:int    玩了几局了
    _played_round = 0;
    --缩进18 + 3 = 21 个空格
    _next_indent = "                     ";
    --格式化时统一字段长度
    _filedPad =18 ;
}
--MSG.GameRoom构造方法
function MSG.GameRoom:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--GameRoom写入字节缓存
function MSG.GameRoom:write(buf)
    --房间ID
    buf:writeInt(self._room_id)
    --房间状态 CLOSING, CLOSED, READYING, PLAYING
    local _state = string.pack(buf:_getLC("A"), self._state)
    buf:writeUInt(#_state)
    buf:writeBuf(_state)
    --筹码边池
    if self._edge_pool then
        local _edge_pool_len = #self._edge_pool
        self:writeUShort(_edge_pool_len)
        if _edge_pool_len > 0 then
            for i = 1, _edge_pool_len do
                buf:writeDouble(self._edge_pool[i])
            end
        end
    end
    --筹码池
    buf:writeDouble(self._chip_pool)
    --大盲注
    buf:writeDouble(self._big_blind)
    --大盲注位置
    buf:writeInt(self._big_blind_index)
    --小盲注位置
    buf:writeInt(self._small_blind_index)
    --当前轮到做动作的位置
    buf:writeInt(self._current_index)
    --公共牌
    if self._public_cards then
        local _public_cards_len = #self._public_cards
        self:writeUShort(_public_cards_len)
        if _public_cards_len > 0 then
            for i = 1, _public_cards_len do
                buf:writeInt(self._public_cards[i])
            end
        end
    end
    --座位
    if self._seats then
        local _seats_len = #self._seats
        self:writeUShort(_seats_len)
        if _seats_len > 0 then
            for i = 1, _seats_len do
                self._seats[i]:write(buf)
            end
        end
    end
    --房间创建时间
    buf:writeDouble(self._create_time)
    --房间创建玩家ID
    buf:writeInt(self._create_player_id)
    --玩了几局了
    buf:writeInt(self._played_round)
end

--MSG.GameRoom读取字节缓存
function MSG.GameRoom:read(buf)
    --房间ID
    self._room_id = buf:readInt()
    --房间状态 CLOSING, CLOSED, READYING, PLAYING
    local _state_len = buf:readUInt()
    if _state_len > 0 then
        self._state= buf:readStringBytes(_state_len)
    else
        self._state= ""
    end
    --筹码边池
    local _edge_pool_len  =  buf:readUShort()
    if _edge_pool_len > 0 then
        local _edge_pool_list={}
        for i=1,_edge_pool_len do
            _edge_pool_list[i] = buf:readDouble()
        end
        self._edge_pool = _edge_pool_list
    end
    --筹码池
    self._chip_pool = buf:readDouble()
    --大盲注
    self._big_blind = buf:readDouble()
    --大盲注位置
    self._big_blind_index = buf:readInt()
    --小盲注位置
    self._small_blind_index = buf:readInt()
    --当前轮到做动作的位置
    self._current_index = buf:readInt()
    --公共牌
    local _public_cards_len  =  buf:readUShort()
    if _public_cards_len > 0 then
        local _public_cards_list={}
        for i=1,_public_cards_len do
            _public_cards_list[i] = buf:readInt()
        end
        self._public_cards = _public_cards_list
    end
    --座位
    local _seats_len  =  buf:readUShort()
    if _seats_len > 0 then
        local _seats_list={}
        for i=1,_seats_len do
            local _seat =MSG.Seat:new()
            _seat:read(buf)
            _seats_list[i] = _seat
        end
        self._seats = _seats_list
    end
    --房间创建时间
    self._create_time = buf:readDouble()
    --房间创建玩家ID
    self._create_player_id = buf:readInt()
    --玩了几局了
    self._played_round = buf:readInt()
end

--MSG.GameRoom 格式化字符串
function MSG.GameRoom:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."GameRoom" .. "{"
    --房间ID
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_room_id", self._filedPad).. " = "..self._room_id
    --房间状态 CLOSING, CLOSED, READYING, PLAYING
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_state", self._filedPad).. " = "..self._state
    --筹码边池
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_edge_pool", self._filedPad).. " = "
    if self._edge_pool then
        local _edge_pool_len = #self._edge_pool
        if _edge_pool_len > 0 then
            _str = _str.."["
            for i = 1,_edge_pool_len do
                _str = _str.."\n"
                _str = _str .. self._next_indent
                _str = _str.._indent..self._edge_pool[i]
            end
            _str = _str.."\n"
            _str = _str..self._next_indent
            _str = _str.._indent.."]"
        else
            _str = _str.."nil "
        end
    else 
        _str = _str.."nil "
    end
    --筹码池
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_chip_pool", self._filedPad).. " = "..self._chip_pool
    --大盲注
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_big_blind", self._filedPad).. " = "..self._big_blind
    --大盲注位置
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_big_blind_index", self._filedPad).. " = "..self._big_blind_index
    --小盲注位置
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_small_blind_index", self._filedPad).. " = "..self._small_blind_index
    --当前轮到做动作的位置
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_current_index", self._filedPad).. " = "..self._current_index
    --公共牌
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_public_cards", self._filedPad).. " = "
    if self._public_cards then
        local _public_cards_len = #self._public_cards
        if _public_cards_len > 0 then
            _str = _str.."["
            for i = 1,_public_cards_len do
                _str = _str.."\n"
                _str = _str .. self._next_indent
                _str = _str.._indent..self._public_cards[i]
            end
            _str = _str.."\n"
            _str = _str..self._next_indent
            _str = _str.._indent.."]"
        else
            _str = _str.."nil "
        end
    else 
        _str = _str.."nil "
    end
    --座位
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seats", self._filedPad).. " = "
    if self._seats then
        local _seats_len = #self._seats
        if _seats_len > 0 then
            _str = _str.."["
            for i = 1,_seats_len do
                _str = _str.."\n"
                _str = _str..self._next_indent
                _str = _str.._indent..self._seats[i]:toString(_indent .. self._next_indent)
            end
            _str = _str.."\n"
            _str = _str..self._next_indent
            _str = _str.._indent.."]"
        else
            _str = _str.."nil "
        end
    else 
        _str = _str.."nil "
    end
    --房间创建时间
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_create_time", self._filedPad).. " = "..self._create_time
    --房间创建玩家ID
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_create_player_id", self._filedPad).. " = "..self._create_player_id
    --玩了几局了
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_played_round", self._filedPad).. " = "..self._played_round
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    德州扑克的牌型
--]]
MSG.TexasCards = {
    --类型:String 牌型 HIGH_CARD, PAIR_CARD, TWO_PAIRS_CARD, THREE_CARD, STRAIGHT, FLUSH, FULL_HOUSE, FOUR_OF_A_KIND, STRAIGHT_FLUSH, ROYAL_FLUSH
    _type = "";
    --list:int    牌
    _cards = nil;
    --缩进6 + 3 = 9 个空格
    _next_indent = "         ";
    --格式化时统一字段长度
    _filedPad =6 ;
}
--MSG.TexasCards构造方法
function MSG.TexasCards:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--TexasCards写入字节缓存
function MSG.TexasCards:write(buf)
    --牌型 HIGH_CARD, PAIR_CARD, TWO_PAIRS_CARD, THREE_CARD, STRAIGHT, FLUSH, FULL_HOUSE, FOUR_OF_A_KIND, STRAIGHT_FLUSH, ROYAL_FLUSH
    local _type = string.pack(buf:_getLC("A"), self._type)
    buf:writeUInt(#_type)
    buf:writeBuf(_type)
    --牌
    if self._cards then
        local _cards_len = #self._cards
        self:writeUShort(_cards_len)
        if _cards_len > 0 then
            for i = 1, _cards_len do
                buf:writeInt(self._cards[i])
            end
        end
    end
end

--MSG.TexasCards读取字节缓存
function MSG.TexasCards:read(buf)
    --牌型 HIGH_CARD, PAIR_CARD, TWO_PAIRS_CARD, THREE_CARD, STRAIGHT, FLUSH, FULL_HOUSE, FOUR_OF_A_KIND, STRAIGHT_FLUSH, ROYAL_FLUSH
    local _type_len = buf:readUInt()
    if _type_len > 0 then
        self._type= buf:readStringBytes(_type_len)
    else
        self._type= ""
    end
    --牌
    local _cards_len  =  buf:readUShort()
    if _cards_len > 0 then
        local _cards_list={}
        for i=1,_cards_len do
            _cards_list[i] = buf:readInt()
        end
        self._cards = _cards_list
    end
end

--MSG.TexasCards 格式化字符串
function MSG.TexasCards:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."TexasCards" .. "{"
    --牌型 HIGH_CARD, PAIR_CARD, TWO_PAIRS_CARD, THREE_CARD, STRAIGHT, FLUSH, FULL_HOUSE, FOUR_OF_A_KIND, STRAIGHT_FLUSH, ROYAL_FLUSH
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_type", self._filedPad).. " = "..self._type
    --牌
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_cards", self._filedPad).. " = "
    if self._cards then
        local _cards_len = #self._cards
        if _cards_len > 0 then
            _str = _str.."["
            for i = 1,_cards_len do
                _str = _str.."\n"
                _str = _str .. self._next_indent
                _str = _str.._indent..self._cards[i]
            end
            _str = _str.."\n"
            _str = _str..self._next_indent
            _str = _str.._indent.."]"
        else
            _str = _str.."nil "
        end
    else 
        _str = _str.."nil "
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家信息
--]]
MSG.Player = {
    --类型:int    玩家ID
    _id = 0;
    --类型:String 玩家昵称
    _nick = "";
    --类型:String 玩家头像
    _head = "";
    --类型:double 玩家总筹码
    _chip = 0;
    --类型:double 玩家在牌局中筹码
    _playing_chip = 0;
    --缩进13 + 3 = 16 个空格
    _next_indent = "                ";
    --格式化时统一字段长度
    _filedPad =13 ;
}
--MSG.Player构造方法
function MSG.Player:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--Player写入字节缓存
function MSG.Player:write(buf)
    --玩家ID
    buf:writeInt(self._id)
    --玩家昵称
    local _nick = string.pack(buf:_getLC("A"), self._nick)
    buf:writeUInt(#_nick)
    buf:writeBuf(_nick)
    --玩家头像
    local _head = string.pack(buf:_getLC("A"), self._head)
    buf:writeUInt(#_head)
    buf:writeBuf(_head)
    --玩家总筹码
    buf:writeDouble(self._chip)
    --玩家在牌局中筹码
    buf:writeDouble(self._playing_chip)
end

--MSG.Player读取字节缓存
function MSG.Player:read(buf)
    --玩家ID
    self._id = buf:readInt()
    --玩家昵称
    local _nick_len = buf:readUInt()
    if _nick_len > 0 then
        self._nick= buf:readStringBytes(_nick_len)
    else
        self._nick= ""
    end
    --玩家头像
    local _head_len = buf:readUInt()
    if _head_len > 0 then
        self._head= buf:readStringBytes(_head_len)
    else
        self._head= ""
    end
    --玩家总筹码
    self._chip = buf:readDouble()
    --玩家在牌局中筹码
    self._playing_chip = buf:readDouble()
end

--MSG.Player 格式化字符串
function MSG.Player:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."Player" .. "{"
    --玩家ID
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_id", self._filedPad).. " = "..self._id
    --玩家昵称
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_nick", self._filedPad).. " = "..self._nick
    --玩家头像
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_head", self._filedPad).. " = "..self._head
    --玩家总筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_chip", self._filedPad).. " = "..self._chip
    --玩家在牌局中筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_playing_chip", self._filedPad).. " = "..self._playing_chip
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    座位信息
--]]
MSG.Seat = {
    --类型:int    座位编号(下标为零开始)
    _index = 0;
    --类型:String 座位状态 IDLE, WATCH, READY, PLAYING,FOLDED,ALLIN
    _state = "";
    --类型:boolean是否在线
    _online = false;
    --类型:double 本轮下的筹码
    _bet_chip = 0;
    --类型:double 本阶段的筹码
    _phase_bet_chip = 0;
    --类型:double 轮到该座位的时间
    _turn_time = 0;
    --类型:MSG.Player座位上的玩家
    _player= nil ;
    --list:int    手牌
    _hand_cards = nil;
    --类型:MSG.TexasCards牌型
    _texas_cards= nil ;
    --缩进15 + 3 = 18 个空格
    _next_indent = "                  ";
    --格式化时统一字段长度
    _filedPad =15 ;
}
--MSG.Seat构造方法
function MSG.Seat:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--Seat写入字节缓存
function MSG.Seat:write(buf)
    --座位编号(下标为零开始)
    buf:writeInt(self._index)
    --座位状态 IDLE, WATCH, READY, PLAYING,FOLDED,ALLIN
    local _state = string.pack(buf:_getLC("A"), self._state)
    buf:writeUInt(#_state)
    buf:writeBuf(_state)
    --是否在线
    buf:writeBool(self._online)
    --本轮下的筹码
    buf:writeDouble(self._bet_chip)
    --本阶段的筹码
    buf:writeDouble(self._phase_bet_chip)
    --轮到该座位的时间
    buf:writeDouble(self._turn_time)
    --座位上的玩家
    if self._player then
        buf:writeByte(1)
        self._player:write(buf)
    else
        buf:writeByte(0)
    end
    --手牌
    if self._hand_cards then
        local _hand_cards_len = #self._hand_cards
        self:writeUShort(_hand_cards_len)
        if _hand_cards_len > 0 then
            for i = 1, _hand_cards_len do
                buf:writeInt(self._hand_cards[i])
            end
        end
    end
    --牌型
    if self._texas_cards then
        buf:writeByte(1)
        self._texas_cards:write(buf)
    else
        buf:writeByte(0)
    end
end

--MSG.Seat读取字节缓存
function MSG.Seat:read(buf)
    --座位编号(下标为零开始)
    self._index = buf:readInt()
    --座位状态 IDLE, WATCH, READY, PLAYING,FOLDED,ALLIN
    local _state_len = buf:readUInt()
    if _state_len > 0 then
        self._state= buf:readStringBytes(_state_len)
    else
        self._state= ""
    end
    --是否在线
    self._online = buf:readBool()
    --本轮下的筹码
    self._bet_chip = buf:readDouble()
    --本阶段的筹码
    self._phase_bet_chip = buf:readDouble()
    --轮到该座位的时间
    self._turn_time = buf:readDouble()
    --座位上的玩家
    local _have_player= buf:readByte()
    if _have_player ==1 then
        local _player = MSG.Player:new()
        _player:read(buf)
        self._player=_player
    end
    --手牌
    local _hand_cards_len  =  buf:readUShort()
    if _hand_cards_len > 0 then
        local _hand_cards_list={}
        for i=1,_hand_cards_len do
            _hand_cards_list[i] = buf:readInt()
        end
        self._hand_cards = _hand_cards_list
    end
    --牌型
    local _have_texas_cards= buf:readByte()
    if _have_texas_cards ==1 then
        local _texas_cards = MSG.TexasCards:new()
        _texas_cards:read(buf)
        self._texas_cards=_texas_cards
    end
end

--MSG.Seat 格式化字符串
function MSG.Seat:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."Seat" .. "{"
    --座位编号(下标为零开始)
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_index", self._filedPad).. " = "..self._index
    --座位状态 IDLE, WATCH, READY, PLAYING,FOLDED,ALLIN
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_state", self._filedPad).. " = "..self._state
    --是否在线
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_online", self._filedPad).. " = "..tostring(self._online)

    --本轮下的筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_bet_chip", self._filedPad).. " = "..self._bet_chip
    --本阶段的筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_phase_bet_chip", self._filedPad).. " = "..self._phase_bet_chip
    --轮到该座位的时间
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_turn_time", self._filedPad).. " = "..self._turn_time
    --座位上的玩家
    _str = _str.."\n"
    if self._player then
        _str = _str.._indent..rightPad("_player", self._filedPad).. " = "..self._player:toString(_indent .. self._next_indent)
    else
        _str = _str.._indent..rightPad("_player", self._filedPad).. " = ".."nil"
    end
    --手牌
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_hand_cards", self._filedPad).. " = "
    if self._hand_cards then
        local _hand_cards_len = #self._hand_cards
        if _hand_cards_len > 0 then
            _str = _str.."["
            for i = 1,_hand_cards_len do
                _str = _str.."\n"
                _str = _str .. self._next_indent
                _str = _str.._indent..self._hand_cards[i]
            end
            _str = _str.."\n"
            _str = _str..self._next_indent
            _str = _str.._indent.."]"
        else
            _str = _str.."nil "
        end
    else 
        _str = _str.."nil "
    end
    --牌型
    _str = _str.."\n"
    if self._texas_cards then
        _str = _str.._indent..rightPad("_texas_cards", self._filedPad).. " = "..self._texas_cards:toString(_indent .. self._next_indent)
    else
        _str = _str.._indent..rightPad("_texas_cards", self._filedPad).. " = ".."nil"
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end


--[[
    请求登录
--]]
MSG.CSLoginMessage = {
    --message_id
    _id = 100101;
    _message_name = "cs_login_message";
    --类型:String 服务器给的唯一标识
    _token = "";
    --缩进6 + 3 = 9 个空格
    _next_indent = "         ";
    --格式化时统一字段长度
    _filedPad =6 ;
}
--MSG.CSLoginMessage构造方法
function MSG.CSLoginMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSLoginMessage写入字节缓存
function MSG.CSLoginMessage:write(buf)
    --服务器给的唯一标识
    local _token = string.pack(buf:_getLC("A"), self._token)
    buf:writeUInt(#_token)
    buf:writeBuf(_token)
end


--MSG.CSLoginMessage 格式化字符串
function MSG.CSLoginMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSLoginMessage" .. "{"
    --服务器给的唯一标识
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_token", self._filedPad).. " = "..self._token
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    登录返回
--]]
MSG.SCLoginMessage = {
    --message_id
    _id = 100102;
    _message_name = "sc_login_message";
    --类型:MSG.Player玩家信息
    _player= nil ;
    --缩进7 + 3 = 10 个空格
    _next_indent = "          ";
    --格式化时统一字段长度
    _filedPad =7 ;
}
--MSG.SCLoginMessage构造方法
function MSG.SCLoginMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCLoginMessage读取字节缓存
function MSG.SCLoginMessage:read(buf)
    --玩家信息
    local _have_player= buf:readByte()
    if _have_player ==1 then
        local _player = MSG.Player:new()
        _player:read(buf)
        self._player=_player
    end
end

--MSG.SCLoginMessage 格式化字符串
function MSG.SCLoginMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCLoginMessage" .. "{"
    --玩家信息
    _str = _str.."\n"
    if self._player then
        _str = _str.._indent..rightPad("_player", self._filedPad).. " = "..self._player:toString(_indent .. self._next_indent)
    else
        _str = _str.._indent..rightPad("_player", self._filedPad).. " = ".."nil"
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求创建房间
--]]
MSG.CSCreateRoomMessage = {
    --message_id
    _id = 100103;
    _message_name = "cs_create_room_message";
    --类型:String 房间名
    _name = "";
    --类型:double 前注
    _ante = 0;
    --类型:double 大盲注
    _big_blind = 0;
    --类型:double 玩多久(毫秒数)
    _how_long_time = 0;
    --类型:double 初始筹码
    _chip = 0;
    --类型:double 最大筹码
    _max_chip = 0;
    --缩进14 + 3 = 17 个空格
    _next_indent = "                 ";
    --格式化时统一字段长度
    _filedPad =14 ;
}
--MSG.CSCreateRoomMessage构造方法
function MSG.CSCreateRoomMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSCreateRoomMessage写入字节缓存
function MSG.CSCreateRoomMessage:write(buf)
    --房间名
    local _name = string.pack(buf:_getLC("A"), self._name)
    buf:writeUInt(#_name)
    buf:writeBuf(_name)
    --前注
    buf:writeDouble(self._ante)
    --大盲注
    buf:writeDouble(self._big_blind)
    --玩多久(毫秒数)
    buf:writeDouble(self._how_long_time)
    --初始筹码
    buf:writeDouble(self._chip)
    --最大筹码
    buf:writeDouble(self._max_chip)
end


--MSG.CSCreateRoomMessage 格式化字符串
function MSG.CSCreateRoomMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSCreateRoomMessage" .. "{"
    --房间名
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_name", self._filedPad).. " = "..self._name
    --前注
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_ante", self._filedPad).. " = "..self._ante
    --大盲注
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_big_blind", self._filedPad).. " = "..self._big_blind
    --玩多久(毫秒数)
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_how_long_time", self._filedPad).. " = "..self._how_long_time
    --初始筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_chip", self._filedPad).. " = "..self._chip
    --最大筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_max_chip", self._filedPad).. " = "..self._max_chip
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求创建房间返回
--]]
MSG.SCCreateRoomMessage = {
    --message_id
    _id = 100104;
    _message_name = "sc_create_room_message";
    --类型:MSG.GameRoom房间信息
    _room= nil ;
    --缩进5 + 3 = 8 个空格
    _next_indent = "        ";
    --格式化时统一字段长度
    _filedPad =5 ;
}
--MSG.SCCreateRoomMessage构造方法
function MSG.SCCreateRoomMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCCreateRoomMessage读取字节缓存
function MSG.SCCreateRoomMessage:read(buf)
    --房间信息
    local _have_room= buf:readByte()
    if _have_room ==1 then
        local _room = MSG.GameRoom:new()
        _room:read(buf)
        self._room=_room
    end
end

--MSG.SCCreateRoomMessage 格式化字符串
function MSG.SCCreateRoomMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCCreateRoomMessage" .. "{"
    --房间信息
    _str = _str.."\n"
    if self._room then
        _str = _str.._indent..rightPad("_room", self._filedPad).. " = "..self._room:toString(_indent .. self._next_indent)
    else
        _str = _str.._indent..rightPad("_room", self._filedPad).. " = ".."nil"
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求进入房间
--]]
MSG.CSEntryRoomMessage = {
    --message_id
    _id = 100105;
    _message_name = "cs_entry_room_message";
    --类型:int    房间Id
    _room_id = 0;
    --类型:boolean是否坐下
    _sit = false;
    --缩进8 + 3 = 11 个空格
    _next_indent = "           ";
    --格式化时统一字段长度
    _filedPad =8 ;
}
--MSG.CSEntryRoomMessage构造方法
function MSG.CSEntryRoomMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSEntryRoomMessage写入字节缓存
function MSG.CSEntryRoomMessage:write(buf)
    --房间Id
    buf:writeInt(self._room_id)
    --是否坐下
    buf:writeBool(self._sit)
end


--MSG.CSEntryRoomMessage 格式化字符串
function MSG.CSEntryRoomMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSEntryRoomMessage" .. "{"
    --房间Id
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_room_id", self._filedPad).. " = "..self._room_id
    --是否坐下
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_sit", self._filedPad).. " = "..tostring(self._sit)

    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家进入房间返回
--]]
MSG.SCEntryRoomMessage = {
    --message_id
    _id = 100106;
    _message_name = "sc_entry_room_message";
    --类型:MSG.GameRoom房间信息
    _room= nil ;
    --缩进5 + 3 = 8 个空格
    _next_indent = "        ";
    --格式化时统一字段长度
    _filedPad =5 ;
}
--MSG.SCEntryRoomMessage构造方法
function MSG.SCEntryRoomMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCEntryRoomMessage读取字节缓存
function MSG.SCEntryRoomMessage:read(buf)
    --房间信息
    local _have_room= buf:readByte()
    if _have_room ==1 then
        local _room = MSG.GameRoom:new()
        _room:read(buf)
        self._room=_room
    end
end

--MSG.SCEntryRoomMessage 格式化字符串
function MSG.SCEntryRoomMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCEntryRoomMessage" .. "{"
    --房间信息
    _str = _str.."\n"
    if self._room then
        _str = _str.._indent..rightPad("_room", self._filedPad).. " = "..self._room:toString(_indent .. self._next_indent)
    else
        _str = _str.._indent..rightPad("_room", self._filedPad).. " = ".."nil"
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求坐下
--]]
MSG.CSSitMessage = {
    --message_id
    _id = 100107;
    _message_name = "cs_sit_message";
    --类型:int    座位Id(下标为开始为0)
    _seat_index = 0;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.CSSitMessage构造方法
function MSG.CSSitMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSSitMessage写入字节缓存
function MSG.CSSitMessage:write(buf)
    --座位Id(下标为开始为0)
    buf:writeInt(self._seat_index)
end


--MSG.CSSitMessage 格式化字符串
function MSG.CSSitMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSSitMessage" .. "{"
    --座位Id(下标为开始为0)
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家坐下通知
--]]
MSG.SCSitMessage = {
    --message_id
    _id = 100108;
    _message_name = "sc_sit_message";
    --类型:MSG.Seat玩家坐下的位置
    _seat= nil ;
    --缩进5 + 3 = 8 个空格
    _next_indent = "        ";
    --格式化时统一字段长度
    _filedPad =5 ;
}
--MSG.SCSitMessage构造方法
function MSG.SCSitMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCSitMessage读取字节缓存
function MSG.SCSitMessage:read(buf)
    --玩家坐下的位置
    local _have_seat= buf:readByte()
    if _have_seat ==1 then
        local _seat = MSG.Seat:new()
        _seat:read(buf)
        self._seat=_seat
    end
end

--MSG.SCSitMessage 格式化字符串
function MSG.SCSitMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCSitMessage" .. "{"
    --玩家坐下的位置
    _str = _str.."\n"
    if self._seat then
        _str = _str.._indent..rightPad("_seat", self._filedPad).. " = "..self._seat:toString(_indent .. self._next_indent)
    else
        _str = _str.._indent..rightPad("_seat", self._filedPad).. " = ".."nil"
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求下注
--]]
MSG.CSBetMessage = {
    --message_id
    _id = 100109;
    _message_name = "cs_bet_message";
    --类型:double 下注筹码
    _chip = 0;
    --缩进5 + 3 = 8 个空格
    _next_indent = "        ";
    --格式化时统一字段长度
    _filedPad =5 ;
}
--MSG.CSBetMessage构造方法
function MSG.CSBetMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSBetMessage写入字节缓存
function MSG.CSBetMessage:write(buf)
    --下注筹码
    buf:writeDouble(self._chip)
end


--MSG.CSBetMessage 格式化字符串
function MSG.CSBetMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSBetMessage" .. "{"
    --下注筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_chip", self._filedPad).. " = "..self._chip
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家下注通知
--]]
MSG.SCBetMessage = {
    --message_id
    _id = 100110;
    _message_name = "sc_bet_message";
    --类型:double 下注筹码
    _chip = 0;
    --类型:int    下注座位编号(0开始)
    _seat_index = 0;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCBetMessage构造方法
function MSG.SCBetMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCBetMessage读取字节缓存
function MSG.SCBetMessage:read(buf)
    --下注筹码
    self._chip = buf:readDouble()
    --下注座位编号(0开始)
    self._seat_index = buf:readInt()
end

--MSG.SCBetMessage 格式化字符串
function MSG.SCBetMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCBetMessage" .. "{"
    --下注筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_chip", self._filedPad).. " = "..self._chip
    --下注座位编号(0开始)
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求过
--]]
MSG.CSCheckMessage = {
    --message_id
    _id = 100111;
    _message_name = "cs_check_message";
    --缩进0 + 3 = 3 个空格
    _next_indent = "   ";
    --格式化时统一字段长度
    _filedPad =0 ;
}
--MSG.CSCheckMessage构造方法
function MSG.CSCheckMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSCheckMessage写入字节缓存
function MSG.CSCheckMessage:write(buf)
end


--MSG.CSCheckMessage 格式化字符串
function MSG.CSCheckMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSCheckMessage" .. "{"
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家过牌通知
--]]
MSG.SCCheckMessage = {
    --message_id
    _id = 100112;
    _message_name = "sc_check_message";
    --类型:int    座位编号(0开始)
    _seat_index = 0;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCCheckMessage构造方法
function MSG.SCCheckMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCCheckMessage读取字节缓存
function MSG.SCCheckMessage:read(buf)
    --座位编号(0开始)
    self._seat_index = buf:readInt()
end

--MSG.SCCheckMessage 格式化字符串
function MSG.SCCheckMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCCheckMessage" .. "{"
    --座位编号(0开始)
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求弃牌
--]]
MSG.CSFoldMessage = {
    --message_id
    _id = 100113;
    _message_name = "cs_fold_message";
    --缩进0 + 3 = 3 个空格
    _next_indent = "   ";
    --格式化时统一字段长度
    _filedPad =0 ;
}
--MSG.CSFoldMessage构造方法
function MSG.CSFoldMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSFoldMessage写入字节缓存
function MSG.CSFoldMessage:write(buf)
end


--MSG.CSFoldMessage 格式化字符串
function MSG.CSFoldMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSFoldMessage" .. "{"
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家弃牌通知
--]]
MSG.SCFoldMessage = {
    --message_id
    _id = 100114;
    _message_name = "sc_fold_message";
    --类型:int    座位编号(0开始)
    _seat_index = 0;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCFoldMessage构造方法
function MSG.SCFoldMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCFoldMessage读取字节缓存
function MSG.SCFoldMessage:read(buf)
    --座位编号(0开始)
    self._seat_index = buf:readInt()
end

--MSG.SCFoldMessage 格式化字符串
function MSG.SCFoldMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCFoldMessage" .. "{"
    --座位编号(0开始)
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求Allin
--]]
MSG.CSAllinMessage = {
    --message_id
    _id = 100115;
    _message_name = "cs_allin_message";
    --缩进0 + 3 = 3 个空格
    _next_indent = "   ";
    --格式化时统一字段长度
    _filedPad =0 ;
}
--MSG.CSAllinMessage构造方法
function MSG.CSAllinMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSAllinMessage写入字节缓存
function MSG.CSAllinMessage:write(buf)
end


--MSG.CSAllinMessage 格式化字符串
function MSG.CSAllinMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSAllinMessage" .. "{"
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家Allin通知
--]]
MSG.SCAllinMessage = {
    --message_id
    _id = 100116;
    _message_name = "sc_allin_message";
    --类型:int    座位编号(0开始)
    _seat_index = 0;
    --类型:double allin的筹码
    _chip = 0;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCAllinMessage构造方法
function MSG.SCAllinMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCAllinMessage读取字节缓存
function MSG.SCAllinMessage:read(buf)
    --座位编号(0开始)
    self._seat_index = buf:readInt()
    --allin的筹码
    self._chip = buf:readDouble()
end

--MSG.SCAllinMessage 格式化字符串
function MSG.SCAllinMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCAllinMessage" .. "{"
    --座位编号(0开始)
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    --allin的筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_chip", self._filedPad).. " = "..self._chip
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    快速游戏
--]]
MSG.CSQuickGameMessage = {
    --message_id
    _id = 100117;
    _message_name = "cs_quick_game_message";
    --缩进0 + 3 = 3 个空格
    _next_indent = "   ";
    --格式化时统一字段长度
    _filedPad =0 ;
}
--MSG.CSQuickGameMessage构造方法
function MSG.CSQuickGameMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSQuickGameMessage写入字节缓存
function MSG.CSQuickGameMessage:write(buf)
end


--MSG.CSQuickGameMessage 格式化字符串
function MSG.CSQuickGameMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSQuickGameMessage" .. "{"
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    准备/取消
--]]
MSG.CSReadyGameMessage = {
    --message_id
    _id = 100119;
    _message_name = "cs_ready_game_message";
    --类型:boolean准备/取消 true/false
    _ready = false;
    --缩进6 + 3 = 9 个空格
    _next_indent = "         ";
    --格式化时统一字段长度
    _filedPad =6 ;
}
--MSG.CSReadyGameMessage构造方法
function MSG.CSReadyGameMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSReadyGameMessage写入字节缓存
function MSG.CSReadyGameMessage:write(buf)
    --准备/取消 true/false
    buf:writeBool(self._ready)
end


--MSG.CSReadyGameMessage 格式化字符串
function MSG.CSReadyGameMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSReadyGameMessage" .. "{"
    --准备/取消 true/false
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_ready", self._filedPad).. " = "..tostring(self._ready)

    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    准备/取消通知
--]]
MSG.SCReadyGameMessage = {
    --message_id
    _id = 100120;
    _message_name = "sc_ready_game_message";
    --类型:int    座位编号
    _seat_index = 0;
    --类型:boolean准备/取消 true/false
    _ready = false;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCReadyGameMessage构造方法
function MSG.SCReadyGameMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCReadyGameMessage读取字节缓存
function MSG.SCReadyGameMessage:read(buf)
    --座位编号
    self._seat_index = buf:readInt()
    --准备/取消 true/false
    self._ready = buf:readBool()
end

--MSG.SCReadyGameMessage 格式化字符串
function MSG.SCReadyGameMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCReadyGameMessage" .. "{"
    --座位编号
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    --准备/取消 true/false
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_ready", self._filedPad).. " = "..tostring(self._ready)

    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求站起
--]]
MSG.CSStandMessage = {
    --message_id
    _id = 100121;
    _message_name = "cs_stand_message";
    --缩进0 + 3 = 3 个空格
    _next_indent = "   ";
    --格式化时统一字段长度
    _filedPad =0 ;
}
--MSG.CSStandMessage构造方法
function MSG.CSStandMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSStandMessage写入字节缓存
function MSG.CSStandMessage:write(buf)
end


--MSG.CSStandMessage 格式化字符串
function MSG.CSStandMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSStandMessage" .. "{"
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家站起通知
--]]
MSG.SCStandMessage = {
    --message_id
    _id = 100122;
    _message_name = "sc_stand_message";
    --类型:int    座位编号
    _seat_index = 0;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCStandMessage构造方法
function MSG.SCStandMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCStandMessage读取字节缓存
function MSG.SCStandMessage:read(buf)
    --座位编号
    self._seat_index = buf:readInt()
end

--MSG.SCStandMessage 格式化字符串
function MSG.SCStandMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCStandMessage" .. "{"
    --座位编号
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求跟注
--]]
MSG.CSCallMessage = {
    --message_id
    _id = 100123;
    _message_name = "cs_call_message";
    --缩进0 + 3 = 3 个空格
    _next_indent = "   ";
    --格式化时统一字段长度
    _filedPad =0 ;
}
--MSG.CSCallMessage构造方法
function MSG.CSCallMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

--CSCallMessage写入字节缓存
function MSG.CSCallMessage:write(buf)
end


--MSG.CSCallMessage 格式化字符串
function MSG.CSCallMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."CSCallMessage" .. "{"
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    请求跟注返回
--]]
MSG.SCCallMessage = {
    --message_id
    _id = 100124;
    _message_name = "sc_call_message";
    --类型:int    座位编号(0开始)
    _seat_index = 0;
    --类型:double 跟注的筹码
    _chip = 0;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCCallMessage构造方法
function MSG.SCCallMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCCallMessage读取字节缓存
function MSG.SCCallMessage:read(buf)
    --座位编号(0开始)
    self._seat_index = buf:readInt()
    --跟注的筹码
    self._chip = buf:readDouble()
end

--MSG.SCCallMessage 格式化字符串
function MSG.SCCallMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCCallMessage" .. "{"
    --座位编号(0开始)
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    --跟注的筹码
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_chip", self._filedPad).. " = "..self._chip
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    游戏开始
--]]
MSG.SCStartGameMessage = {
    --message_id
    _id = 100200;
    _message_name = "sc_start_game_message";
    --类型:MSG.GameRoom房间信息
    _room= nil ;
    --缩进5 + 3 = 8 个空格
    _next_indent = "        ";
    --格式化时统一字段长度
    _filedPad =5 ;
}
--MSG.SCStartGameMessage构造方法
function MSG.SCStartGameMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCStartGameMessage读取字节缓存
function MSG.SCStartGameMessage:read(buf)
    --房间信息
    local _have_room= buf:readByte()
    if _have_room ==1 then
        local _room = MSG.GameRoom:new()
        _room:read(buf)
        self._room=_room
    end
end

--MSG.SCStartGameMessage 格式化字符串
function MSG.SCStartGameMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCStartGameMessage" .. "{"
    --房间信息
    _str = _str.."\n"
    if self._room then
        _str = _str.._indent..rightPad("_room", self._filedPad).. " = "..self._room:toString(_indent .. self._next_indent)
    else
        _str = _str.._indent..rightPad("_room", self._filedPad).. " = ".."nil"
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    当前的所有公共牌
--]]
MSG.SCPublicCardsMessage = {
    --message_id
    _id = 100201;
    _message_name = "sc_public_cards_message";
    --类型:String 牌局阶段 PERFLOP,FLOP,TURN,RIVER
    _phase = "";
    --list:int    当前的所有公共牌
    _public_cards = nil;
    --缩进13 + 3 = 16 个空格
    _next_indent = "                ";
    --格式化时统一字段长度
    _filedPad =13 ;
}
--MSG.SCPublicCardsMessage构造方法
function MSG.SCPublicCardsMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCPublicCardsMessage读取字节缓存
function MSG.SCPublicCardsMessage:read(buf)
    --牌局阶段 PERFLOP,FLOP,TURN,RIVER
    local _phase_len = buf:readUInt()
    if _phase_len > 0 then
        self._phase= buf:readStringBytes(_phase_len)
    else
        self._phase= ""
    end
    --当前的所有公共牌
    local _public_cards_len  =  buf:readUShort()
    if _public_cards_len > 0 then
        local _public_cards_list={}
        for i=1,_public_cards_len do
            _public_cards_list[i] = buf:readInt()
        end
        self._public_cards = _public_cards_list
    end
end

--MSG.SCPublicCardsMessage 格式化字符串
function MSG.SCPublicCardsMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCPublicCardsMessage" .. "{"
    --牌局阶段 PERFLOP,FLOP,TURN,RIVER
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_phase", self._filedPad).. " = "..self._phase
    --当前的所有公共牌
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_public_cards", self._filedPad).. " = "
    if self._public_cards then
        local _public_cards_len = #self._public_cards
        if _public_cards_len > 0 then
            _str = _str.."["
            for i = 1,_public_cards_len do
                _str = _str.."\n"
                _str = _str .. self._next_indent
                _str = _str.._indent..self._public_cards[i]
            end
            _str = _str.."\n"
            _str = _str..self._next_indent
            _str = _str.._indent.."]"
        else
            _str = _str.."nil "
        end
    else 
        _str = _str.."nil "
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    玩家在线状态改变
--]]
MSG.SCOnlineChangeMessage = {
    --message_id
    _id = 100202;
    _message_name = "sc_online_change_message";
    --类型:boolean是否在线true/false
    _online = false;
    --类型:int    座位编号
    _seat_index = 0;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCOnlineChangeMessage构造方法
function MSG.SCOnlineChangeMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCOnlineChangeMessage读取字节缓存
function MSG.SCOnlineChangeMessage:read(buf)
    --是否在线true/false
    self._online = buf:readBool()
    --座位编号
    self._seat_index = buf:readInt()
end

--MSG.SCOnlineChangeMessage 格式化字符串
function MSG.SCOnlineChangeMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCOnlineChangeMessage" .. "{"
    --是否在线true/false
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_online", self._filedPad).. " = "..tostring(self._online)

    --座位编号
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

--[[
    轮到玩家操作
--]]
MSG.SCActionTurnMessage = {
    --message_id
    _id = 100203;
    _message_name = "sc_action_turn_message";
    --类型:int    座位编号
    _seat_index = 0;
    --list:MSG.TexasAction可操作选项
    _actions = nil;
    --缩进11 + 3 = 14 个空格
    _next_indent = "              ";
    --格式化时统一字段长度
    _filedPad =11 ;
}
--MSG.SCActionTurnMessage构造方法
function MSG.SCActionTurnMessage:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end


--MSG.SCActionTurnMessage读取字节缓存
function MSG.SCActionTurnMessage:read(buf)
    --座位编号
    self._seat_index = buf:readInt()
    --可操作选项
    local _actions_len  =  buf:readUShort()
    if _actions_len > 0 then
        local _actions_list={}
        for i=1,_actions_len do
            local _texasAction =MSG.TexasAction:new()
            _texasAction:read(buf)
            _actions_list[i] = _texasAction
        end
        self._actions = _actions_list
    end
end

--MSG.SCActionTurnMessage 格式化字符串
function MSG.SCActionTurnMessage:toString(_indent)
    _indent = _indent or ""
    local _str = ""
    _str = _str.."SCActionTurnMessage" .. "{"
    --座位编号
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_seat_index", self._filedPad).. " = "..self._seat_index
    --可操作选项
    _str = _str.."\n"
    _str = _str.._indent..rightPad("_actions", self._filedPad).. " = "
    if self._actions then
        local _actions_len = #self._actions
        if _actions_len > 0 then
            _str = _str.."["
            for i = 1,_actions_len do
                _str = _str.."\n"
                _str = _str..self._next_indent
                _str = _str.._indent..self._actions[i]:toString(_indent .. self._next_indent)
            end
            _str = _str.."\n"
            _str = _str..self._next_indent
            _str = _str.._indent.."]"
        else
            _str = _str.."nil "
        end
    else 
        _str = _str.."nil "
    end
    _str =_str .."\n"
    _str = _str.._indent.."}"
    return _str
end

