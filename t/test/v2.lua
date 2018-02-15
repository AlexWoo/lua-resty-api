-- Copyright (C) AlexWoo(Wu Jie) wj19840501@gmail.com


local API = {}
API.__index = API


function API.get(paras)
    return 0, nil, { url = paras, method = "GET" }
end

function API.post(paras)
    return 1, nil, { url = paras, method = "POST" }
end

return API
