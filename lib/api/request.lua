-- Copyright (C) AlexWoo(Wu Jie) wj19840501@gmail.com


-- This module based on lua-resty-http:
--  https://github.com/pintsized/lua-resty-http.git


local Request = {}
Request.__index = Request


local Http = require("resty.http")


function Request.new()
    local instance = {}

    instance.req = Http.new()

    setmetatable(instance, Request)
    return instance
end

-- options
--      method
--      headers
--      body
--      timeout
function Request.request_url(self, url, options)
    timeout = options.timeout or 3000 -- set req timeout to 3s
    self.req:set_timeout(timeout)

    headers = { ["User-Agent"] = "apiserver" }
    if options.headers and type(options.headers) == "table" then
        for k, v in pairs(options.headers) do
            headers[k] = v
        end
    end

    local res, err = self.req:request_uri(url, {
        method = options.method or "GET",
        headers = headers,
        body = options.body
    })

    return res, err
end

-- options
--      headers
--      timeout
function Request.get(self, url, options)
    return self:request_url(url, {
        method = "GET",
        headers = options.headers,
        timeout = options.timeout
    })
end

-- options
--      headers
--      body
--      timeout
function Request.post(self, url, options)
    return self:request_url(url, {
        method = "POST",
        headers = options.headers,
        body = options.body,
        timeout = options.timeout
    })
end

return Request
