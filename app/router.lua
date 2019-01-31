-- function reference
-- include
local testRouter = require("handler.test.index")
local auctionRouter = require("handler.auction.index")

return function(app)
    testRouter(app)
    auctionRouter(app)
end