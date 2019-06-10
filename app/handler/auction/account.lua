-- function reference
-- include
local newTable = require("toolkit.common").newTable
local ec = require("def.errorCode")
local auctionModel = require("model.auction.index")

local account = newTable(0, 2)

--[[
    in my production, there was a common components to transform code in current spec to other
    code under specified spec, which was like: ec = transform(srcModuleId, dstModuleId, errCode).
]]
function account.login(req, resp)
    local accountName = req.body.accountName
    local password = req.body.password
    local errCode, accountId = auctionModel.account.auth(accountName, password)
    if errCode ~= ec.OK then
        -- todo: process code and transform it to client spec
        return resp:json({ ec = errCode })
    end

    local token
    errCode, token = auctionModel.account.login(accountId)
    if errCode ~= ec.OK then
        -- todo: process code and transform it to client spec
        return resp:json({ ec = errCode })
    end

    -- todo: transform code to client spec
    resp:json({ ec = errCode, token = token })
end

function account.logout(req, resp)
    local token = req.body.token
    local errCode = auctionModel.account.logout(token)
    if errCode ~= ec.OK then
        -- todo: process code and transform it to client spec
        return resp:json({ ec = errCode })
    end

     -- todo: transform code to client spec
     resp:json({ ec = errCode })
end

return account