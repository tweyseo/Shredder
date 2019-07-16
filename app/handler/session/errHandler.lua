-- function reference
-- include
local newTable = require("toolkit.common").newTable
local log = require("log.index")

local errHandler = newTable(0, 1)

function errHandler.handle(err, _, _, next)
    log.warn("session test error handler: ", err)
    next(err)
end

return errHandler