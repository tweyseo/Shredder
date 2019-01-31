# **stage**

## **Overview**

It were entrances of each stage (except `content_by_lua_*`) that specifed in nginx-*.conf.

## **Useage**

```
# nginx-prod.conf
# Runtime
location / {
    content_by_lua_file ./app/main.lua;
    log_by_lua_file ./app/stage/logStage.lua;
}

-- logStage.lua
local at = ngx.timer.at
local common = require("toolkit.common")
local log = require("log.index")

local doLog = function(_, id, status, elapsedTime, logs, traces)
    log.overview("id:", id, " status:", status, " elapsed:", elapsedTime, "\n"
        , logs and logs.."\n" or "", traces and traces.."\n" or "")
end

-- respone delay not affected by the log stage, so the CPU is left to other requests process
at(0, doLog, common.reqId(), common.status(), common.reqTime(), log.fetchLog(), log.fetchTrace())
```

## **TODO**