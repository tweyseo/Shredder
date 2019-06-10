-- function reference
-- include
local newTable = require("toolkit.common").newTable
local ec = require("def.errorCode")
local auctionModel = require("model.auction.index")
local log = require("log.index")

local house = newTable(0, 5)

--[[
    in my production, there was a common components to transform code in current spec to other
    code under specified spec, which was like: ec = transform(srcModuleId, dstModuleId, errCode).
]]
function house.getItemList(_, resp)
    local errCode, itemList = auctionModel.house.getItemList()
    if errCode ~= ec.OK then
        -- todo: process code and transform it to client spec
        return resp:json({ ec = errCode })
    end

    -- todo: transform code to client spec
    resp:json({ ec = errCode, itemList = itemList })
end

function house.shelf(req, resp)
    local token =  req.body.token
    local errCode = auctionModel.account.logined(token)
    if errCode ~=ec.OK then
        if errCode == ec.AUCTION.NOT_YET_LOGIN then
            log.add(log.WARN, "not login yet, token: ", token or "nil")
        end
        return resp:json({ ec = errCode })
    end

    local itemId = req.body.itemId
    local count = req.body.count
    errCode = auctionModel.house.shelf(itemId, count)
    if errCode ~= ec.OK then
        -- todo: process code and transform it to client spec
        return resp:json({ ec = errCode })
    end

    -- todo: transform code to client spec
    resp:json({ ec = errCode })
end

function house.unshelf(req, resp)
    local token =  req.body.token
    local errCode = auctionModel.account.logined(token)
    if errCode ~=ec.OK then
        if errCode == ec.AUCTION.NOT_YET_LOGIN then
            log.add(log.WARN, "not login yet, token: ", token or "nil")
        end
        return resp:json({ ec = errCode })
    end

    local itemId = req.body.itemId
    errCode = auctionModel.house.unshelf(itemId)
    if errCode ~= ec.OK then
        -- todo: process code and transform it to client spec
        return resp:json({ ec = errCode })
    end

    -- todo: transform code to client spec
    resp:json({ ec = errCode })
end

function house.setItemInfo(req, resp)
    local token =  req.body.token
    local errCode = auctionModel.account.logined(token)
    if errCode ~=ec.OK then
        if errCode == ec.AUCTION.NOT_YET_LOGIN then
            log.add(log.WARN, "not login yet, token: ", token or "nil")
        end
        return resp:json({ ec = errCode })
    end

    local itemId = req.body.itemId
    local itemInfo = req.body.itemInfo
    errCode = auctionModel.house.setItemInfo(itemId, itemInfo)
    if errCode ~= ec.OK then
        -- todo: process code and transform it to client spec
        return resp:json({ ec = errCode })
    end

    -- todo: transform code to client spec
    resp:json({ ec = errCode })
end

function house.getItemInfo(req, resp)
    local itemId = req.body.itemId
    local errCode, itemInfo = auctionModel.house.getItemInfo(itemId)
    if errCode ~= ec.OK then
        -- todo: process code and transform it to client spec
        return resp:json({ ec = errCode })
    end

    -- todo: transform code to client spec
    resp:json({ ec = errCode, itemInfo = itemInfo })
end

return house