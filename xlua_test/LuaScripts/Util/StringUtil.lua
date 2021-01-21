-- 字符串工具类
-- 各种字符串操作全部添加到此
---@class StringUtil
StringUtil = {}
local floors = math.floor
local modsf = math.modf
-- * @param str
-- * @param args
-- * @return
-- * 返回格式化后的字符串
-- */
function StringUtil.format(str, args, ...)
    if type(args) ~= "table" then
        args = {args, ...}
    end
    for i, v in ipairs(args) do
        str = string.gsub(str, "{" .. i .. "}", v)
    end
    return str
end

-- 10000 10k 超过一万
-- 10000000 10m 超过一千万
-- 10b 超过百亿
function StringUtil.formatResValue(val)
    local ret = tonumber(val) or 0
    if ret >= 10000000000 then
        ret = string.format("%db", math.floor(ret / 1000000000))
    elseif ret >= 10000000 then
        ret = string.format("%dm", math.floor(ret / 1000000))
    elseif ret >= 10000 then
        ret = string.format("%dk", math.floor(ret / 1000))
    else
        ret = tostring(ret)
    end
    return ret
end

--[[
    time
    getshi "2017-3-12 00.00.00"
--]]
function StringUtil.dataFormat(strData)
    strData = strData or ""
    local nDay = 0
    local nMonth = 0
    local nYear = 0
    local nHour = 0
    local nMinute = 0
    local nSecond = 0
    local temps = strData.split(" ")
    if #temps > 1 then
        local strData = temps[1]
        local strTime = temps[2]
        temps = strData.split("-")
        if #temps > 2 then
            nYear = tonumber(temps[1]) or 0
            nMonth = tonumber(temps[2]) or 0
            nDay = tonumber(temps[3]) or 0
        end

        temps = strTime.split(".")
        if #temps > 2 then
            nHour = tonumber(temps[1]) or 0
            nMinute = tonumber(temps[2]) or 0
            nSecond = tonumber(temps[3]) or 0
        end
    end
    local tbTime = {day = nDay, month = nMonth, year = nYear, hour = nHour, min = nMinute, sec = nSecond}
    local nTime = os.time(tbTime) or 0
    return ServerTimeEntity.getServerDateForTimeStamp(nTime)
end

--[[
    限制最大字符串 长度大于指定长度采用...方案
    @param strContent   -- 当前字符串
    @parma nMaxLen      -- 限制长度
    @return 返回修订后的字符串
--]]
function StringUtil.revisedUTFByMaxLen(strContent, nMaxLen)
    strContent = strContent or ""
    nMaxLen = nMaxLen or 0

    -- 字符串转表
    local function StringToTable(s)
        local tb = {}
        --[[  
        UTF8的编码规则：  
        1. 字符的第一个字节范围： 0x00—0x7F(0-127),或者 0xC2—0xF4(194-244); UTF8 是兼容 ascii 的，所以 0~127 就和 ascii 完全一致  
        2. 0xC0, 0xC1,0xF5—0xFF(192, 193 和 245-255)不会出现在UTF8编码中   
        3. 0x80—0xBF(128-191)只会出现在第二个及随后的编码中(针对多字节编码，如汉字)   
        ]]
        for utfChar in string.gmatch(s, "[%z\1-\127\194-\244][\128-\191]*") do
            table.insert(tb, utfChar)
        end

        return tb
    end

    -- 获取字符串长度，设一个中文长度为2，其他长度为1
    local function GetUTFLen(s)
        local sTable = StringToTable(s)

        local len = 0
        local charLen = 0

        for i = 1, #sTable do
            local utfCharLen = string.len(sTable[i])
            if utfCharLen > 1 then -- 长度大于1的就认为是中文
                charLen = 2
            else
                charLen = 1
            end

            len = len + charLen
        end

        return len
    end
    -- 获取指定字符个数的字符串的实际长度，设一个中文长度为2，其他长度为1，count.-1表示不限制
    local function GetUTFLenWithCount(s, count)
        local sTable = StringToTable(s)

        local len = 0
        local charLen = 0
        local isLimited = (count >= 0)

        for i = 1, #sTable do
            local utfCharLen = string.len(sTable[i])
            if utfCharLen > 1 then -- 长度大于1的就认为是中文
                charLen = 2
            else
                charLen = 1
            end

            len = len + utfCharLen

            if isLimited then
                count = count - charLen
                if count <= 0 then
                    break
                end
            end
        end

        return len
    end
    local function GetMaxLenString(s, maxLen)
        local len = GetUTFLen(s)
        local dstString = s
        -- 超长，裁剪，加...
        if len > maxLen then
            dstString = string.sub(s, 1, GetUTFLenWithCount(s, maxLen))
            dstString = dstString .. "..."
        end

        return dstString
    end

    if nMaxLen > 0 then
        return GetMaxLenString(strContent, nMaxLen)
    end

    return strContent
