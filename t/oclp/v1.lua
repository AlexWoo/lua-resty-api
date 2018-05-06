-- Copyright (C) AlexWoo(Wu Jie) wj19840501@gmail.com


local API = {}
API.__index = API


local Request = require("api.request")


local function on_init()
    return 0
end

local function on_play()
    return 0
end

local function on_publish()
    return 0
end

local function on_stream()
    return 0
end

local function on_pull()
    location = "http://127.0.0.1/live/test"
    domain = "www.test.com"
    return 100, { Location = location, Domain = domain }
end

local function on_push()
    location = "rtmp://127.0.0.1/live/test"
    domain = "www.test.com"
    return 100, { Location = location, Domain = domain }
end

local selector = {
    init    = on_init,
    play    = on_play,
    publish = on_publish,
    stream  = on_stream,
    pull    = on_pull,
    push    = on_push,
}

function API.get(paras)
    handler = selector[paras]
    if not handler then
        return 101
    end

    return handler()
end

return API
