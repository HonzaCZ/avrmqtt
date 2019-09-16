FROM golang:buster AS builder

COPY . /go/src/github.com/JohannWeging/avrmqtt
WORKDIR /go/src/github.com/JohannWeging/avrmqtt

RUN set -x \
 && go install github.com/JohannWeging/avrmqtt

FROM debian

RUN apt-get update && apt-get install -y \
	dumb-init \
	gosu

COPY --from=builder /go/bin/avrmqtt /usr/bin

RUN set -x \
 && useradd avrmqtt
 
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["gosu", "avrmqtt", "avrmqtt"]

