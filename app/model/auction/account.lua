-- function reference
local type = type
local ngx_null = ngx.null
local concat = table.concat
-- include
local common = require("toolkit.common")
local ec = require("def.errorCode")
local log = require("log.index")
local scheduler = require("scheduler.index")
local config = require("conf.db").redis
-- const
local accountIdExpireTime = 60 -- seconds

local account = common.newTable(0, 3)

function account.auth(accountName, password)
    if type(accountName) ~= "string" or type(password) ~= "string" then
        log.warn("invalid params")
        return ec.AUCTION.PARAMS_INVALID
    end

    local key = concat({ "auction", "account", accountName, password }, ":")
    local resp, err = scheduler(scheduler.REDIS, config, { "get", key })
    if not resp then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    -- if value is empty, redis will return ngx.null
    if resp == ngx_null then
        log.add(log.WARN, "auth failed, err: incorrect accountName or password")
        return ec.AUCTION.AUTH_FAILED
    end

    return ec.OK, resp
end

function account.login(accountId)
    if type(accountId) ~= "string" then
        log.warn("invalid params")
        return ec.AUCTION.PARAMS_INVALID
    end

    local key = concat({ "auction", "account", accountId }, ":")
    local resp, err = scheduler(scheduler.REDIS, config
        , { "set", key, 1, "ex", accountIdExpireTime, "nx" })
    if not resp then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    if resp == ngx_null then
        log.add(log.WARN, "accountId: ", accountId, " already login")
        return ec.AUCTION.ALREADY_LOGIN
    end

    return ec.OK, accountId
end

-- note: logined will refresh the expire time of session
function account.logined(accountId)
    if type(accountId) ~= "string" then
        log.warn("invalid params")
        return ec.AUCTION.PARAMS_INVALID
    end

    local key = concat({ "auction", "account", accountId }, ":")
    local resp, err = scheduler(scheduler.REDIS, config
        , { "set", key, 1, "ex", accountIdExpireTime, "xx" })
    if not resp then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    if resp == "OK" then
        return ec.OK
    else
        return ec.AUCTION.NOT_YET_LOGIN
    end
end

function account.logout(token)
    if type(token) ~= "string" then
        log.warn("invalid params")
        return ec.AUCTION.PARAMS_INVALID
    end

    local key = concat({ "auction", "account", token }, ":")
    local resp, err = scheduler(scheduler.REDIS, config , { "set", key, 1, "px", 1, "xx" })
    if not resp then
        log.warn("redis err: ", err)
        return ec.REDIS_ERR
    end

    if resp ~= "OK" then
        log.add(log.WARN, "accountId: ", token, " not login yet")
        return ec.AUCTION.NOT_YET_LOGIN
    end

    return ec.OK
end

return account