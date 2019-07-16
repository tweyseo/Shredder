-- function reference
local HTTP_GET = ngx.HTTP_GET
-- include
local newTable = require("toolkit.common").newTable
local scheduler = require("scheduler.index")
--local utils = require("toolkit.utils")
local log = require("log.index")

local sessionTest = newTable(0, 4)

sessionTest.reflection = "sessionTest"

function sessionTest.getCache(_, resp)
    local result, err = scheduler(scheduler.CAPTURE, "/sessionTest/getCache"
        , { method = HTTP_GET })
    if not result or result.truncated == true then
        log.warn("send err: ", err)
        return resp:send("bad")
    end

    log.warn("get cache resp: ", result.body)
    resp:send("session test with get cache success!")
end

function sessionTest.setCache(_, resp)
    local result, err = scheduler(scheduler.CAPTURE, "/sessionTest/setCache"
        , { method = HTTP_GET })
    if not result or result.truncated == true then
        log.warn("send err: ", err)
        return resp:send("bad")
    end

    log.warn("set cache resp: ", result.body)
    resp:send("session test with set cache success!")
end

function sessionTest.getNocache(_, resp)
    local result, err = scheduler(scheduler.CAPTURE, "/sessionTest/getNocache"
        , { method = HTTP_GET })
    if not result or result.truncated == true then
        log.warn("send err: ", err)
        return resp:send("bad")
    end

    log.warn("get no cache resp: ", result.body)
    resp:send("session test without get cache success!")
end

function sessionTest.setNocache(_, resp)
    local result, err = scheduler(scheduler.CAPTURE, "/sessionTest/setNocache"
        , { method = HTTP_GET })
    if not result or result.truncated == true then
        log.warn("send err: ", err)
        return resp:send("bad")
    end

    log.warn("set no cache resp: ", result.body)
    resp:send("session test without set cache success!")
end

return sessionTest