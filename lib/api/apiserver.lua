-- Copyright (C) AlexWoo(Wu Jie) wj19840501@gmail.com


local Response = require("api.response")
Json = require("cjson")


APIServer = {}
APIServer.__index = APIServer


local function try_require(name, level)
    local ok, module = pcall(function() return require(name) end)

    if not ok then
        ngx.log(level, "Require Module(" .. name .. ") failed: \n", module)
    end

    return ok, module
end

local function parse_uri(uri)
    local m = ngx.re.match(uri, [[/(\w+)/(v\d+)/(.+)]])

    if m then
        return true, m[1], m[2], m[3]
    else
        return false
    end
end

local function call_api(apiname, version, method, paras)
    local api_module = apiname .. '.' .. version

    -- get api
    local ok, api = try_require(api_module, ngx.ERR)
    if not ok then
        -- API not defined
        return 2
    end

    -- get api error table
    local err_module = apiname .. '.errors'
    local ok, errors = try_require(err_module, ngx.INFO)
    if not ok then
        -- errors not defined
        errors = {}
    end

    -- call API
    local ok, code, headers, body = pcall(
        function() return api[method](paras) end
    )
    if not ok then
        ngx.log(ngx.ERR, "Call API(" .. api_module .. ") failed: \n", code)
        code = 3
    end

    return code, headers, body, errors
end

local function send_resp(resp)
    -- resp status
    ngx.status = resp.status

    -- resp headers
    for k, v in pairs(resp.headers) do
        ngx.header[k] = v
    end

    -- resp body
    local body = Json.encode(resp.body)

    ngx.say(body)
end

function APIServer.start()
    local ok, apiname, version, paras = parse_uri(ngx.var.uri)

    if not ok then
        -- uri error
        send_resp(Response.new(1))
        return
    end

    local method = string.lower(ngx.var.request_method)

    send_resp(Response.new(call_api(apiname, version, method, paras)))
end

return APIServer
