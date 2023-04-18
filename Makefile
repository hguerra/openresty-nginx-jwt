build_docker:
	docker build -t heitorcarneiro/openresty-nginx-jwt:1.21.4.1-6-alpine-fat .

up:
	docker run --rm -it -e JWT_SECRET=secret -e JWT_ISS=domain.com -v "./nginx.conf:/nginx.conf" -v "./bearer.lua:/bearer.lua" -p "8080:8080" heitorcarneiro/openresty-nginx-jwt:1.21.4.1-6-alpine-fat

push:
	docker push heitorcarneiro/openresty-nginx-jwt:1.21.4.1-6-alpine-fat

test_unprotected:
	curl -i -X GET http://localhost:8080

test_unauthorized:
	curl -i -X GET http://localhost:8080/secure

test_protected:
	curl -i -X GET http://localhost:8080/secure -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkb21haW4uY29tIiwiaWF0IjoxNjgxNzcwOTA2LCJleHAiOjE2ODE3Nzc2NjYsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImhlaXRvckBleGFtcGxlLmNvbSIsIm5hbWUiOiJoZWl0b3IiLCJlbWFpbCI6ImhlaXRvckBleGFtcGxlLmNvbSIsInIiOlsidmlld2VyIiwiYWNjZXNzYXBwcm92YWwuYXBwcm92ZXIiXX0.r73ZjmC1fBsVDfRve1A9-84E4LhqhOIiL5fszzpD10c'

test_protected_proxy_pass:
	curl -i -X GET http://localhost:8080/request -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkb21haW4uY29tIiwiaWF0IjoxNjgxNzcwOTA2LCJleHAiOjE2ODE3Nzc2NjYsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImhlaXRvckBleGFtcGxlLmNvbSIsIm5hbWUiOiJoZWl0b3IiLCJlbWFpbCI6ImhlaXRvckBleGFtcGxlLmNvbSIsInIiOlsidmlld2VyIiwiYWNjZXNzYXBwcm92YWwuYXBwcm92ZXIiXX0.r73ZjmC1fBsVDfRve1A9-84E4LhqhOIiL5fszzpD10c'
