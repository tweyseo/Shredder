-- function reference
local find = ngx.re.find
local ipairs = ipairs
-- include
local whitePathList = require("conf.whitePathList")

return function()
    return function(req, _, next)
        local requestPath = req.path
        local white = false
        for _, v in ipairs(whitePathList) do
            if find(requestPath, v, "jo") then
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

