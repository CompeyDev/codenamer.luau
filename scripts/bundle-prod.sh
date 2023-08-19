#!/usr/bin/bash

([[ $WALLY_BUILD ]] && darklua process src/init.luau dist/codenamer.luau | sed 's/^/[darklua]: /') || echo "[!] Depth build not supported yet!"
