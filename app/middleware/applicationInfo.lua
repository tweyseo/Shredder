-- function reference
-- include
local serverInfo = require("conf.serverInfo")
-- const
local versionIdx = 2

return function()
    return function(_, resp, next)
        resp:addHeader('X-Powered-By', serverInfo[versionIdx])
        next()
    end
end