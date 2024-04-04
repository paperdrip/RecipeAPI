FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.22 as builder
LABEL authors="ronniek"

EXPOSE 8080/tcp

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG Version
ARG GitCommit

ENV CGO_ENABLED=0
ENV GO111MODULE=on

WORKDIR /go/src/github.com/paperdrip/RecipeAPI

COPY . .

RUN CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go test -v ./...

RUN CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags \
    "-s -w -X 'main.Version=${Version}' -X 'main.GitCommit=${GitCommit}'" \
    -o /usr/bin/RecipeAPI .

FROM --platform=${TARGETPLATFORM:-linux/amd64} gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /usr/bin/RecipeAPI /
USER nonroot:nonroot

CMD ["/RecipeAPI"]