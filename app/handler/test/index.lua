-- function reference
-- include
local newTable = require("toolkit.common").newTable
local AutoRequire = require("toolkit.autoRequire")
local wrapper = require("wrapper.index")
-- const
local regex = [[(?<path>\/\w+\/\w+\/(?<objectName>\w+))\.]]
local requirePath = "/app/handler/test"

return function(app)
    -- the value 16 depend on function count in handler/...(except index.lua)
    local requireTable = newTable(0, 16)
    local regexInfo = { regex, "path", "objectName" }
    local Tracer = wrapper.TRACER
    --local tracer = Tracer:new(Tracer.WARN, { ["hello"] = { ["http"] = true, ["capture"] = true }})
    -- equal to：
    local tracer = Tracer:new(Tracer.WARN, { ["hello"] = { ["tcp"] = true } }, true)
    local autoRequire = AutoRequire:new(regexInfo, { ["index.lua"] = true }, tracer)

    autoRequire(requirePath, requireTable)

    -- hello test
    app:get("/test/hello", requireTable.hello.tcp)
    app:get("/test/httpHello", requireTable.hello.http)
    app:get("/test/captureHello", requireTable.hello.capture)
    app:get("/test/check", requireTable.hello.check)

     -- redis test
     app:get("/test/rdsSet", requireTable.redis.set)
     app:post("/test/rdsGet", requireTable.redis.get)
     app:get("/test/rcSet", requireTable.redis.rcSet)
     app:post("/test/rcGet", requireTable.redis.rcGet)

    -- parallel test
    app:get("/test/parallel", requireTable.parallel.common)
    app:get("/test/parallelPro", requireTable.parallel.professional)
    app:get("/test/parallelRace", requireTable.parallel.race)

    app:erroruse("/test", requireTable.errHandler.handle)
end
