-- function reference
-- include
local newTable = require("toolkit.common").newTable
local log = require("log.index")

local errHandler = newTable(0, 1)

function errHandler.handle(err)
    log.warn("auction/ error handler: ", err)
end

return errHandler