-- function reference
local at = ngx.timer.at
-- include
local common = require("toolkit.common")
local log = require("log.index")

local doLog = function(_, id, status, elapsedTime, logs, traces)
    log.overview("id:", id, " status:", status, " elapsed:", elapsedTime, "\n"
        , logs and logs.."\n" or "", traces and traces.."\n" or "")
end

-- respone delay not affected by the log stage, so the CPU is left to other requests process
at(0, doLog, common.reqId(), common.status(), common.reqTime(), log.fetchLog(), log.fetchTrace())