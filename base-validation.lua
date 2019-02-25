local cjson = require "cjson"
local jwt = require "resty.jwt"
local redirect = "false"
local status = "INVALID_TOKEN"
local memcached = require "resty.memcached"
-- memcache 

local token = ngx.req.get_headers()["TOKEN"]


if token == nil then
	redirect = "true"
	status = "INVALID_TOKEN"
else

    local secret = os.getenv("NGINX_HOST_ENV")
    local tokenId = "auth"
    local memc, err = memcached:new()
    local ok, err = memc:connect("memcache", 11211)


    local ok,err =  memc:set(tokenId,"hello")
   
    local res = memc:get(tokenId)

    ngx.log(ngx.ERR, secret)

    local ok, err = memc:close();
 
end


if redirect == "true" then
	-- Build json response at Nginx using Lua
	ngx.status = ngx.HTTP_UNAUTHORIZED
	ngx.header.content_type = "application/json; charset=utf-8"
	ngx.say(cjson.encode({ status = status }))
	return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
