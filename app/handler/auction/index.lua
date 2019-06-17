-- function reference
-- include
local newTable = require("toolkit.common").newTable
local AutoRequire = require("toolkit.autoRequire")
local wrapper = require("wrapper.index")
-- const
local regex = [[(?<path>\/\w+\/\w+\/(?<objectName>\w+))\.]]
local requirePath = "/app/handler/auction"

return function(app)
    -- the value 16 depend on function count in handler/...(except index.lua)
    local requireTable = newTable(0, 16)
    local regexInfo = { regex, "path", "objectName" }
    local Tracer = wrapper.TRACER
    local tracer = Tracer:new(Tracer.WARN)
    local autoRequire = AutoRequire:new(regexInfo, { ["index.lua"] = true }, tracer)

    autoRequire(requirePath, requireTable)

    app:erroruse("/test", requireTable.errHandler.handle)

    app:post("/auction/account/login", requireTable.account.login)
    app:post("/auction/account/logout", requireTable.account.logout)
    app:get("/auction/house/getItemList", requireTable.house.getItemList)
    app:post("/auction/house/shelf", requireTable.house.shelf)
    app:post("/auction/house/unshelf", requireTable.house.unshelf)
    app:post("/auction/house/setItemInfo", requireTable.house.setItemInfo)
    app:post("/auction/house/getItemInfo", requireTable.house.getItemInfo)
    -- todo: more auction functions are waiting for you
end
