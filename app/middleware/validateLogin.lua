-- function reference
local match = ngx.re.match
local ipairs = ipairs
-- include

return function(whitePathList)
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
        -- use sharedict or redis to save session
        if white then
            next()
        else
            next("please login first")
        end
    end
end