end

function StringUtil.GetUTFLenWithCountout(s, count)
    local function StringToTable(s)
        local tb = {}
        --[[
        UTF8的编码规则：
        1. 字符的第一个字节范围： 0x00—0x7F(0-127),或者 0xC2—0xF4(194-244); UTF8 是兼容 ascii 的，所以 0~127 就和 ascii 完全一致
        2. 0xC0, 0xC1,0xF5—0xFF(192, 193 和 245-255)不会出现在UTF8编码中
        3. 0x80—0xBF(128-191)只会出现在第二个及随后的编码中(针对多字节编码，如汉字)
        ]]
        for utfChar in string.gmatch(s, "[%z\1-\127\194-\244][\128-\191]*") do
            table.insert(tb, utfChar)
        end

        return tb
    end

    -- 获取字符串长度，设一个中文长度为2，其他长度为1
    local function GetUTFLen(s)
        local sTable = StringToTable(s)

        local len = 0
        local charLen = 0

        for i = 1, #sTable do
            local utfCharLen = string.len(sTable[i])
            if utfCharLen > 1 then -- 长度大于1的就认为是中文
                charLen = 2
            else
                charLen = 1
            end

            len = len + charLen
        end

        return len
    end
    local sTable = StringToTable(s)

    local len = 0
    local charLen = 0
    local isLimited = (count >= 0)

    for i = 1, #sTable do
        local utfCharLen = string.len(sTable[i])
        if utfCharLen > 1 then -- 长度大于1的就认为是中文
            charLen = 2
        else
            charLen = 1
        end

        len = len + utfCharLen

        if isLimited then
            count = count - charLen
            if count == 0 then
                break
            elseif count < 0 then
                len = len - utfCharLen
            end
        end
    end

    return len
end

function StringUtil.calmaxStr(str)
    local function StringToTable(s)
        local tb = {}
        --[[  
        UTF8的编码规则：  
        1. 字符的第一个字节范围： 0x00—0x7F(0-127),或者 0xC2—0xF4(194-244); UTF8 是兼容 ascii 的，所以 0~127 就和 ascii 完全一致  
        2. 0xC0, 0xC1,0xF5—0xFF(192, 193 和 245-255)不会出现在UTF8编码中   
        3. 0x80—0xBF(128-191)只会出现在第二个及随后的编码中(针对多字节编码，如汉字)   
        ]]
        for utfChar in string.gmatch(s, "[%z\1-\127\194-\244][\128-\191]*") do
            table.insert(tb, utfChar)
        end

        return tb
    end

    local function GetUTFlentable(s)
        local sTable = StringToTable(s)

        local len = 0
        local charLen = 0
        local nowtable = {}
        for i = 1, #sTable do
            local utfCharLen = string.len(sTable[i])
            if utfCharLen > 1 then -- 长度大于1的就认为是中文
                charLen = 2
            else
                charLen = 1
            end

            table.insert(nowtable, charLen)
        end

        return nowtable
    end

    local str = str
    local max = math.max
    local temptable = GetUTFlentable(str)
    local len = #temptable
    local longmsglen = 0
    local templen = 0
    local now = 1
    for i = 1, len do
        local klen = temptable[i]
        local ss = string.sub(str, now, now + klen)
        now = now + klen
        if ss == " " or ss == "" then
            longmsglen = max(longmsglen, templen)
            templen = 0
        else
            templen = templen + 1
        end
    end
    longmsglen = max(longmsglen, templen)
    temptable = nil
    return longmsglen
end

--[[
    限定label 文本宽度， 超过则以 ... 方式表现
]]
function StringUtil.getFixLabTextString(lab, limitLabWidth, str)
    if not isValid(lab) then
        return str
    end
    lab.setText(str)
    local labSize = lab.getSize()
    -- PrintZX("getFixLabTextString() labSize. ", limitLabWidth, lab.getSize())
    if labSize.width <= limitLabWidth then
        return str
    end
    local index = -1
    for i = 1, string.len(str) do
        local strTmp = string.sub(str, 1, index)
        lab.setText(strTmp .. "...")
        -- PrintZX("getFixLabTextString() labSize. ", index, strTmp, lab.getSize())
        if lab.getSize().width <= limitLabWidth then
            return strTmp .. "..."
        end

        index = index - 1
    end
