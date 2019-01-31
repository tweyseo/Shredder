-- function reference
-- include
local lor = require("lor.index")
local init = require("init")
local versionCfg = require("conf.version")
local appInfoMW = require("middleware.applicationInfo")
--local whitePathList = require("conf.whitePathList")
--local validateLoginMiddleware = require("middleware.validateLogin")
local router = require("router")
local log = require("log.index")

local app = lor()

init(app)

app:use(appInfoMW(versionCfg))
--app:use(validateLoginMiddleware(whitePathList))

router(app)

app:erroruse(function(err, req, res)
    log.warn("default error handler: ", err)

    if req:is_found() then
        res:status(500):send("server error.")
    else
        res:status(404):send("404! sorry, not found.")
    end
end)

return app
