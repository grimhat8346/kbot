VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)


format:
	gofmt -s -w ./
build:
	go build -v -o kbot -ldflags "-X="github.com/grimhat8346/kbot/cmd.appVersion=${VERSION}