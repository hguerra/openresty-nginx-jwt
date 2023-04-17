FROM openresty/openresty:1.21.4.1-6-alpine-fat

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-jwt

COPY ./bearer.lua /bearer.lua

ENTRYPOINT ["/usr/local/openresty/bin/openresty", "-g", "daemon off;", "-c", "/nginx.conf"]
