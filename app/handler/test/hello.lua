-- function reference
local HTTP_POST = ngx.HTTP_POST
local now = ngx.now
-- include
local newTable = require("toolkit.common").newTable
local scheduler = require("scheduler.index")
local utils = require("toolkit.utils")
local log = require("log.index")
local wrapper = require("wrapper.index")

local hello = newTable(0, 4)

hello.reflection = "hello"

function hello.tcp(_, res)
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

local Checker = wrapper.CHECKER
local checklist =  { ["checkTest"] = {
    ["test"] = {
        ["params"] =
            { "string", "nil", { "number", "nil", { a = "number", b = "nil", c= "string" } } }
    } } }
local checker = Checker:new(checklist)

local checkTest = {}

function checkTest.test(a, b, c)
    local _, _, _ = a, b, c
end

local wo = checker:wrap(checkTest, { source = "/handler/test/hello(checkTest)", name = "checkTest"})

function hello.check(_, res)
    wo.test("tweyseo", "skip", { 13, "skip", { 13, b = "skip", c = "tweyseo" } })
    --checkTest.test()
    res:send("check succ!")
end

return hello