
SCLoginMessageHandler = {
--100102
_id=MSG.SCLoginMessage._id
}
function SCLoginMessageHandler:emptyMessage()
    return MSG.SCLoginMessage:new()
end
--                              100102
MessageParser:regMessageParser(SCLoginMessageHandler._id, SCLoginMessageHandler,"MSG.SCLoginMessage")

SCCreateRoomMessageHandler = {
--100104
_id=MSG.SCCreateRoomMessage._id
}
function SCCreateRoomMessageHandler:emptyMessage()
    return MSG.SCCreateRoomMessage:new()
end
--                              100104
MessageParser:regMessageParser(SCCreateRoomMessageHandler._id, SCCreateRoomMessageHandler,"MSG.SCCreateRoomMessage")

SCEntryRoomMessageHandler = {
--100106
_id=MSG.SCEntryRoomMessage._id
}
function SCEntryRoomMessageHandler:emptyMessage()
    return MSG.SCEntryRoomMessage:new()
end
--                              100106
MessageParser:regMessageParser(SCEntryRoomMessageHandler._id, SCEntryRoomMessageHandler,"MSG.SCEntryRoomMessage")

SCSitMessageHandler = {
--100108
_id=MSG.SCSitMessage._id
}
function SCSitMessageHandler:emptyMessage()
    return MSG.SCSitMessage:new()
end
--                              100108
MessageParser:regMessageParser(SCSitMessageHandler._id, SCSitMessageHandler,"MSG.SCSitMessage")

SCBetMessageHandler = {
--100110
_id=MSG.SCBetMessage._id
}
function SCBetMessageHandler:emptyMessage()
    return MSG.SCBetMessage:new()
end
--                              100110
MessageParser:regMessageParser(SCBetMessageHandler._id, SCBetMessageHandler,"MSG.SCBetMessage")

SCCheckMessageHandler = {
--100112
_id=MSG.SCCheckMessage._id
}
function SCCheckMessageHandler:emptyMessage()
    return MSG.SCCheckMessage:new()
end
--                              100112
MessageParser:regMessageParser(SCCheckMessageHandler._id, SCCheckMessageHandler,"MSG.SCCheckMessage")

SCFoldMessageHandler = {
--100114
_id=MSG.SCFoldMessage._id
}
function SCFoldMessageHandler:emptyMessage()
    return MSG.SCFoldMessage:new()
end
--                              100114
MessageParser:regMessageParser(SCFoldMessageHandler._id, SCFoldMessageHandler,"MSG.SCFoldMessage")

SCAllinMessageHandler = {
--100116
_id=MSG.SCAllinMessage._id
}
function SCAllinMessageHandler:emptyMessage()
    return MSG.SCAllinMessage:new()
end
--                              100116
MessageParser:regMessageParser(SCAllinMessageHandler._id, SCAllinMessageHandler,"MSG.SCAllinMessage")

SCReadyGameMessageHandler = {
--100120
_id=MSG.SCReadyGameMessage._id
}
function SCReadyGameMessageHandler:emptyMessage()
    return MSG.SCReadyGameMessage:new()
end
--                              100120
MessageParser:regMessageParser(SCReadyGameMessageHandler._id, SCReadyGameMessageHandler,"MSG.SCReadyGameMessage")

SCStandMessageHandler = {
--100122
_id=MSG.SCStandMessage._id
}
function SCStandMessageHandler:emptyMessage()
    return MSG.SCStandMessage:new()
end
--                              100122
MessageParser:regMessageParser(SCStandMessageHandler._id, SCStandMessageHandler,"MSG.SCStandMessage")

SCCallMessageHandler = {
--100124
_id=MSG.SCCallMessage._id
}
function SCCallMessageHandler:emptyMessage()
    return MSG.SCCallMessage:new()
end
--                              100124
MessageParser:regMessageParser(SCCallMessageHandler._id, SCCallMessageHandler,"MSG.SCCallMessage")

SCStartGameMessageHandler = {
--100200
_id=MSG.SCStartGameMessage._id
}
function SCStartGameMessageHandler:emptyMessage()
    return MSG.SCStartGameMessage:new()
end
--                              100200
MessageParser:regMessageParser(SCStartGameMessageHandler._id, SCStartGameMessageHandler,"MSG.SCStartGameMessage")

SCPublicCardsMessageHandler = {
--100201
_id=MSG.SCPublicCardsMessage._id
}
function SCPublicCardsMessageHandler:emptyMessage()
    return MSG.SCPublicCardsMessage:new()
end
--                              100201
MessageParser:regMessageParser(SCPublicCardsMessageHandler._id, SCPublicCardsMessageHandler,"MSG.SCPublicCardsMessage")

SCOnlineChangeMessageHandler = {
--100202
_id=MSG.SCOnlineChangeMessage._id
}
function SCOnlineChangeMessageHandler:emptyMessage()
    return MSG.SCOnlineChangeMessage:new()
end
--                              100202
MessageParser:regMessageParser(SCOnlineChangeMessageHandler._id, SCOnlineChangeMessageHandler,"MSG.SCOnlineChangeMessage")

SCActionTurnMessageHandler = {
--100203
_id=MSG.SCActionTurnMessage._id
}
function SCActionTurnMessageHandler:emptyMessage()
    return MSG.SCActionTurnMessage:new()
end
--                              100203
MessageParser:regMessageParser(SCActionTurnMessageHandler._id, SCActionTurnMessageHandler,"MSG.SCActionTurnMessage")

