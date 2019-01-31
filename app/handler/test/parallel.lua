-- function reference
local unpack = unpack
local HTTP_POST = ngx.HTTP_POST
local now = ngx.now
-- include
local newTable = require("toolkit.common").newTable
local flowCtrl = require("flowCtrl.index")
local rdsconfig = require("conf.db").redis
local rcconfig = require("conf.db").rediscluster
local scheduler = require("scheduler.index")
local utils = require("toolkit.utils")
local log = require("log.index")

local func = function(...)
    return { scheduler(...) }
end

local parallel = newTable(0, 3)

function parallel.common(_, res)
    local pc = flowCtrl.PARALLEL
    local tcpconf = { addr = "192.25.106.105", port = 19527 }
    local resps = pc({ func, { scheduler.TCP, tcpconf, { id = 1, body = { time = now() } } } }
        , { func, { scheduler.REDIS, rdsconfig, { "select", 1 }, { "get", 20181212 } } }
        , { func, { scheduler.REDISCLUSTER, rcconfig, { "get", 20181212 } } })
    -- tcp
    local result, err = unpack(resps[1])
    if result then
        if result[1] then
            log.warn("tcp resp: ", utils.json_encode(result[1]))
        else
            log.warn("tcp resp failed, error: ", result[2])
        end
    else
        log.warn("tcp resp parallel failed, error: ", err)
        res:send("parallel failed!")
        return
    end

    -- redis
    result, err = unpack(resps[2])
    if result then
        local ret
        ret, err = unpack(result)
        if ret then
            log.warn("redis resp: ", ret[2])
        else
            log.warn("redis resp failed, error: ", err)
        end
    else
        log.warn("redis resp parallel failed, error: ", err)
        res:send("parallel failed!")
        return
    end

    -- rediscluster
    result, err = unpack(resps[3])
    if result then
        local ret
        ret, err = unpack(result)
        if ret then
            log.warn("rediscluster resp: ", ret[1])
        else
            log.warn("rediscluster resp failed, error: ", err)
        end
    else
        log.warn("rediscluster resp parallel failed, error: ", err)
        res:send("parallel failed!")
        return
    end

    res:send("parallel succ!")
end

function parallel.professional(_, res)
    local pp = flowCtrl.PARALLEL_PRO
    local url = "http://192.25.106.105:29527/ping"
    local resps = pp({ func, { scheduler.HTTP, url, { body = { time = now() } } } }
        , { func, { scheduler.REDIS, rdsconfig, { "select", 1 }, { "get", 20181212 } } }
        , { func, { scheduler.REDISCLUSTER, rcconfig, { "get", 20181212 } }, true
            , function(result, err)
                if result then
                    local ret
                    ret, err = unpack(result)
                    if ret then
                        log.warn("[cb] rediscluster resp: ", ret[1])
                    else
                        log.warn("[cb] rediscluster resp failed, error: ", err)
                    end
                else
                    log.warn("[cb] rediscluster resp parallel ingnore error: ", err)
                end
            end }
        , { func, { scheduler.CAPTURE, "/ping"
            , { headers = { hello = "world" }, method = HTTP_POST, body = { time = now() } }, true }
        })
    -- http
    local result, err = unpack(resps[1])
    if result then
        if result[1] then
            log.warn("tcp resp: ", utils.json_encode(result[1]))
        else
            log.warn("tcp resp failed, error: ", result[2])
        end
    else
        log.warn("tcp resp parallel failed, error: ", err)
        res:send("parallel failed!")
        return
    end

    -- redis
    result, err = unpack(resps[2])
    if result then
        local ret
        ret, err = unpack(result)
        if ret then
            log.warn("redis resp: ", ret[2])
        else
            log.warn("redis resp failed, error: ", err)
        end
    else
        log.warn("redis resp parallel failed, error: ", err)
        res:send("parallel failed!")
        return
    end

    res:send("parallel succ!")
end

function parallel.race(_, res)
    local pr = flowCtrl.PARALLEL_RACE
    local resp, err = pr({ func
        , { scheduler.REDIS, rdsconfig, { "select", 1 }, { "get", 20181212 } } }
        , { func, { scheduler.REDISCLUSTER, rcconfig, { "get", 20181212 } } })
    -- redis or rediscluster(actually, it's redis)
    if resp then
        local ret
        ret, err = unpack(resp)
        if ret then
            log.warn("redis resp: ", ret[2])
        else
            log.warn("redis resp failed, error: ", err)
        end
    else
        log.warn("resp parallel failed, error: ", err)
        res:send("parallel failed!")
        return
    end

    res:send("parallel succ!")
end

return parallel