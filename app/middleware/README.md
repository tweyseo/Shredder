# **middleware**

## **Overview**

It handle every request first in **middleware**, so it recommended to do some public work here like add appInfo, filter whitePath and so on.

This module was refer to [**openresty-china**](https://github.com/sumory/openresty-china/tree/master/app/middleware) that was a very useful reference for web server based on [**lor**](https://github.com/sumory/lor).

## **Useage**

```
local middleware = function(params)
    return function(req, resp, next)
        -- do something with req/resp
        next()
    end
end

return middleware
```

## **TODO**