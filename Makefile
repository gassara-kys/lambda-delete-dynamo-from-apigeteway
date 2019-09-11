.PHONY: all
all: run

PROJECT := 'delete-dynamo-from-apigeteway'
SRC := $(shell ls *.go | grep -v '_test.go')

.PHONY: fmt
fmt:
	go fmt

.PHONY: test
test: fmt
	go test -v -cover .

.PHONY: install
install:
	go install github.com/okzk/go-lambda-runner

.PHONY: run
run: fmt test install
	go-lambda-runner go run $(SRC)

.PHONY: build
build: fmt test
	$(shell GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -o zip/$(PROJECT) -v $(SRC) )

.PHONY: zip
zip: fmt test build
	cd zip && zip $(PROJECT).zip $(PROJECT)
