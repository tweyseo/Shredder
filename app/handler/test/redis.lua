-- function reference
local ipairs = ipairs
local type = type
local unpack = unpack
-- include
local newTable = require("toolkit.common").newTable
local utils = require("toolkit.utils")
local scheduler = require("scheduler.index")
local config = require("conf.db")
local log = require("log.index")

local redis = newTable(0, 4)

local key1 = 20181211
local key2 = 20181212
local value = utils.json_encode({
    accountServer = {
        id = 6,
        pwd = 123456,
        name = "tweyseo",
        type = 1
    },
    gameServer = {
        id = 7,
        name = "playerTweyseo",
        money = 500000,
        lv = 13
    }
})

function redis.set(_, res)
    local resps, err = scheduler(scheduler.REDIS, config.redis
        , { "set", key1, value }, { "select", 1 }, { "set", key2, value })
    if not resps then
        log.warn("redis pipeline err: ", err)
        return res:send("redis pipeline error.")
    end

    local resp
    for i, v in ipairs(resps) do
        -- note: unpack it's NYI
        resp, err = unpack(type(v) == "table" and v or { v })
        -- false means valid redis error value
        if resp == false then
            log.add(log.WARN, "command [", i, "] err: ", err)
        else
            log.add(log.WARN, "command [", i, "] resp: ", resp)
        end
    end

    res:send("redis pipeline complete.")
end

function redis.get(req, res)
    local resps, err = scheduler(scheduler.REDIS, config.redis, { "select", 1 }, { "get", key2 })
    if not resps then
        log.warn("redis pipeline err: ", err)
        return res:send("redis pipeline error.")
    end

    local resp, ret = resps[2]
    -- note: unpack it's NYI
    ret, err = unpack(type(resp) == "table" and resp or { resp })
    -- false means valid redis error value
    if ret == false then
        local content = "get ["..key2.."] failed, err: "..err
        log.warn(content)
        return res:send(content)
    end

    -- if value is empty, redis will return ngx.null which pass to json_decode will return nil
    local info = utils.json_decode(ret)
    local serverType = req.body.serverType
    local specificInfo = info and info[serverType] or nil

    local content = "get "..(serverType or "nil").." server info"
    local jsonSpecificInfo = utils.json_encode(specificInfo)
    log.warn(content, ": ", jsonSpecificInfo or "nil")
    res:send(content.." succ.")
end

function redis.rcSet(_, res)
    local resps, err = scheduler(scheduler.REDISCLUSTER, config.rediscluster
        , { "set", key1, value }, { "set", key2, value })
    if not resps then
        log.warn("redis pipeline err: ", err)
        return res:send("redis pipeline error.")
    end

    local resp
    for i, v in ipairs(resps) do
        -- note: unpack it's NYI
        resp, err = unpack(type(v) == "table" and v or { v })
        -- false means valid redis error value
        if resp == false then
            log.add(log.WARN, "command [", i, "] err: ", err)
        else
            log.add(log.WARN, "command [", i, "] resp: ", resp)
        end
    end

    res:send("redis pipeline complete.")
end

function redis.rcGet(req, res)
    local resp, err = scheduler(scheduler.REDISCLUSTER, config.rediscluster, { "get", key2 })
    if not resp then
        log.warn("redis err: ", err)
        return res:send("redis error.")
    end

    -- if value is empty, redis will return ngx.null which pass to json_decode will return nil
    local info = utils.json_decode(resp)
    local serverType = req.body.serverType
    local specificInfo = info and info[serverType] or nil

    local content = "get "..(serverType or "nil").." server info"
    local jsonSpecificInfo = utils.json_encode(specificInfo)
    log.warn(content, ": ", jsonSpecificInfo or "nil")
    res:send(content.." succ.")
end

return redis