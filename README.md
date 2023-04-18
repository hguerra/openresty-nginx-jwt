openresty-nginx-jwt
===
[![](https://images.microbadger.com/badges/image/ubergarm/openresty-nginx-jwt.svg)](https://microbadger.com/images/ubergarm/openresty-nginx-jwt) [![](https://images.microbadger.com/badges/version/ubergarm/openresty-nginx-jwt.svg)](https://microbadger.com/images/ubergarm/openresty-nginx-jwt) [![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/hguerra/openresty-nginx-jwt/blob/master/LICENSE)

JWT Bearer Token authorization with `nginx`, `openresty`, and `lua-resty-jwt`.

An easy way to setup JWT Bearer Token authorization for any API endpoint, reverse proxy service, or location block without having to touch your server-side code.

## Run
This example uses the secret, token, and claims from [jwt.io](https://jwt.io/):

Server:
```bash
docker run --rm \
           -it \
           -e JWT_SECRET=secret \
           -e JWT_ISS=domain.com \
           -v `pwd`/nginx.conf:/nginx.conf \
           -v `pwd`/bearer.lua:/bearer.lua \
           -p 8080:8080 \
           heitorcarneiro/openresty-nginx-jwt:1.21.4.1-6-alpine-fat
```

Generate JWT for testing:

http://jwtbuilder.jamiekurtz.com/

Example:
```json
{
    "iss": "domain.com",
    "iat": 1681770906,
    "exp": 1681777666,
    "aud": "www.example.com",
    "sub": "heitor@example.com",
    "name": "heitor",
    "email": "heitor@example.com",
    "r": [
        "viewer",
        "accessapproval.approver"
    ]
}
```


Client:
```bash
curl -i -X GET http://localhost:8080/request -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkb21haW4uY29tIiwiaWF0IjoxNjgxNzcwOTA2LCJleHAiOjE2ODE3Nzc2NjYsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImhlaXRvckBleGFtcGxlLmNvbSIsIm5hbWUiOiJoZWl0b3IiLCJlbWFpbCI6ImhlaXRvckBleGFtcGxlLmNvbSIsInIiOlsidmlld2VyIiwiYWNjZXNzYXBwcm92YWwuYXBwcm92ZXIiXX0.r73ZjmC1fBsVDfRve1A9-84E4LhqhOIiL5fszzpD10c'

curl -i -X GET http://localhost:8080/request?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkb21haW4uY29tIiwiaWF0IjoxNjgxNzcwOTA2LCJleHAiOjE2ODE3Nzc2NjYsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImhlaXRvckBleGFtcGxlLmNvbSIsIm5hbWUiOiJoZWl0b3IiLCJlbWFpbCI6ImhlaXRvckBleGFtcGxlLmNvbSIsInIiOlsidmlld2VyIiwiYWNjZXNzYXBwcm92YWwuYXBwcm92ZXIiXX0.r73ZjmC1fBsVDfRve1A9-84E4LhqhOIiL5fszzpD10c
```


## Configure
Edit `nginx.conf` to setup your custom location blocks.

Edit `bearer.lua` or create new `lua` scripts to meet your specific needs for each location block.

Restart a container and volume mount in all of the required configuration.

## Build
To update or build a custom image edit the `Dockerfile` and:
```bash
docker build -t ubergarm/openresty-nginx-jwt .
```

## Note
I originally tried to get [auth0/nginx-jwt](https://github.com/auth0/nginx-jwt) working, but even the newer forks are not as straight forward as simply using `lua-resty-jwt` rock directly.

If you're looking for something beyond just JWT auth, check out [kong](https://getkong.org/) for all your API middleware plugin needs!

Also [Caddy](https://caddyserver.com/) might be faster for a simple project.

## References
* https://github.com/ubergarm/openresty-nginx-jwt
* https://github.com/openresty/docker-openresty
* https://github.com/SkyLothar/lua-resty-jwt
* https://github.com/svyatogor/resty-lua-jwt
* https://getkong.org/
* https://jwt.io/
