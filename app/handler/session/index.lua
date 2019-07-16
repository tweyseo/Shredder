-- function reference
-- include
local newTable = require("toolkit.common").newTable
local AutoRequire = require("toolkit.autoRequire")
local wrapper = require("wrapper.index")
-- const
local regex = [[(?<path>\/\w+\/\w+\/(?<objectName>\w+))\.]]
local requirePath = "/app/handler/session"

return function(app)
    -- the value 16 depend on function count in handler/...(except index.lua)
    local requireTable = newTable(0, 16)
    local regexInfo = { regex, "path", "objectName" }
    local Tracer = wrapper.TRACER
    local tracer = Tracer:new(Tracer.WARN)
    local autoRequire = AutoRequire:new(regexInfo, { ["index.lua"] = true }, tracer)

    autoRequire(requirePath, requireTable)
    app:erroruse("/session", requireTable.errHandler.handle)

    -- session test
    app:get("/session/getCache", requireTable.test.getCache)
    app:get("/session/setCache", requireTable.test.setCache)
    app:get("/session/getNocache", requireTable.test.getNocache)
    app:get("/session/setNocache", requireTable.test.setNocache)
end
