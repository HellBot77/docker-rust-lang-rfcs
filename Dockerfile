FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/rust-lang/rfcs.git && \
    cd rfcs && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM rust AS build

WORKDIR /rfcs
COPY --from=base /git/rfcs .
RUN cargo install mdbook && \
    python3 generate-book.py

FROM joseluisq/static-web-server

COPY --from=build /rfcs/book ./public
