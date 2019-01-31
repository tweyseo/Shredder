-- function reference
-- include

return function(version)
    return function(_, res, next)
        res:set_header('X-Powered-By', version.poweredBy)
        res.locals.app_name = version.name
        res.locals.app_version = version.id
        next()
    end
end
