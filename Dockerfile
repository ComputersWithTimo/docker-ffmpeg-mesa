FROM alpine:latest

MAINTAINER Timo Brunn <timo@timo-brunn.de>

RUN apk add ffmpeg mesa-va-gallium

ENTRYPOINT ["ffmpeg"]
