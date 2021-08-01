FROM ocaml/opam:alpine AS build

WORKDIR /home/app
ADD . /home/app/

USER root
RUN apk update && apk upgrade && \
  apk add libev-dev

USER opam
RUN set -x && \
  opam install . --deps-only --locked && \
  eval $(opam env) && \
  sudo chown -R opam:opam /home/app && \
  dune build

FROM alpine

WORKDIR /home/app
COPY --from=build /home/app/_build/default/strats.exe /home/app

USER root
RUN apk update && apk upgrade && \
  apk add libev-dev

RUN addgroup -S app && adduser -S app -G app
USER app
EXPOSE 3000
ENTRYPOINT ["/home/app/strats.exe"]
