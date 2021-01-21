function newParser()

    XmlParser = {};

    function XmlParser:ToXmlString(value)
        value = string.gsub(value, "&", "&amp;"); -- '&' -> "&amp;"
        value = string.gsub(value, "<", "&lt;"); -- '<' -> "&lt;"
        value = string.gsub(value, ">", "&gt;"); -- '>' -> "&gt;"
        value = string.gsub(value, "\"", "&quot;"); -- '"' -> "&quot;"
        value = string.gsub(value, "([^%w%&%;%p%\t% ])",
                function(c)
                    return string.format("&#x%X;", string.byte(c))
                end);
        return value;
    end

    function XmlParser:FromXmlString(value)
        value = string.gsub(value, "&#x([%x]+)%;",
                function(h)
                    return string.char(tonumber(h, 16))
                end);
        value = string.gsub(value, "&#([0-9]+)%;",
                function(h)
                    return string.char(tonumber(h, 10))
                end);
        value = string.gsub(value, "&quot;", "\"");
        value = string.gsub(value, "&apos;", "'");
        value = string.gsub(value, "&gt;", ">");
        value = string.gsub(value, "&lt;", "<");
        value = string.gsub(value, "&amp;", "&");
        return value;
    end

    function XmlParser:ParseArgs(node, s)
        string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
            node:addProperty(w, self:FromXmlString(a))
        end)
    end

    function XmlParser:ParseXmlText(xmlText)
        local stack = {}
        local top = newNode()
        table.insert(stack, top)
        local ni, c, label, xarg, empty
        local i, j = 1, 1
        while true do
            ni, j, c, label, xarg, empty = string.find(xmlText, "<(%/?)([%w_:]+)(.-)(%/?)>", i)
            if not ni then break end
            local text = string.sub(xmlText, i, ni - 1);
            if not string.find(text, "^%s*$") then
                local lVal = (top:value() or "") .. self:FromXmlString(text)
                stack[#stack]:setValue(lVal)
            end
            if empty == "/" then -- empty element tag
                local lNode = newNode(label)
                self:ParseArgs(lNode, xarg)
                top:addChild(lNode)
            elseif c == "" then -- start tag
                local lNode = newNode(label)
                self:ParseArgs(lNode, xarg)
                table.insert(stack, lNode)
                top = lNode
            else -- end tag
                local toclose = table.remove(stack) -- remove top

                top = stack[#stack]
                if #stack < 1 then
                    error("XmlParser: nothing to close with " .. label)
                end
                if toclose:name() ~= label then
                    error("XmlParser: trying to close " .. toclose.name .. " with " .. label)
                end
                top:addChild(toclose)
            end
            i = j + 1
        end
        local text = string.sub(xmlText, i);
        if #stack > 1 then
            error("XmlParser: unclosed " .. stack[#stack]:name())
        end
        return top
    end

    function XmlParser:loadFile(xmlFilename, base)
        if not base then
            base = system.ResourceDirectory
        end

        local path = system.pathForFile(xmlFilename, base)
        local hFile, err = io.open(path, "r");

        if hFile and not err then
            local xmlText = hFile:read("*a"); -- read file content
            io.close(hFile);
            return self:ParseXmlText(xmlText), nil;
        else
            print(err)
            return nil
        end
    end

    return XmlParser
end

function newNode(name)
    local node = {}
    node.___value = nil
    node.___name = name
    node.___children = {}
    node.___props = {}

    function node:value() return self.___value end
    function node:setValue(val) self.___value = val end
    function node:name() return self.___name end
    function node:setName(name) self.___name = name end
    function node:children() return self.___children end
    function node:numChildren() return #self.___children end
    function node:addChild(child)
        if self[child:name()] ~= nil then
            if type(self[child:name()].name) == "function" then
                local tempTable = {}
                table.insert(tempTable, self[child:name()])
                self[child:name()] = tempTable
            end
            table.insert(self[child:name()], child)
        else
            self[child:name()] = child
        end
        table.insert(self.___children, child)
    end

    function node:properties() return self.___props end
    function node:numProperties() return #self.___props end
    function node:addProperty(name, value)
        local lName = "@" .. name
        if self[lName] ~= nil then
            if type(self[lName]) == "string" then
                local tempTable = {}
                table.insert(tempTable, self[lName])
                self[lName] = tempTable
            end
            table.insert(self[lName], value)
        else
            self[lName] = value
        end
        table.insert(self.___props, { name = name, value = self[name] })
    end

    return node
end

local xml = newParser()

function onPublish(handler)
    if not handler.genCode then return end
    handler.genCode = false --prevent default output

    fprint("Handling gen code in plugin ")
    genCode(handler) --do it myself

    --local paramPath = string.gsub(handler.project.assetsPath, "assets$", "Param.txt")
    --local path = string.gsub(handler.project.assetsPath, "assets$", "GenLuaClass.exe")
    --local f = io.popen(path, "r")
    --local s = f:read('*a')
    --f:close()
    --fprint("path="..s)

    --local item = handler.pkg:GetItem("sitlg8e1")
    --fprint("item" .. (item and "tre" or "false") .. item.path)
    --fprint("handler.pkg=" ..handler.pkg.id)
    --local item = handler.project:GetItem(handler.pkg.id, "sitlg8e1")
    --fprint("item" .. item.file)
end

local function readFile(f)
    local proto = assert(io.open(f), "Can't open filename[" .. f .. "]")
    local result = proto:read("*a")
    proto:close()
    return result
end

-- this is copied from Editor-Install-Path/Resources/Data/StreamingAssets/Scripts
function genCode(handler) 
    local settings = handler.project:GetSettings("Publish").codeGeneration
    local codePkgName = handler:ToFilename(handler.pkg.name); --convert chinese to pinyin, remove special chars etc.
    local exportCodePath = handler.exportCodePath..'\\'..codePkgName
    exportCodePath = string.gsub(exportCodePath, "FairyGUIProj\\..\\", "")
    local namespaceName = codePkgName
    local ns = 'FairyGUI'
    
    if settings.packageName~=nil and settings.packageName~='' then
        namespaceName = settings.packageName..'.'..namespaceName;
    end

    --CollectClasses(stripeMemeber, stripeClass, fguiNamespace)
    local classes = handler:CollectClasses(settings.ignoreNoname, settings.ignoreNoname, ns)
    handler:SetupCodeFolder(exportCodePath, "lua") --check if target folder exists, and delete old files

    --local f = io.popen([["del C:\a\*.*]], "r")
    --f:close()
    --local f2 = io.popen("rd /s C:\\a", "r")
    --f2:close()
    --fprint("exportCodePath=" .. exportCodePath)

    local getMemberByName = settings.getMemberByName

    local classCnt = classes.Count
    --fprint("classCnt = ".. classCnt .. "path=" .. exportCodePath)


    for i=0,classCnt-1 do

        local writer = {}
        local appendLine = function(str, ...)
            table.insert(writer, string.format(str, ...))
        end

        local classInfo = classes[i]
        local references = classInfo.references
        local str = readFile(classInfo.res.file)
        local parsedXml = xml:ParseXmlText(str)
        local members = getMembers(handler.pkg, parsedXml, "view", {}, handler)
        local memberCnt = #members

        --fprint(classInfo.className)
        local className = string.gsub(classInfo.className, "^UI_", "")
        local superClassName = classInfo.superClassName
        className = "UI_" .. handler.pkg.name .. "_" .. className
        appendLine("---@class %s:%s", className, superClassName)

        for j = 1, memberCnt do
            local memberInfo = members[j]
            appendLine("---@field %s %s", memberInfo.varName, memberInfo.type)
        end

        appendLine("local %s = class(\"%s\")", className, className)
        appendLine("")
        appendLine("%s.PackageName = \"%s\"", className, codePkgName)
        appendLine("%s.Path = \"%s\"", className, classInfo.res.path .. classInfo.res.name)
        appendLine("")
        appendLine("function %s.Construct(view)", className)

        --local xmlNode = classInfo.res:Serialize(false)
        local xmlNode = handler:GetItemDesc(classInfo.res)
        --appendLine("xmlNode:ToXMLString()==="..classInfo.res.fileName)
        --appendLine("classInfo.res.fileName" .. classInfo.res.fileName)
        --appendLine("classInfo.res.file" .. classInfo.res.file)



        --fprint("memberCnt = " .. handler.pkg.name)

        for j=1,memberCnt do
            local memberInfo = members[j]
            appendLine("    ---@type %s", memberInfo.type)
            if memberInfo.group==0 then
                if getMemberByName then
                    appendLine('    view.%s = %s:GetChild("%s")', memberInfo.varName, memberInfo.parentVar, memberInfo.name)
                else
                    appendLine('    view.%s = %s:GetChildAt(%s)', memberInfo.varName, memberInfo.parentVar, memberInfo.index)
                end
            elseif memberInfo.group==1 then
                if getMemberByName then
                    appendLine('    view.%s = %s:GetController("%s")', memberInfo.varName, memberInfo.parentVar, memberInfo.name)
                else
                    appendLine('    view.%s = %s:GetControllerAt(%s)', memberInfo.varName, memberInfo.parentVar, memberInfo.index)
                end
            else
                if getMemberByName then
                    appendLine('    view.%s = %s:GetTransition("%s")', memberInfo.varName, memberInfo.parentVar, memberInfo.name)
                else
                    appendLine('    view.%s = %s:GetTransitionAt(%s)', memberInfo.varName, memberInfo.parentVar, memberInfo.index)
                end
            end

            if memberInfo.isComponent then
                appendLine('    LuaClass.%s.Construct(%s.%s)', memberInfo.type, memberInfo.parentVar, memberInfo.varName)
            end
        end
        appendLine("end")
        appendLine("")
        appendLine("return %s", className)


        --for i, v in pairs(mems) do
        --
        --    appendLine("k=%s, %s", i, v:ToXMLString())
        --end

        local str = table.concat(writer, "\n")
        writeFile(exportCodePath..'/'.. className ..'.lua', str, "w+")
    end
end

function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function getType(pkg, node, handler)
    local name = string.gsub(node:name(),"^%a", string.upper)
    if name == "Component" then

        local src = node["@src"]
        --fprint("p = " .. pkg.name .. " " .. node["@fileName"])
        local item = pkg:GetItem(src)
        local fileName = item.file
        local temp = string.split(fileName, "/")
        local name = string.gsub(temp[#temp], ".xml$", "")
        return "UI_" .. pkg.name .. "_" .. name, true
    end

    if name == "Text" then
        if node["@input"] == "true" then
            name = "TextInput"
        else
            name = "TextField"
        end
    elseif name == "Richtext" then
        name = "RichTextField"
    end
    return "FairyGUI.G" .. name
end

function getXmlNode(pkg, node, handler)
    local name = string.gsub(node:name(),"^%a", string.upper)
    if name == "Component" then
        --local pkg = handler.pkg.id
        --if node["@pkg"] then
        --    pkg = node["@pkg"]
        --end
        local src = node["@src"]

        local item = pkg:GetItem(src)
        local fileName = item.file

        local str = readFile(fileName)
        return xml:ParseXmlText(str)
    end
    return node
end

function getMembers(pkg, parsedXml, parentVar, result, handler)
    result = result or {}

    local displayList = parsedXml.component.displayList
    local data
    if displayList then
        displayList = displayList:children()
        local childIndex = -1
        for i, v in ipairs(displayList) do
            local nodeName = v:name()
            if nodeName ~= "group" or v["@advanced"] == "true" then
                childIndex = childIndex + 1
                local varName = v["@name"]
                --fprint("varName=" .. varName .. "," .. (f or "nil"))
                if not string.match(varName, "^n%d+") then
                    if not result[varName] then
                        local p = pkg
                        if v["@pkg"] then
                            p = handler.project:GetPackage(v["@pkg"])
                        end

                        local ntype, isComponent = getType(p, v, handler)
                        data = {
                            varName = "_" .. varName,
                            index = childIndex,
                            name = varName,
                            parentVar = parentVar,
                            group = 0,
                            type = ntype,
                            isComponent = isComponent
                        }
                        table.insert(result, data)
                        result[varName] = data
                    else
                        --fprint("error name")
                    end
                end
            end
        end
    end


    local ctrls = parsedXml.component.controller
    if ctrls then
        local addCtrl = function(node, i)
            local varName = node["@name"]
            if varName and not result[varName] then
                local tstr = varName
                if not string.match(tstr, "Ctrl$") then
                    tstr = tstr .. "Ctrl"
                end
                data = {
                    varName = "_" .. tstr,
                    index = i-1,
                    name = varName,
                    parentVar = parentVar,
                    group = 1,
                    type = "FairyGUI.Controller"
                }
                table.insert(result, data)
                result[varName] = data
            end
        end
        local num = #ctrls
        if num == 0 then
            addCtrl(ctrls, 1)
        else
            for i = 1, num do
                addCtrl(ctrls[i], i)
            end
        end
    end

    local tr = parsedXml.component.transition
    if tr then
        local addTrans = function(node, i)
            local varName = node["@name"]
            if varName and not result[varName] then
                local tstr = varName
                if not string.match(tstr, "Trans$") then
                    tstr = tstr .. "Trans"
                end
                data = {
                    varName = "_" .. tstr,
                    index = i-1,
                    name = varName,
                    parentVar = parentVar,
                    group = 2,
                    type = "FairyGUI.Transition"
                }
                table.insert(result, data)
                result[varName] = data
            end
        end
        local num = #tr
        if num == 0 then
            addTrans(tr, 1)
        else
            for i = 1, num do
                addTrans(tr[i], i)
            end
        end
    end



    if displayList then
        for i, v in ipairs(displayList) do
            local fileName = v["@fileName"]
            if fileName and string.match(fileName, ".xml$") then
                local p = pkg
                if v["@pkg"] then
                    p = handler.project:GetPackage(v["@pkg"])
                end
                local xmlNode = getXmlNode(p, v, handler)
                getMembers(p, xmlNode, parentVar .. "._" .. v["@name"], result, handler)
            end
        end
    end

    return result
end

function writeFile(f, c, mode)
    local proto = assert(io.open(f, mode))
    proto:write(c)
    proto:close()
end