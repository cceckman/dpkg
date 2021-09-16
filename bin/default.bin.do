
ARCH="$2"
OUTPUT="$(readlink -f $3)"

gobuild() {
  ( cd .. && GOARCH="$ARCH" go build -o "$OUTPUT")
}

rustbuild() {
  TUPLE="${ARCH}-unknown-linux-gnu"
  CARGO_TARGET="$(cargo locate-project --workspace --message-format plain)"
  BINARY="${CARGO_TARGET}/${TUPLE}/$MODE/$BIN"
  (cd .. && \
    cargo build \
      --target "$TUPLE" \
      --release)
  cp "$BINARY" "$OUTPUT"
}

stubbuild() {
  cat <<EOF >"$OUTPUT"
#!/bin/sh
echo >&2 "Stub unit ran, but did nothing."
echo >&2 "Double-check your build system."
exit 1
EOF
  chmod +x "$OUTPUT"
}

echo >&2 "WARNING! This does not actually define a useful unit."
echo >&2 "Revise bin/default.bin.do to build your binary."
stubbuild # or gobuild, or rustbuild, or... whatever you actually want.

# Good build chains (like Cargo and `go`) do a pretty good job of caching and
# providing deterministic outputs.
redo-always
redo-stamp <"$OUTPUT"
