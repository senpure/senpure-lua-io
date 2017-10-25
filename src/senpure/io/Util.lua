---
--- Created by admin.
--- DateTime: 2017/8/18 11:16
---
function rightPad(_str, _pad)
    local _str_len = #_str
    for i = 1, _pad do
        if i > _str_len then
            _str = _str .. " "
        end
    end
    return _str
end