-- function reference
-- include
local newTable = require("toolkit.common").newTable
local AutoRequire = require("toolkit.autoRequire")
local wrapper = require("wrapper.index")
-- const
local regex = [[(?<path>\/\w+\/\w+\/(?<objectName>\w+))\.]]
local requirePath = "/app/model/auction"

return (function()
    -- the value 16 depend on function count in model/...(except index.lua)
    local requireTable = newTable(0, 16)
    local regexInfo = { regex, "path", "objectName" }
    local Tracer = wrapper.TRACER
    local tracer = Tracer:new(Tracer.WARN)
    local autoRequire = AutoRequire:new(regexInfo, { ["index.lua"] = true }, tracer)

    autoRequire(requirePath, requireTable)

    return requireTable
end)()