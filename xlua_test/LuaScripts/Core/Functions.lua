-- @Author: Jax
-- @Date:   2020-04-26 18:21:47
-- @Last Modified by:   zhangzhiqiang
-- @Last Modified time: 2020-04-28 18:15:53
--[[

Copyright (c) 2014-2017 Chukong Technologies Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]
local atan2 = function(y, x)
    return math.atan(y, x)
end
math.atan2 = math.atan2 or atan2

--[[--
打印调试信息
### 用法示例
~~~ lua
printLog("WARN", "Network connection lost at %d", os.time())
~~~
@param string tag 调试信息的 tag
@param string fmt 调试信息格式
@param [mixed ...] 更多参数
]]
function printLog(tag, fmt, ...)
    local t = {
        "[",
        string.upper(tostring(tag)),
        "] ",
        string.format(tostring(fmt), ...)
    }
    print(table.concat(t))
end

--[[--
输出 tag 为 ERR 的调试信息
@param string fmt 调试信息格式
@param [mixed ...] 更多参数
]]
function printError(fmt, ...)
    printLog("ERR", fmt, ...)
    print(debug.traceback("", 2))
end

--[[--
输出 tag 为 INFO 的调试信息
@param string fmt 调试信息格式
@param [mixed ...] 更多参数
]]
function printInfo(fmt, ...)
    printLog("INFO", fmt, ...)
end

local function dump_value_(v)
    if type(v) == "string" then
        v = '"' .. v .. '"'
    end
    return tostring(v)
end

--[[--
输出值的内容
### 用法示例
~~~ lua
local t = {comp = "chukong", engine = "quick"}
dump(t)
~~~
@param mixed value 要输出的值
@parma [integer nesting] 输出时的嵌套层级，默认为 3
@param [string desciption] 输出内容前的文字描述
]]
function dump(value, nesting, desciption)
    if type(nesting) ~= "number" then
        nesting = 3
    end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = '"' .. v .. '"'
        end
        return tostring(v)
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))

    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result + 1] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result + 1] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result + 1] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent .. "    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then
                        keylen = vkl
                    end
                    values[k] = v
                end
                table.sort(
                    keys,
                    function(a, b)
                        if type(a) == "number" and type(b) == "number" then
                            return a < b
                        else
                            return tostring(a) < tostring(b)
                        end
                    end
                )
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result + 1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)

    local result_str = ""
    for i, line in ipairs(result) do
        result_str = result_str .. " \r\n " .. line
    end
    print(result_str)
end

--[[--
提供一组常用函数，以及对 Lua 标准库的扩展
]]
--[[--
输出格式化字符串
~~~ lua
printf("The value = %d", 100)
~~~
@param string fmt 输出格式
@param [mixed ...] 更多参数
]]
function printf(fmt, ...)
    print(string.format(tostring(fmt), ...))
end

--[[--
检查并尝试转换为数值，如果无法转换则返回 0
@param mixed value 要检查的值
@param [integer base] 进制，默认为十进制
@return number
]]
function checknumber(value, base)
    return tonumber(value, base) or 0
end

function math.round(value)
    return math.floor(value + 0.5)
end

--[[--
检查并尝试转换为整数，如果无法转换则返回 0
@param mixed value 要检查的值
@return integer
]]
function checkint(value)
    return math.round(checknumber(value))
end

--[[--
检查并尝试转换为布尔值，除了 nil 和 false，其他任何值都会返回 true
@param mixed value 要检查的值
@return boolean
]]
function checkbool(value)
    return (value ~= nil and value ~= false)
end

--[[--
检查值是否是一个表格，如果不是则返回一个空表格
@param mixed value 要检查的值
@return table
]]
function checktable(value)
    if type(value) ~= "table" then
        value = {}
    end
    return value
end

--[[--
如果表格中指定 key 的值为 nil，或者输入值不是表格，返回 false，否则返回 true
@param table hashtable 要检查的表格
@param mixed key 要检查的键名
@return boolean
]]
function isset(hashtable, key)
    local t = type(hashtable)
    return (t == "table" or t == "userdata") and hashtable[key] ~= nil
end

