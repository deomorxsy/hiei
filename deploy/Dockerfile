# bookworm
FROM golang:1.22 as builder

ARG PLATFORM
ARG PROTOC_VERSION

WORKDIR /app
# copy the go modules manifests
#COPY ["go.mod", "go.sum", "."]
COPY ../go.mod .
COPY ../go.sum .

RUN apt-get update && apt-get install -y unzip
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31.0
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0


RUN export ZIP=x86_64 && \
    if [ ${PLATFORM} = "arm64" ]; then export ZIP=aarch_64; fi && \
    wget --quiet https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-${ZIP}.zip && \
    unzip -o protoc-${PROTOC_VERSION}-linux-${ZIP}.zip -d /usr/local bin/protoc && \
    unzip -o protoc-${PROTOC_VERSION}-linux-${ZIP}.zip -d /usr/local 'include/*'
# cache deps before building and copying source

RUN go mod download
COPY . .
RUN go get && \
    go mod tidy && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -ldflags '-extldflags "-static"' \
    -o hid .

EXPOSE 2112
EXPOSE 8080

#ENTRYPOINT [/app/hid]
CMD [/app/hid]

# copy action into a thin image
#FROM gcr.io/distroless/static:latest as relay
FROM alpine:3.18 as relay
WORKDIR /
#COPY --from=builder /workspace/hid .
COPY --from=builder /app/hid .

EXPOSE 2112
EXPOSE 8080

ENTRYPOINT ["/bin/sh"]
CMD ["./hid"]
