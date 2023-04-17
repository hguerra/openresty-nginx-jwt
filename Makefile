build_docker:
	docker build -t heitorcarneiro/openresty-nginx-jwt:1.21.4.1-6-alpine-fat .

up:
	docker run --rm -it -e JWT_SECRET=secret -v "./nginx.conf:/nginx.conf" -v "./bearer.lua:/bearer.lua" -p "8080:8080" heitorcarneiro/openresty-nginx-jwt:1.21.4.1-6-alpine-fat

push:
	docker push heitorcarneiro/openresty-nginx-jwt:1.21.4.1-6-alpine-fat

test_unprotected:
	curl -i -X GET http://localhost:8080

test_unauthorized:
	curl -i -X GET http://localhost:8080/secure

test_protected:
	curl -i -X GET http://localhost:8080/secure -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE2ODE3NDgyNDcsImV4cCI6MTY4MTc0OTU0MCwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSIsIkdpdmVuTmFtZSI6IkpvaG5ueSIsIlN1cm5hbWUiOiJSb2NrZXQiLCJFbWFpbCI6Impyb2NrZXRAZXhhbXBsZS5jb20iLCJSb2xlIjpbIk1hbmFnZXIiLCJQcm9qZWN0IEFkbWluaXN0cmF0b3IiXX0.sANXEC-piai4IE5c0RpoxMBQX2rK5vC2M9VPsQgMztk'
