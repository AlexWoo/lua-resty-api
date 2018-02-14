-- Copyright (C) AlexWoo(Wu Jie) wj19840501@gmail.com


local Response = {}
Response.__index = Response


Response.syscode = {
    [0] = { status = 200, msg = "ok" },
    [1] = { status = 404, msg = "Invalid uri format" },
    [2] = { status = 404, msg = "Unsuppoted API" },
    [3] = { status = 500, msg = "API Error" },
    [4] = { status = 500, msg = "Unsuppoted err code " }
}

function Response.new(code, headers, body, usercode)
    local instance = {}

    -- merge usercode with syscode, if conflict, use usercode
    local errors = usercode or {}
    for k, v in pairs(Response.syscode) do
        if not errors[k] then
            errors[k] = v
        end
    end

    code = code or 0
    local err = errors[code] or errors[4]

    -- response status
    instance.status = err.status or 200

    -- response header
    instance.headers = {}
    if headers and type(headers) == "table" then
        for k, v in pairs(headers) do
            instance.headers[k] = v
        end
    end

    -- response body
    instance.body = {
        code = code,
        msg = err.msg
    }
    if body then
        if type(body) == "table" then
            for k, v in pairs(body) do
                instance.body[k] = v
            end
        else
            instance.body.msg = tostring(body)
        end
    end

    setmetatable(instance, Response)
    return instance
end


return Response
