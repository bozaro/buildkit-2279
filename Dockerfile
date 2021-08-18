ARG BASE=alpine:edge

FROM $BASE AS base
# RUN command always produce layer with digest `sha256:bcca0bb7...`
RUN echo "Hello, world!!!"; if [ "$(arch)" = "x86_64" ]; then sleep 1; fi; touch -d 2021-01-01 -t 00:00:00 /foo.txt
# COPY command produce differ layer per platform because /opt has differ change time
COPY .build/changed.txt /opt/changed.txt

FROM $BASE
COPY --from=base /opt/changed.txt /opt/copy.txt
