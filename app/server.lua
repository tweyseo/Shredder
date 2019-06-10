-- function reference
-- include
local App = require("app.index")--local lor = require("lor.index")--
local router = require("router")
local log = require("log.index")

local app = App:new()--local app = lor()--

function app:init()
    -- default err hander for root path
    self:erroruse(function(err, req, resp)
        log.warn("default error handler: ", err)

        if req:hasFound() then
            resp:setStatus(500):send("server error.")
        else
            resp:setStatus(404):send("404! sorry, not found.")
        end
    end)

    router(self)
end

return app
