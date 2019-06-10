-- function reference
-- include
local versionCfg = require("conf.version")

return function()
    return function(_, resp, next)
        resp:addHeader('X-Powered-By', versionCfg)
        next()
    end
end