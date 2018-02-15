-- Copyright (C) AlexWoo(Wu Jie) wj19840501@gmail.com


local API = {}
API.__index = API


local Request = require("api.request")


function API.get(paras)
    local get = Request.new()
    local res, err = get:get("http://127.0.0.1:6200/test/v2/test", {
        headers = {
            Hello = "World",
        },
        timeout = 1000
    })

    if res then
        ngx.log(ngx.INFO, "Get status " .. res.status .. " Body " .. res.body)
    else
        ngx.log(ngx.ERR, "Get failed ", err)
    end

    local post = Request.new()
    res, err = post:post("http://127.0.0.1:6200/test/v2/test", {
        headers = {
            Hello = "World1",
        },
        timeout = 1000
    })
    if res then
        ngx.log(ngx.INFO, "POST status " .. res.status .. " Body " .. res.body)
    else
        ngx.log(ngx.ERR, "Get failed ", err)
    end

    return
    -- return 0
    -- return 0, { Hello = "World" }
    -- return 0, { Hello = "World" }, { a = 100, b = 'Hello World' }
    -- return 0, { Hello = "World" }, { msg = 'test ok', a = 100, b = 'Hello World' }
    -- return 100
    -- return 100, { Hello = "World" }
    -- return 100, { Hello = "World" }, { a = 100, b = 'Hello World' }
    -- return 100, { Hello = "World" }, { msg = 'test ok', a = 100, b = 'Hello World' }
    -- return 101
    -- return 101, { Hello = "World" }
    -- return 101, { Hello = "World" }, { a = 100, b = 'Hello World' }
    -- return 101, { Hello = "World" }, { msg = 'test ok', a = 100, b = 'Hello World' }
end

return API
