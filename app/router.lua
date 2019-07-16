-- function reference
-- include
local appInfoMW = require("middleware.applicationInfo")
--local validateLoginMW = require("middleware.validateLogin")
local testRouter = require("handler.test.index")
local auctionRouter = require("handler.auction.index")
local sessionRouter = require("handler.session.index")

-- you must keep add middleware and errhandler before add handler when use static route !!!

local function addMiddleware(app)
    app:use(appInfoMW())
    --app:use(validateLoginMW())
end

local function addHandlers(app)
    testRouter(app)
    auctionRouter(app)
    sessionRouter(app)
end

return function(app)
    addMiddleware(app)
    addHandlers(app)
end