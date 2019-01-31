-- function reference
local tonumber = tonumber
local ngx_null = ngx.null
-- include
local newTable = require("toolkit.common").newTable
local ec = require("def.errorCode")
local log = require("log.index")
local scheduler = require("scheduler.index")
local config = require("conf.db").redis
local utils = require("toolkit.utils")
-- const

local house = newTable(0, 5)

function house.getItemList()
    local key = "auction:house:itemList"
    local resps, err = scheduler(scheduler.REDIS, config,  { "hgetall", key })
    if not resps then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    local itemList = {}
    for i = 1, #resps, 2 do
        itemList[resps[i]] = resps[i + 1]
    end

    return ec.OK, itemList
end

function house.shelf(itemId, count)
    local key = "auction:house:itemList"
    local resp, err = scheduler(scheduler.REDIS, config,  { "hset", key, itemId, count })
    if not resp then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    if tonumber(resp) == 0 then
        log.add(log.WARN, "update item count: ", count, " item id: ", itemId)
    end

    return ec.OK
end

function house.unshelf(itemId)
    local key = "auction:house:itemList"
    local resp, err = scheduler(scheduler.REDIS, config,  { "hdel", key, itemId })
    if not resp then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    if tonumber(resp) == 0 then
        log.add(log.WARN, "unshelf item id: ", itemId, " not exist")
        return ec.AUCTION.UNSHELF_NOT_EXIST
    end

    return ec.OK
end

function house.setItemInfo(itemId, itemInfo)
    local key = "auction:house:itemInfo"
    local val = utils.json_encode(itemInfo)
    local resp, err = scheduler(scheduler.REDIS, config,  { "hset", key, itemId, val })
    if not resp then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    if tonumber(resp) == 0 then
        log.add(log.WARN, "update item info: ", val, " item id: ", itemId)
    end

    return ec.OK
end

function house.getItemInfo(itemId)
    local key = "auction:house:itemInfo"
    local resp, err = scheduler(scheduler.REDIS, config,  { "hget", key, itemId })
    if not resp then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    if resp == ngx_null then
        log.add(log.WARN, "getItemInfo item id: ", itemId, " not exist")
        return ec.AUCTION.UNSHELF_NOT_EXIST
    end

    return ec.OK, utils.json_decode(resp)
end

return house