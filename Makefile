APP=kbot
REGISTRY=ghcr.io/grimhat
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

format:
	gofmt -s -w ./


lint:
	go install golang.org/x/lint/golint
	golint

test:
	go test -v
get:
	go get

linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/RuslanRiabokin/kbot_kbot/cmd.appVersion=${VERSION}

build: linux

windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o kbot.exe -ldflags "-X="github.com/RuslanRiabokin/kbot_kbot/cmd.appVersion=${VERSION}

macos: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/RuslanRiabokin/kbot_kbot/cmd.appVersion=${VERSION}

arm: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -v -o kbot -ldflags "-X="github.com/RuslanRiabokin/kbot_kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
clean:
	rm -rf kbot kbot.exe
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	
	