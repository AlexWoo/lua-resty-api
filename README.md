# lua-resty-api
---

lua-resty-api is a lightweight restful api framework for api development

## install

Before install this project, user should install openresty first. Use [myopenresty](https://github.com/AlexWoo/myopenresty) install is recommended as below:

	git clone https://github.com/AlexWoo/myopenresty.git
	cd myopenresty
	./install apiserver

After apiserver install, user can install lua-resty-api

	git clone https://github.com/AlexWoo/lua-resty-api.git
	cd lua-resty-api
	./install /usr/local/apiserver

If for test, the last step use

	./install /usr/local/apiserver test

User can modify /usr/local/apiserver/lualib/test/v1.lua and /usr/local/apiserver/lualib/test/errors.lua for testing

	curl -v 'http://127.0.0.1:6200/test/v1/xxx'

## API development

Restful API uri should be defined as below:

	/apiname/vN/paras

- apiname: api name
- N: api version
- paras: api called paras, could be multilevel like aaa/bbb

Method could be all HTTP Method, but we suggest use as below:

- GET: get resource from apiserver
- POST: create resource on apiserver
- PUT: update resource on apiserver
- DELETE: delete resource from apiserver

Suppose api\_path is in lua\_package\_path. User should implent api\_path/apiname/vN.lua, and implent api\_path/apiname/errors.lua if have user defined code

In vN.lua, User should implent function named with lower case of HTTP method. For examples, if Use GET, you should implent named get.

This function has a args, value is paras in uri. This function return code, response headers, response body, We support return values as below:

    - return
    - return 100
    - return 100, { Hello = "World" }
    - return 100, { Hello = "World" }, { a = 100, b = 'Hello World' }
    - return 100, { Hello = "World" }, { msg = 'test ok', a = 100, b = 'Hello World' }
    - return 0, nil, "Hello World"

Errors table has two para:

	- status: HTTP response status will return
	- msg: msg will return in json

Load into nginx, you should configured as below:

	location / {
		content_by_lua  'require(\'api/apiserver\').start()';
	}

## Example

- Load into nginx

		location / {
			content_by_lua  'require(\'api/apiserver\').start()';
		}

- API Implentment

	test/v1.lua
	
		local API = {}
		API.__index = API
		
		
		function API.get(paras)
		    return 0, { Hello = "World" }, { a = 100, b = 'Hello World' }
		end
		
		return API

- Errors Implentment

	test/errors.lua

		local Errors = {
		    [0] = { status = 200, msg = "successd" },
		    [101] = { status = 200, msg = "failed" },
		}
		
		return Errors

We put test directory under api\_path included in lua\_package\_path, then you can call api as below:

	curl -v 'http://127.0.0.1:6200/test/v1/def