end

--[[
    限定label 文本高度， 超过则以 ... 方式表现
]]
function StringUtil.getFixLabTextString2(lab, limitLabHeight, str)
    if not isValid(lab) then
        return str
    end
    lab.setText(str)
    local labSize = lab.getSize()
    -- PrintZX("getFixLabTextString() labSize. ", limitLabWidth, lab.getSize())
    if labSize.height <= limitLabHeight then
        return str
    end
    local index = -1
    for i = 1, string.len(str) do
        local strTmp = string.sub(str, 1, index)
        lab.setText(strTmp .. "...")
        -- PrintZX("getFixLabTextString() labSize. ", index, strTmp, lab.getSize())
        if lab.getSize().height <= limitLabHeight then
            return strTmp .. "..."
        end

        index = index - 1
    end
end

-- 将字符串中的所有目标字符串替换为新字符串
function StringUtil.replaceStr(sourceStr, targetStr, newStr)
    newStr = newStr or ""
    local function doReplace(sourceStr, targetStr, newStr)
        local startIndex, endIndex = string.find(sourceStr, targetStr)
        if startIndex == nil then
            return false, sourceStr
        else
            return true, string.sub(sourceStr, 1, startIndex - 1) .. newStr .. string.sub(sourceStr, endIndex + 1)
        end
    end
    local result = sourceStr
    local needContinue = true
    while (needContinue) do
        needContinue, result = doReplace(result, targetStr, newStr)
    end
    return result
end

function StringUtil.formatFullPath(str, path)
    local temp = str
    if not string.match(temp, "/") and path then
        temp = string.format(path, str)
    end
    return temp
end

--[[
    -- 方法摘要：字符串转为list
]]
function StringUtil.strToList(str)
    local list = {}
    local len = string.len(str)
    for i = 1, len do
        local char = string.sub(str, i, i)
        table.insert(list, char)
    end
    return list
end

--[[
    -- 方法摘要：字符串是否包含除0-9，a-z，A-Z的特殊字符
]]
function StringUtil.isStrContainsSpecialChar(str)
    local strList = StringUtil.strToList(str)

    for i, v in ipairs(strList) do
        -- 用ASCII判断是否是0-9，a-z，A-Z
        if
            (string.byte(v) >= 48 and string.byte(v) <= 57) or (string.byte(v) >= 65 and string.byte(v) <= 90) or
                (string.byte(v) >= 97 and string.byte(v) <= 122)
         then
        else
            return true
        end
    end
    return false
end

function StringUtil.replacenum(num)
    if not num or num == "" then
        return "错误的数字,请检查编辑器配置"
    end
    local num = num
    local strtemp = {}
    local k = 1
    while num >= 1000 do
        strtemp[k] = string.format("%03d", num % 1000)
        k = k + 1
        num = num / 1000
    end
    local laststr = tostring(math.floor(num))
    for x = #strtemp, 1, -1 do
        laststr = laststr .. AreaLangTools.getCommonSymbol() .. strtemp[x]
    end
    return laststr
end

function StringUtil.replacesmall(num)
    return AreaLangTools.replacesmall(num)
end

function StringUtil.unreplacesmall(num)
    return AreaLangTools.unreplacesmall(num)
end

--这里需要加上对小数的处理功能,已经加上，在下个版本加入对超过13位数据的处理，需要改lua底层
function StringUtil.replaceNum(num)
    if not num or num == "" then
        return "错误的数字,请检查编辑器配置"
    end
    local num = num
    local x = floors(num)
    local y = ""
    local str1 = tostring(num)
    local px, py = string.find(str1, "%.")
    if px then
        y = StringUtil.replacesmall(string.sub(str1, px, -1))
    end
    local strtemp = {}
    local k = 1
    while x >= 1000 do
        strtemp[k] = string.format("%03d", x % 1000)
        k = k + 1
        x = x / 1000
    end
    local laststr = tostring(floors(x))
    for z = #strtemp, 1, -1 do
        laststr = laststr .. AreaLangTools.getCommonSymbol() .. strtemp[z]
    end
    local pz = string.find(str1, "e")
    if not pz then
        laststr = laststr .. y
    end
    return laststr
end

