return {
    redis = {
        addr = "127.0.0.1",
        port = 6380,
        timeout = 3000, -- ms
        auth = "",
        maxIdleTimeout = 2 * 60 * 1000, -- ms
        poolSize = 200
    },
    rediscluster = {
        name = "SSORedisCluster",
        serv_list = {
            { ip = "127.0.0.1", port = 6381 },
            { ip = "127.0.0.1", port = 6382 },
            { ip = "127.0.0.1", port = 6383 },
            { ip = "127.0.0.1", port = 6384 },
            { ip = "127.0.0.1", port = 6385 },
            { ip = "127.0.0.1", port = 6386 }
        },
        keepalive_timeout = 60000,  -- ms
        keepalive_cons = 1000,
        connection_timout = 3000,   --ms
        max_redirection = 2,
        auth = "12345690"
    }
}