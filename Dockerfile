FROM debian:12 AS builder

WORKDIR /opt

ENV GOROOT=/opt/go

RUN apt-get update && apt-get --no-install-recommends install -y wget make ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget --max-redirect=1 --progress=dot:giga https://go.dev/dl/go1.22.5.linux-amd64.tar.gz && \
    tar -xzf go1.22.5.linux-amd64.tar.gz && \
    ln -sv /opt/go/bin/go /usr/local/bin/go && \
    ln -sv /opt/go/bin/gofmt /usr/local/bin/gofmt


WORKDIR /opt/golang-application

RUN mkdir -p bin

COPY cmd/ /opt/golang-application/cmd
#COPY internal/ /opt/golang-application/internal
COPY Makefile /opt/golang-application/
COPY go.mod /opt/golang-application/
#COPY go.sum /opt/golang-application/
#COPY docs/ /opt/golang-application/docs

RUN make build

FROM gcr.io/distroless/base-debian12:nonroot AS runner

ENV TZ=America/Recife
ENV GIN_MODE=release

USER nonroot

WORKDIR /opt/golang-application

EXPOSE 8000

COPY --from=builder --chmod=555 /opt/golang-application/bin/golang-application /opt/golang-application/golang-application

CMD [ "/opt/golang-application/golang-application" ]