local setmetatableindex_
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        local meta = getmetatable(t)
        --printSL("对象元表：",meta)
        if not meta then
            meta = {}
            setmetatable(t, meta)
        end
        setmetatableindex_(meta, index)
    else
        local mt = getmetatable(t)
        if not mt then
            mt = {}
        end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_

--[[--
深度克隆一个值
~~~ lua
-- 下面的代码，t2 是 t1 的引用，修改 t2 的属性时，t1 的内容也会发生变化
local t1 = {a = 1, b = 2}
local t2 = t1
t2.b = 3    -- t1 = {a = 1, b = 3} <-- t1.b 发生变化
-- clone() 返回 t1 的副本，修改 t2 不会影响 t1
local t1 = {a = 1, b = 2}
local t2 = clone(t1)
t2.b = 3    -- t1 = {a = 1, b = 2} <-- t1.b 不受影响
~~~
@param mixed object 要克隆的值
@return mixed
]]
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local function _call(self, ...)
    return self:create(...)
end
function class(classname, ...)
    ---@class Class
    local cls = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(
            superType == "nil" or superType == "table" or superType == "function",
            string.format('class() - create class "%s" with invalid super class type "%s"', classname, superType)
        )

        if superType == "function" then
            assert(
                cls.__create == nil,
                string.format('class() - create class "%s" with more than one creating function', classname)
            )
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            -- end
            -- --printSL("super is userdata:",super.isLua)
            -- if not super.isLua then
            --     -- super is native class
            --     assert(cls.__create == nil,
            --         string.format("class() - create class \"%s\" with more than one creating function or native class",
            --             classname));
            --     -- --printSL("super>>>>>>>>>>>>>>:",super)
            --     cls.__create = super
            -- else
            -- super is pure lua class
            cls.__supers = cls.__supers or {}
            cls.__supers[#cls.__supers + 1] = super
            if not cls.super then
                -- set first super pure lua class as class.super
                cls.super = super
            end
        else
            error(string.format('class() - create class "%s" with invalid super type', classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        local super = cls.super
        setmetatable(
            cls,
            {
                __call = _call,
                __index = super
                --__index = function(_, k)
                --    return super and super[k] or nil
                --end
            }
        )
    else
        setmetatable(
            cls,
            {
                __call = _call,
                __index = function(_, key)
                    local supers = cls.__supers
                    for i = 1, #supers do
                        local super = supers[i]
                        if super[key] then
                            return super[key]
                        end
                    end
                end
            }
        )
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function()
        end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        -- instance.class = cls
        -- --printSL("instance:",instance)
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end

local enum_castFrom = function(self, value)
    return self[value]
end

local iskindof_
iskindof_ = function(cls, name)
    local __index = rawget(cls, "__index")
    if type(__index) == "table" and rawget(__index, "__cname") == name then
        return true
    end

    if rawget(cls, "__cname") == name then
        return true
    end
    local __supers = rawget(__index, "__supers")
    if not __supers then
        return false
    end
    for _, super in ipairs(__supers) do
        if iskindof_(super, name) then
            return true
        end
    end
    return false
end

function iskindof(obj, classname)
    if not obj then
        return false
    end
    local t = type(obj)
    if t ~= "table" and t ~= "userdata" then
        return false
    end

    local c = type(classname)
    if c == "table" then
        classname = classname.__cname
    end

    local mt
    if t == "userdata" then
        if tolua.iskindof(obj, classname) then
            return true
        end
        mt = getmetatable(tolua.getpeer(obj))
    else
        mt = getmetatable(obj)
    end
    if mt then
        return iskindof_(mt, classname)
    end
    return false
end

function import(moduleName, currentModuleName)
    local currentModuleNameParts
    local moduleFullName = moduleName
    local offset = 1

    while true do
        if string.byte(moduleName, offset) ~= 46 then -- .
            moduleFullName = string.sub(moduleName, offset)
            if currentModuleNameParts and #currentModuleNameParts > 0 then
                moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
            end
            break
        end
        offset = offset + 1

        if not currentModuleNameParts then
            if not currentModuleName then
                local n, v = debug.getlocal(3, 1)
                currentModuleName = v
            end

            currentModuleNameParts = string.split(currentModuleName, ".")
        end
        table.remove(currentModuleNameParts, #currentModuleNameParts)
    end

    return require(moduleFullName)
end

function handler(obj, method)
    assert(method ~= nil, "handler的函数不能为空")
    if obj.__handlerMap == nil then
        obj.__handlerMap = {}
    end
    if obj.__handlerMap[method] == nil then
        obj.__handlerMap[method] = function(...)
            return method(obj, ...)
        end
    end
    return obj.__handlerMap[method]
end

-- function LuaClass.Mathf.Round(value)
--     value = checknumber(value)
--     return math.floor(value + 0.5)
-- end

-- local pi_div_180 = math.pi / 180
-- function math.angle2radian(angle)
--     return angle * pi_div_180
-- end

-- function math.radian2angle(radian)
--     return radian * 180 / math.pi
-- end

--[[--
检查指定的文件或目录是否存在，如果存在返回 true，否则返回 false
可以使用 CCFileUtils:fullPathForFilename() 函数查找特定文件的完整路径，例如：
~~~ lua
local path = CCFileUtils:sharedFileUtils():fullPathForFilename("gamedata.txt")
if io.exists(path) then
    ....
end
~~~
@param string path 要检查的文件或目录的完全路径
@return boolean
]]
function io.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

--[[--
读取文件内容，返回包含文件内容的字符串，如果失败返回 nil
io.readfile() 会一次性读取整个文件的内容，并返回一个字符串，因此该函数不适宜读取太大的文件。
@param string path 文件完全路径
@return string
]]
function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

--[[--
以字符串内容写入文件，成功返回 true，失败返回 false
"mode 写入模式" 参数决定 io.writefile() 如何写入内容，可用的值如下：
-   "w+" : 覆盖文件已有内容，如果文件不存在则创建新文件
-   "a+" : 追加内容到文件尾部，如果文件不存在则创建文件
此外，还可以在 "写入模式" 参数最后追加字符 "b" ，表示以二进制方式写入数据，这样可以避免内容写入不完整。
**Android 特别提示:** 在 Android 平台上，文件只能写入存储卡所在路径，assets 和 data 等目录都是无法写入的。
@param string path 文件完全路径
@param string content 要写入的内容
@param [string mode] 写入模式，默认值为 "w+b"
@return boolean
]]
function io.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then
            return false
        end
        io.close(file)
        return true
    else
        return false
    end
end

--[[--
拆分一个路径字符串，返回组成路径的各个部分
~~~ lua
local pathinfo  = io.pathinfo("/var/app/test/abc.png")
-- 结果:
-- pathinfo.dirname  = "/var/app/test/"
-- pathinfo.filename = "abc.png"
-- pathinfo.basename = "abc"
-- pathinfo.extname  = ".png"
~~~
@param string path 要分拆的路径字符串
@return table
]]
function io.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

--[[--
返回指定文件的大小，如果失败返回 false
@param string path 文件完全路径
@return integer
]]
function io.filesize(path)
    local size = false
    local file = io.open(path, "r")
    if file then
        local current = file:seek()
        size = file:seek("end")
        file:seek("set", current)
        io.close(file)
    end
    return size
end

--[[--
计算表格包含的字段数量
Lua table 的 "#" 操作只对依次排序的数值下标数组有效，table.nums() 则计算 table 中所有不为 nil 的值的个数。
@param table t 要检查的表格
@return integer
]]
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

--[[--
返回指定表格中的所有键
~~~ lua
local hashtable = {a = 1, b = 2, c = 3}
local keys = table.keys(hashtable)
-- keys = {"a", "b", "c"}
~~~
@param table hashtable 要检查的表格
@return table
]]
function table.keys(hashtable)
    local keys = {}
    for k, _ in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end

--[[--
返回指定表格中的所有值
~~~ lua
local hashtable = {a = 1, b = 2, c = 3}
local values = table.values(hashtable)
-- values = {1, 2, 3}
~~~
@param table hashtable 要检查的表格
@return table
]]
function table.values(hashtable, result)
    result = result or {}
    for _, v in pairs(hashtable) do
        result[#result + 1] = v
    end
    return result
end

--[[--
将来源表格中所有键及其值复制到目标表格对象中，如果存在同名键，则覆盖其值
~~~ lua
local dest = {a = 1, b = 2}
local src  = {c = 3, d = 4}
table.merge(dest, src)
-- dest = {a = 1, b = 2, c = 3, d = 4}
~~~
@param table dest 目标表格
@param table src 来源表格
]]
function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
    return dest
end

--[[--
将两个表格中所有键及其值复制到一个新的表格对象中，不改变两个参数表的内容，如果存在同名键，则覆盖其值
~~~ lua
local dest = {a = 1, b = 2}
local src  = {c = 3, d = 4}
local result = table.merge_n(dest, src)
-- result = {a = 1, b = 2, c = 3, d = 4}
~~~
@param table dest 目标表格
@param table src 来源表格
]]
function table.merge_n(dest, src)
    local result = {}
    for k, v in pairs(dest) do
        result[k] = v
    end
    for k, v in pairs(src) do
        result[k] = v
    end
    return result
end

--[[--
在目标表格的指定位置插入来源表格，如果没有指定位置则连接两个表格
~~~ lua
local dest = {1, 2, 3}
local src  = {4, 5, 6}
table.insertto(dest, src)
-- dest = {1, 2, 3, 4, 5, 6}
dest = {1, 2, 3}
table.insertto(dest, src, 5)
-- dest = {1, 2, 3, nil, 4, 5, 6}
~~~
@param table dest 目标表格
@param table src 来源表格
@param [integer begin] 插入位置
]]
function table.insertto(dest, src, begin)
    begin = checkint(begin)
    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

--[[
从表格中查找指定值，返回其索引，如果没找到返回 false
~~~ lua
local array = {"a", "b", "c"}
print(table.indexof(array, "b")) -- 输出 2
~~~
@param table array 表格
@param mixed value 要查找的值
@param [integer begin] 起始索引值
@return integer
]]
function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then
            return i
        end
    end
    return -1
end

--[[--
从表格中查找指定值，返回其 key，如果没找到返回 nil
~~~ lua
local hashtable = {name = "dualface", comp = "chukong"}
print(table.keyof(hashtable, "chukong")) -- 输出 comp
~~~
@param table hashtable 表格
@param mixed value 要查找的值
@return string 该值对应的 key
]]
function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then
            return k
        end
    end
    return nil
end

--[[--
从表格中删除指定值，返回删除的值的个数
~~~ lua
local array = {"a", "b", "c", "c"}
print(table.removebyvalue(array, "c", true)) -- 输出 2
~~~
@param table array 表格
@param mixed value 要删除的值
@param [boolean removeall] 是否删除所有相同的值
@return integer
]]
function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then
                break
            end
        end
        i = i + 1
    end
    return c
end

--[[--
对表格中每一个值执行一次指定的函数，并用函数返回值更新表格内容
~~~ lua
local t = {name = "dualface", comp = "chukong"}
table.map(t, function(v, k)
    -- 在每一个值前后添加括号
    return "[" .. v .. "]"
end)
-- 输出修改后的表格内容
for k, v in pairs(t) do
    print(k, v)
end
-- 输出
-- name [dualface]
-- comp [chukong]
~~~
fn 参数指定的函数具有两个参数，并且返回一个值。原型如下：
~~~ lua
function map_function(value, key)
    return value
end
~~~
@param table t 表格
@param function fn 函数
]]
function table.map(t, fn)
    for k, v in pairs(t) do
        t[k] = fn(v, k)
    end
end

--[[--
对表格中每一个值执行一次指定的函数，返回一个新的执行结果表格
~~~ lua
local t = {name = "dualface", comp = "chukong"}
local result = table.map_n(t, function(v, k)
    -- 在每一个值前后添加括号
    return "[" .. v .. "]"
end)
-- 输出修改后的表格内容
for k, v in pairs(result) do
    print(k, v)
end
-- 输出
-- name [dualface]
-- comp [chukong]
~~~
fn 参数指定的函数具有两个参数，并且返回一个值。原型如下：
~~~ lua
function map_function(value, key)
    return value
end
~~~
@param table t 表格
@param function fn 函数
]]
function table.map_n(t, fn)
    local result = {}
    for k, v in pairs(t) do
        result[k] = fn(v, k)
    end
    return result
end

--[[--
对表格中每一个值执行一次指定的函数，但不改变表格内容
~~~ lua
local t = {name = "dualface", comp = "chukong"}
table.walk(t, function(v, k)
    -- 输出每一个值
    print(v)
end)
~~~
fn 参数指定的函数具有两个参数，没有返回值。原型如下：
~~~ lua
function map_function(value, key)
end
~~~
@param table t 表格
@param function fn 函数
]]
function table.walk(t, fn)
    for k, v in pairs(t) do
        fn(v, k)
    end
end

--[[--
对表格中每一个值执行一次指定的函数，如果该函数返回 false，则对应的值会从表格中删除
~~~ lua
local t = {name = "dualface", comp = "chukong"}
table.filter(t, function(v, k)
    return v ~= "dualface" -- 当值等于 dualface 时过滤掉该值
end)
-- 输出修改后的表格内容
for k, v in pairs(t) do
    print(k, v)
end
-- 输出
-- comp chukong
~~~
fn 参数指定的函数具有两个参数，并且返回一个 boolean 值。原型如下：
~~~ lua
function map_function(value, key)
    return true or false
end
~~~
@param table t 表格
@param function fn 函数
]]
function table.filter(t, fn)
    for k, v in pairs(t) do
        if not fn(v, k) then
            t[k] = nil
        end
    end
end

--[[--
对表格中每一个值执行一次指定的函数，返回一张新的表，该表只返回函数为 true的内容
~~~ lua
local t = {name = "dualface", comp = "chukong"}
local result = table.filter_n(t, function(v, k)
    return v ~= "dualface" -- 当值等于 dualface 时过滤掉该值
end)
-- 输出修改后的表格内容
for k, v in pairs(result) do
    print(k, v)
end
-- 输出
-- comp chukong
~~~
fn 参数指定的函数具有两个参数，并且返回一个 boolean 值。原型如下：
~~~ lua
function map_function(value, key)
    return true or false
end
~~~
@param table t 表格
@param function fn 函数
]]
function table.filter_n(t, fn)
    local result = {}
    for k, v in pairs(t) do
        if fn(v, k) then
            result[k] = v
        end
    end
    return result
end

--[[--
遍历表格，确保其中的值唯一
~~~ lua
local t = {"a", "a", "b", "c"} -- 重复的 a 会被过滤掉
table.unique(t)
for k, v in pairs(t) do
    print(v)
end
-- 输出
-- a
-- b
-- c
~~~
@param table t 表格
@param boolean bArray 为true时必须为数组，让数组重排索引
]]
function table.unique(t, bArray)
    local check = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                t[k] = nil
                t[idx] = v
                idx = idx + 1
            end
            check[v] = true
        else
            print("check true ", k, v)
            t[k] = nil
        end
    end
end

--[[--
遍历表格，确保其中的值唯一
~~~ lua
local t = {"a", "a", "b", "c"} -- 重复的 a 会被过滤掉
local n = table.unique_n(t)
for k, v in pairs(n) do
    print(v)
end
-- 输出
-- a
-- b
-- c
~~~
@param table t 表格
@param boolean bArray 为true时必须为数组，让数组重排索引
@return table 包含所有唯一值的新表格
]]
function table.unique_n(t, bArray)
    local check = {}
    local n = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                n[idx] = v
                idx = idx + 1
            else
                n[k] = v
            end
            check[v] = true
        end
    end
    return n
end

--[[--
打乱表格
~~~ lua
local t = {"a", "b", "c", "d"}
table.shuffle(t)
for k, v in pairs(n) do
    print(k,v)
end
-- 可能输出
-- b
-- d
-- a
-- c
~~~
@param table t 必须数组类型表格
]]
function table.shuffle(t)
    local num2, temp
    for i = #t, 2, -1 do
        num2 = math.random(1, i)
        t[num2], t[i] = t[i], t[num2]
    end
end

--[[--
清空表格
~~~ lua
local t = {"a", "b", "c", "d"}
table.clear(t)
print(#t)
-- 输出
-- 0
~~~
@param table t 表格
]]
function table.clear(t)
    for key, _ in pairs(t) do
        t[key] = nil
    end
end

--[[--
更改数组表格大小，多的数据用默认值填充
~~~ lua
local t = {"a", "b"}
table.resize(t,3,function() return "z" end)
for k, v in pairs(n) do
    print(k,v)
end
-- 输出
-- 1  a
-- 2  b
-- 3  z
~~~
@param table t 数组表格
@param int size 新的大小
@param function default 默认值函数
]]
function table.resize(t, size, default)
    local len = #t
    if len < size then
        assert(default and type(default) == "function", "table.resize 增大时必须要有默认值函数")
        for i = len + 1, size do
            t[i] = default()
        end
    elseif len > size then
        for i = size + 1, len do
            t[i] = nil
        end
    end
    return t
end

--[[
快速拷贝
    local abc = {5,12,1}
    table.sort(def)
    print(abc[2], def[2]) -- 12	5
@param table t 表格
]]
function table.clone(org, dest)
    dest = dest or {}
    local len = #org
    for i = 1, len do
        dest[i] = org[i]
    end
    return dest
end

--[[
浅拷贝
只拷贝顶级的值
]]
function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[
深度拷贝，只适用于模板表
递归调用，小心死循环
]]
function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local loadTableFunc = {}
local loadTable = function(tb, len, ...)
    local func = loadTableFunc[len]
    if not func then
        local str = ""
        for i = 1, len do
            str = str .. "tb[" .. i .. "]"
            if i ~= len then
                str = str .. ", "
            end
        end
        str = str .. " = ..."
        str = string.format("return function (tb, ... ) \n %s \n end", str)
        func = load(str)()
        loadTableFunc[len] = func
    end
    func(tb, ...)
end

---@type ObjectPool 避免频繁创建新table
local _tablePool
local _tableAutoReleaseDict = {}
local _tableDebugDict = {}
function table.create(...)
    if not _tablePool then
        _tablePool =
            LuaClass.ObjectPool(
            function()
                return {}
            end
        )
    end
    local tb = _tablePool:get()
    local len = select("#", ...)
    if len > 0 then
        loadTable(tb, len, ...)
    end
    --_tableDebugDict[tb] = debug.traceback()
    return tb
end

function table.createAutoRelease(onRecover, ...)
    local t = table.create(...)
    _tableAutoReleaseDict[t] = onRecover or t
    return t
end

function table.release(t)
    if t == nil then
        return
    end
    local func = _tableAutoReleaseDict[t]
    _tableAutoReleaseDict[t] = nil
    if func ~= nil and func ~= t then
        func(t)
    end
    if _tablePool then
        for key, _ in pairs(t) do
            t[key] = nil
        end
        _tablePool:add(t)
        _tableDebugDict[t] = nil
    end
end

function table.recoveryTable()
    for t, _ in pairs(_tableAutoReleaseDict) do
        table.release(t)
    end
    local tablePool = _tablePool
    local tableDebugDict = _tableDebugDict
end

function table.reverse(t, from, to)
    from = from or 1
    to = to or #t
    local temp
    local i = 0
    while from + i < to - i do
        temp = t[from + i]
        t[from + i] = t[to - i]
        t[to - i] = temp
        i = i + 1
    end

    return t
end

string._htmlspecialchars_set = {}
string._htmlspecialchars_set["&"] = "&amp;"
string._htmlspecialchars_set['"'] = "&quot;"
string._htmlspecialchars_set["'"] = "&#039;"
string._htmlspecialchars_set["<"] = "&lt;"
string._htmlspecialchars_set[">"] = "&gt;"

function string.htmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, k, v)
    end
    return input
end

function string.restorehtmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, v, k)
    end
    return input
end

function string.nl2br(input)
    return string.gsub(input, "\n", "<br />")
end

function string.text2html(input)
    input = string.gsub(input, "\t", "    ")
    input = string.htmlspecialchars(input)
    input = string.gsub(input, " ", "&nbsp;")
    input = string.nl2br(input)
    return input
end

--[[--
用指定字符或字符串分割输入字符串，返回包含分割结果的数组
~~~ lua
local input = "Hello,World"
local res = string.split(input, ",")
-- res = {"Hello", "World"}
local input = "Hello-+-World-+-Quick"
local res = string.split(input, "-+-")
-- res = {"Hello", "World", "Quick"}
~~~
@param string input 输入字符串
@param string delimiter 分割标记字符或字符串
@return array 包含分割结果的数组
]]
function string.split(str, separator, ...)
    local fields = {...}
    local resultStrList = {}
    local i = 1
    if str then
        string.gsub(
            str,
            "[^" .. separator .. "]+",
            function(w)
                if fields[i] then
                    if fields[i + 1] then
                        resultStrList[fields[i]] = fields[i + 1](w)
                    else
                        resultStrList[fields[i]] = w
                    end
                    i = i + 2
                else
                    table.insert(resultStrList, w)
                end
            end
        )
    end
    return resultStrList
end

--把字符串分割成整形数组
function string.splitNumber(str, separator)
    local resultStrList = {}
    if str then
        string.gsub(
            str,
            "[^" .. separator .. "]+",
            function(w)
                table.insert(resultStrList, tonumber(w) or w) --如果不是number就还是给当前自己的值
            end
        )
    end
    return resultStrList
end

--[[--
去除输入字符串头部的空白字符，返回结果
~~~ lua
local input = "  ABC"
print(string.ltrim(input))
-- 输出 ABC，输入字符串前面的两个空格被去掉了
~~~
空白字符包括：
-   空格
-   制表符 \t
-   换行符 \n
-   回到行首符 \r
@param string input 输入字符串
@return string 结果
@see string.rtrim, string.trim
]]
function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

--[[--
去除输入字符串尾部的空白字符，返回结果
~~~ lua
local input = "ABC  "
print(string.ltrim(input))
-- 输出 ABC，输入字符串最后的两个空格被去掉了
~~~
@param string input 输入字符串
@return string 结果
@see string.ltrim, string.trim
]]
function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

--[[--
去掉字符串首尾的空白字符，返回结果
@param string input 输入字符串
@return string 结果
@see string.ltrim, string.rtrim
]]
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

--[[--
将字符串的第一个字符转为大写，返回结果
~~~ lua
local input = "hello"
print(string.ucfirst(input))
-- 输出 Hello
~~~
@param string input 输入字符串
@return string 结果
]]
function string.ucfirst(input)
    return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end

local function urlencodechar(char)
    return "%" .. string.format("%02X", string.byte(char))
end

--[[--
将字符串转换为符合 URL 传递要求的格式，并返回转换结果
~~~ lua
local input = "hello world"
print(string.urlencode(input))
-- 输出
-- hello%20world
~~~
@param string input 输入字符串
@return string 转换后的结果
@see string.urldecode
]]
function string.urlencode(input)
    -- convert line endings
    input = string.gsub(tostring(input), "\n", "\r\n")
    -- escape all characters but alphanumeric, '.' and '-'
    input = string.gsub(input, "([^%w%.%- ])", urlencodechar)
    -- convert spaces to "+" symbols
    return string.gsub(input, " ", "+")
end

--[[--
将 URL 中的特殊字符还原，并返回结果
~~~ lua
local input = "hello%20world"
print(string.urldecode(input))
-- 输出
-- hello world
~~~
@param string input 输入字符串
@return string 转换后的结果
@see string.urlencode
]]
function string.urldecode(input)
    input = string.gsub(input, "+", " ")
    input =
        string.gsub(
        input,
        "%%(%x%x)",
        function(h)
            return string.char(checknumber(h, 16))
        end
    )
    input = string.gsub(input, "\r\n", "\n")
    return input
end

--[[--
计算 UTF8 字符串的长度，每一个中文算一个字符
~~~ lua
local input = "你好World"
print(string.utf8len(input))
-- 输出 7
~~~
@param string input 输入字符串
@return integer 长度
]]
function string.utf8len(input)
    local len = string.len(input)
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

--[[--
将数值格式化为包含千分位分隔符的字符串
~~~ lua
print(string.formatnumberthousands(1924235))
-- 输出 1,924,235
~~~
@param number num 数值
@return string 格式化结果
]]
function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then
            break
        end
    end
    return formatted
end

function string.isValidString(str)
    return str ~= nil and str ~= "" and str ~= "-1"
end

function wrapFunc(func, ...)
    if not assert(func ~= nil) then
        return function()
        end
    end

    local wrapedParams = {...}
    return function(...)
        local params = {}
        for i, v in ipairs(wrapedParams) do
            table.insert(params, v)
        end
        for i, v in ipairs({...}) do
            table.insert(params, v)
        end
        return func(table.unpack(params))
    end
end

function isValid(target)
    if not target then
        return false
    end
    local t = type(target)
    if t == "userdata" then
        if xlua.isNull(target) then
            return false
        end
    end
    return true
end

function isValidValue(value)
    if type(value) == "table" then
        if #value > 1 then
            return true
        end
        if #value == 0 or value[1] == -1 or value[1] == "-1" or value[1] == "" or value[1] == "-1.0" then
            return false
        end
    else
        if value == nil or value == -1 or value == "" or value == "-1" or value == "-1.0" then
            return false
        end
    end
    return true
end

function setDefaultValue(value, defaultValue)
    if value == nil then
        return defaultValue
    end
    return value
end

-- checkNotEmpty为true则检查为string且不为空串
function isString(str, checkNotEmpty)
    if checkNotEmpty then
        return type(str) == "string" and #str > 0
    else
        return type(str) == "string"
    end
end

function isNumber(target)
    return type(target) == "number" and target == target -- 过滤#IND
end

function isFunction(target)
    return type(target) == "function"
end

function isTable(target)
    return type(target) == "table"
end

function isBoolean(target)
    return type(target) == "boolean"
end

-- 序列化表
function serialize(tb, flag)
    local result = ""
    result = string.format("%s{\n", result)

    local filter = function(str)
        str = string.gsub(str, "%[", " ")
        str = string.gsub(str, "%]", " ")
        str = string.gsub(str, '"', " ")
        str = string.gsub(str, "%'", " ")
        str = string.gsub(str, "\\", " ")
        str = string.gsub(str, "%%", " ")
        return str
    end

    for k, v in pairs(tb) do
        if type(k) == "number" then
            if type(v) == "table" then
                result = string.format("%s[%d]=%s,\n", result, k, serialize(v, flag))
            elseif type(v) == "number" then
                result = string.format("%s[%d]=%s,\n", result, k, v)
            elseif type(v) == "string" then
                result = string.format("%s[%d]=%q,\n", result, k, v)
            elseif type(v) == "boolean" then
                result = string.format("%s[%d]=%s,\n", result, k, tostring(v))
            else
                if flag then
                    result = string.format("%s[%d]=%q,\n", result, k, type(v))
                else
                    error("the type of value is a function or userdata")
                end
            end
        else
            if type(v) == "table" then
                result = string.format("%s%s=%s,\n", result, k, serialize(v))
            elseif type(v) == "number" then
                result = string.format("%s%s=%s,\n", result, k, v)
            elseif type(v) == "string" then
                result = string.format("%s%s=%q,\n", result, k, v)
            elseif type(v) == "boolean" then
                result = string.format("%s%s=%s,\n", result, k, tostring(v))
            else
                if flag then
                    result = string.format("%s[%s]=%q,\n", result, k, type(v))
                else
                    error("the type of value is a function or userdata")
                end
            end
        end
    end
    result = string.format("%s}", result)
    return result
end

function getTime()
    return LuaClass.Time.realtimeSinceStartup
end

function box(msg)
    --CS.BombMan.LogUtil.MessageBox(msg,"提示")
    print(msg)
end

function safeToNumber(v)
    if not v then
        return 0
    end
    return tonumber(v)
end

function clamp(val, min, max)
    if min > max then
        local temp = min
        min = max
        max = temp
    end
    if val < min then
        val = min
    end
    if val > max then
        val = max
    end
    return val
end

function lerp(a, b, alpha)
    alpha = clamp(alpha, 0, 1)
    return a * (1.0 - alpha) + b * alpha
end

local destory = LuaClass.Object.Destroy
LuaClass.Object.Destroy = function(obj)
    --if LuaClass.StringUtil.startWith(obj.name, "effect_") then
    --    print(1)
    --end
    -- printJax("Destroy==", obj.name, debug.traceback())
    destory(obj)
end


function readonly(t)
    local meta = {
        __index = t,
        __newindex = function()
            assert(false, "table is readonly\n")
        end
    }
    local locked = {}
    setmetatable(locked, meta)
    return locked
end

table.empty = readonly({})
