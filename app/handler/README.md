# **handler**

## **Overview**

It splitted different modules by different folders in **handler**. **as a spec**, it include a necessary *index.lua* and an optional *errHandler.lua* in each modules (folders), where the necessary *index.lua* specified the routing rules of URI actually, and the optional *errHandler.lua* was to instead of the default error handler which defined in the *server.lua*, the remaining lua files in each modules (folders) were **module units** containing **route handler functions** which were store in *index.lua* actually.
 
Route handler functions only parsing message, scheduling **models** which handled logic actually, and doing response. it's important to note that, **as a spec**, the business logic was processed in **model** **only** and route handler functions here just scheduling them.

In this demo of APIServer, using [**autoRuqire**](https://github.com/tweyseo/Mirana/blob/master/toolkit/autoRequire.lua) to require route handler functions automatically, and wrapping them with [**tracer**](https://github.com/tweyseo/Mirana/blob/master/wrapper/plugin/tracer.lua) for invoke tracing.

## **Useage**

```
-- test.lua
local test = {}

function test.doTest(req, resp)
   -- do something
end

return test

-- errHandler.lua
local log = require("log.index")

local errHandler = {}

function errHandler.handle(err)
    log.warn("test/ error handler: ", err)
end

return errHandler

-- index.lua
local AutoRequire = require("toolkit.autoRequire")
local wrapper = require("wrapper.index")
local regex = [[(?<path>\/\w+\/\w+\/(?<objectName>\w+))\.]]
local requirePath = "/app/handler/test"

return function(app)
    local requireTable = {}
    local regexInfo = { regex, "path", "objectName" }
    local Tracer = wrapper.TRACER
    local tracer = Tracer:new(Tracer.WARN)
    local autoRequire = AutoRequire:new(regexInfo, { ["index.lua"] = true }, tracer)

    autoRequire(requirePath, requireTable)

    app:get("/test/hello", requireTable.test.doTest)

    app:erroruse("/test", requireTable.errHandler.handle)
end
```

## **TODO**