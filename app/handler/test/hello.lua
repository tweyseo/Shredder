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

function hello.tcp(_, resp)
    local result, err = scheduler(scheduler.TCP
        , { addr = "192.25.106.105", port = 19527 }
        , { id = 1, body = { time = now() }
    })
    if not result then
        log.warn("send err: ", err)
        return resp:send("bad")
    end

    log.warn("resp: ", utils.json_encode(result))
    resp:send("hello too!")
end

function hello.http(_, resp)
    local result, err = scheduler(scheduler.HTTP
        , "http://192.25.106.105:29527/ping"
        , { body = { time = now() } })
    if not result then
        log.warn("send err: ", err)
        return resp:send("bad")
    end

    log.add(log.WARN, "resp: ", utils.json_encode(result))
    resp:send("hello too!")
end

function hello.capture(_, resp)
    local result, err = scheduler(scheduler.CAPTURE, "/ping"
        , { headers = { hello = "world" }, method = HTTP_POST
        , body = utils.json_encode({ time = now() }) })
    if not result or result.truncated == true then
        log.warn("send err: ", err)
        return resp:send("bad")
    end

    log.warn("resp: ", utils.json_encode(result))
    resp:send("hello too!")
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

function hello.check(_, resp)
    wo.test("tweyseo", "skip", { 13, "skip", { 13, b = "skip", c = "tweyseo" } })
    --checkTest.test()
    resp:send("check succ!")
end

return hello