-- function reference
local match = ngx.re.match
local ipairs = ipairs
-- include
local whitePathList = require("conf.whitePathList")

return function()
    return function(req, _, next)
        local requestPath = req.path
        local white = false
        local captures
        for _, v in ipairs(whitePathList) do
            captures = match(requestPath, v, "jo")
            if captures then
                white = true
                goto goon
            end
        end

        ::goon::
        if white then
            next()
        else
            next("please login first")
        end
    end
end

