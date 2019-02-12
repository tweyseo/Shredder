# **APIServer**

## **Overview**

It's a demo of [**APIServer**](http://nginx.com/blog/building-microservices-using-an-api-gateway/) based on [OpenResty](https://github.com/openresty/openresty) and [lor](https://github.com/sumory/lor).

This demo dedicated to demonstrating usages of [**common components**](https://github.com/tweyseo/Mirana) in APIServer which based on OpenResty.

The APIServer follow the specifications of process below:
1. **middleware** handle every request first,
2. next the **handler** you specify in **router** (actually in every *index.lua* of specific handler) process the corresponding request,
3. then the **module** and the **dao** will handle the actual logic and data,
4. then back to the **handler** which will do response,
5. do log at *logStage.lua*.

note that, *server.lua* and *init.lua* were invoked **only when** the first request arrived.

## **Useage**

You are recommended to use **start.sh**, **reload.sh** and **stop.sh** to start, reload and stop your APIServer, of course, you should specify your path of [**OpenResty**](https://github.com/openresty/openresty) in the scripts above and **restys** ([**lor**](https://github.com/sumory/lor), [**http**](https://github.com/ledgetech/lua-resty-http), [**rediscluster**](https://github.com/steve0511/resty-redis-cluster), [**LFS**](https://github.com/keplerproject/luafilesystem), [**lua-resty-json**](https://github.com/cloudflare/lua-resty-json))that was depended.

## **TODO**

1. the spec and example of the **dao** layer under the model layer.

## **License**

[MIT](https://github.com/tweyseo/Shredder/blob/master/LICENSE)