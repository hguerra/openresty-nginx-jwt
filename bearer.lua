local jwt = require "resty.jwt"

-- a helper function to response HTTP 401
local function unauthorized(response_body)
  ngx.status = ngx.HTTP_UNAUTHORIZED
  ngx.header.content_type = "application/json; charset=utf-8"
  ngx.say(response_body)
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- first try to find JWT token as url parameter e.g. ?token=BLAH
local token = ngx.var.arg_token

-- next try to find JWT token as Cookie e.g. token=BLAH
if token == nil then
    token = ngx.var.cookie_token
end

-- try to find JWT token in Authorization header Bearer string
if token == nil then
    local auth_header = ngx.var.http_Authorization
    if auth_header then
        local _, _, token_header = string.find(auth_header, "Bearer%s+(.+)")
        token = token_header
    end
end

-- finally, if still no JWT token, kick out an error and exit
if token == nil then
    return unauthorized("{\"error\": \"missing JWT token or Authorization header\"}")
end

-- make sure to set and put "env JWT_SECRET;" in nginx.conf
-- make sure to set and put "env JWT_ISS;" in nginx.conf
local jwt_secret = os.getenv("JWT_SECRET")
local jwt_iss = os.getenv("JWT_ISS")
if not jwt_secret or not jwt_iss then
  return unauthorized("{\"error\": \"missing enviroment variables\"}")
end

-- validate any specific claims you need here
-- https://github.com/SkyLothar/lua-resty-jwt#jwt-validators
local validators = require "resty.jwt-validators"
local claim_spec = {
    validators.set_system_leeway(15), -- time in seconds
    exp = validators.is_not_expired(),
    iat = validators.is_not_before(),
    iss = validators.equals(jwt_iss),
    sub = validators.required(),
    r = validators.required() -- roles, ex: viewer,editor,owner,admin
}

local jwt_obj = jwt:verify(jwt_secret, token, claim_spec)
if not jwt_obj["verified"] then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.log(ngx.WARN, jwt_obj.reason)
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say("{\"error\": \"" .. jwt_obj.reason .. "\"}")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- optionally set Authorization header Bearer token style regardless of how token received
-- if you want to forward it by setting your nginx.conf something like:
--     proxy_set_header Authorization $http_authorization;`
ngx.req.set_header("Authorization", "Bearer " .. token)
