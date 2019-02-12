-- function reference
local HTTP_POST = ngx.HTTP_POST
local now = ngx.now
-- include
local newTable = require("toolkit.common").newTable
local scheduler = require("scheduler.index")
local utils = require("toolkit.utils")
local log = require("log.index")

local hello = newTable(0, 4)

hello.reflection = "hello"

function hello.tcp(_, res)
    --res:send("hello too!")
    local resp, err = scheduler(scheduler.TCP
        , { addr = "192.25.106.105", port = 19527 }
        , { id = 1, body = { time = now() }
    })
    if not resp then
        log.warn("send err: ", err)
        return res:send("bad")
    end

    log.warn("resp: ", utils.json_encode(resp))
    res:send("hello too!")
end

function hello.http(_, res)
     -- performance better
    --[[local resp, err = scheduler(scheduler.HTTP
        , { addr = "192.25.106.105", port = 29527 }
        , { path = "/ping", body = { time = ngx.now() } })]]
    local resp, err = scheduler(scheduler.HTTP
        , "http://192.25.106.105:29527/ping"
        , { body = { time = now() } })
    if not resp then
        log.warn("send err: ", err)
        return res:send("bad")
    end

    log.add(log.WARN, "resp: ", utils.json_encode(resp))
    res:send("hello too!")
end

function hello.capture(_, res)
    local resp, err = scheduler(scheduler.CAPTURE, "/ping"
        , { headers = { hello = "world" }, method = HTTP_POST, body = { time = now() } })
    if not resp then
        log.warn("send err: ", err)
        return res:send("bad")
    end

    log.warn("resp: ", utils.json_encode(resp))
    res:send("hello too!")
end

return hello