function StringUtil.translatenum(num)
    local num = num
    if num < 1000000 then
        return StringUtil.replacenum(num)
    else
        local temp = math.floor(num / 1000000)
        return temp .. "M"
    end
end

function StringUtil.yuenannum(num)
    if num < 100000 then
        return StringUtil.replacenum(num)
    end
    local x = num

    local nums = {1000, 1000000, 1000000000}
    local strnums = {"K", "M", "B"}
    local tt = 0
    for i = 1, #nums do
        if x / nums[i] >= 1 then
            tt = i
        else
            break
        end
    end
    local tempnum = x

    if not (tt == 0) then
        tempnum = tempnum / nums[tt]
        return StringUtil.replacesmall(tempnum) .. strnums[tt]
    else
        return StringUtil.replacesmall(tempnum)
    end
end

function StringUtil.yuenaniosnum(num)
    if not num or num == "" or num == " " then
        return "错误的数字,请检查编辑器配置"
    end
    if num < 1000 then
        return StringUtil.replacenum(num)
    end
    local x = num
    local nums = {1000, 1000000, 1000000000}
    local strnums = {"K", "M", "B"}
    local tt = 0
    for i = 1, #nums do
        if x / nums[i] >= 1 then
            tt = i
        else
            break
        end
    end
    local tempnum = x

    if not (tt == 0) then
        tempnum = tempnum / nums[tt]
        return StringUtil.replacesmall(tempnum) .. strnums[tt]
    else
        return StringUtil.replacesmall(tempnum)
    end
end

function StringUtil.yuenan64tonum(str)
    local l = string.len(str)
    local num = 0
    for i = 1, l do
        num = num * 10 + tonumber(string.sub(str, i, i))
    end
    return num
end

-- 越南文或泰文过长部分修正
function StringUtil.fixLongText(text, limitLen, fixText)
    if not text then
        return
    end
    local len = #text
    if len >= limitLen then
        local fixText = string.sub(text, 0, limitLen) .. fixText
        return fixText
    else
        return text
    end
end

function StringUtil.parseItemList(itemList, index1, index2)
    local tb
    if index1 then
        tb = itemList.split("|")[index1]
    end

    if tb and index2 then
        return tb.split(",")[index2]
    end
    return tb
end

--input."1000001,1|1000002,2"       output.{{1000001,1}, {1000002,2}}
--input.""       output.{{}}
function StringUtil.parseItemConfig(itemList)
    local t = {}
    local groups = string.split(itemList, "|")
    for _, v in ipairs(groups) do
        local dataList = string.split(v, ",")
        for i, data in ipairs(dataList) do
            dataList[i] = tonumber(data)
        end
        table.insert(t, dataList)
    end
    return t
end

function StringUtil.firstItemIdInItemList(itemList)
    return tonumber(StringUtil.parseItemList(itemList, 1, 1))
end

function StringUtil.firstItemCountInItemList(itemList)
    return tonumber(StringUtil.parseItemList(itemList, 1, 2))
end

-- 取出字符串的空字符
function StringUtil.trimString(str)
    if tostring(str) ~= nil then
        return string.gsub(str, "^%s*(.-)%s*$", "%1")
    else
        return str
    end
end

-- 用指定字符串连接字符串数组
function StringUtil.joinString(strList, joinStr)
    local res = nil
    for _, v in pairs(strList) do
        if res == nil then
            res = v
        else
            res = res .. joinStr .. v
        end
    end
    return res
end

function StringUtil.endWith(str, substr)
    if str == nil or substr == nil then
        return nil, "the string or substr is nil"
    end
    local strTmp = string.reverse(str)
    local subStrTmp = string.reverse(substr)
    if string.find(strTmp, subStrTmp) == 1 then
        return true
    end
    return false
end

function StringUtil.startWith(str, substr)
    if str == nil or substr == nil then
        return nil, "the string or substr is nil"
    end

    if string.find(str, substr) == 1 then
        return true
    end
    return false
end

function StringUtil.TableToString(pb)
    local ret = ""
    for key, value in pairs(pb) do
        -- body
        local t = type(value)
        -- print("type",t)
        if t == "number" then
            ret = ret .. value .. ",\n"
        elseif t == "boolean" then
            ret = ret .. tostring(value) .. ",\n"
        elseif t == "string" then
            ret = ret .. string.format("%q", value) .. ",\n"
        elseif t == "table" then
            ret = ret .. serialize(value, true) .. ",\n"
        else
            ret = string.format("%s%s", ret, t) .. ",\n"
        end
    end
    return ret
end

return StringUtil
