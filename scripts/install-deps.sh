#!/usr/bin/env bash

set -e

declare -A DEPENDENCY_DATA=(
	[author]='kdudedev'
	[pkgname]='infinite-math'
	[version]='1.3.2'
)

INFINITE_MATH_ENTRYPOINT_PATH="Packages/_Index/${DEPENDENCY_DATA[author]}_${DEPENDENCY_DATA[pkgname]}@${DEPENDENCY_DATA[version]}/${DEPENDENCY_DATA[pkgname]}/src/InfiniteMath/init.lua"

echo "[#] Constructed entrypoint file path for ${DEPENDENCY_DATA[pkgname]} -> $INFINITE_MATH_ENTRYPOINT_PATH"

INFINTE_MATH_SRC_DIR="$(dirname $INFINITE_MATH_ENTRYPOINT_PATH)"

function patch_infinite_math_for_lune() {
	[[ -f "$INFINITE_MATH_ENTRYPOINT_PATH" ]] ||
		echo "[!] Could not find ${DEPENDENCY_DATA[pkgname]} entrypoint file"
  
	INFINITE_MATH_VALUES_DIR="$INFINTE_MATH_SRC_DIR/Values"

	mv $INFINITE_MATH_VALUES_DIR/* "$INFINTE_MATH_SRC_DIR/"
    	rm -rf "$INFINITE_MATH_VALUES_DIR"

	sed -i -e 's/local values = script.Values//g' $INFINITE_MATH_ENTRYPOINT_PATH
	sed -i -e 's/values.Suffixes/".\/Suffixes.lua"/g' $INFINITE_MATH_ENTRYPOINT_PATH
	sed -i -e 's/values.FullNames/".\/FullNames.lua"/g' $INFINITE_MATH_ENTRYPOINT_PATH
}

aftman install | sed 's/^/[aftman]: /' &&
    wally install &&
	patch_infinite_math_for_lune &&
	darklua process $INFINITE_MATH_ENTRYPOINT_PATH "$INFINITE_MATH_SRC_DIR/infinite_math.lua" | sed 's/^/[darklua]: /'
