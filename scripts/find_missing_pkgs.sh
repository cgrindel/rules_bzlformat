#!/usr/bin/env bash

# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---

arrays_lib="$(rlocation cgrindel_bazel_shlib/lib/arrays.sh)"
source "${arrays_lib}"

exclude_pkgs=()
args=()
while (("$#")); do
  case "${1}" in
    "--exclude")
      exclude_pkgs+=( $(normalize_pkg "${2}") )
      shift 2
      ;;
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

cd "${BUILD_WORKSPACE_DIRECTORY}"

# The output `package` appears to sort the results
all_pkgs=( $(query_for_pkgs //...) )
pkgs_with_format=( $(query_for_pkgs 'kind(bzlformat_format, //...)') )

pkgs_missing_format=()
for pkg in "${all_pkgs[@]}" ; do
  contains_item "${pkg}" "${pkgs_with_format[@]}" || pkgs_missing_format+=( "${pkg}" )
done

print_by_line "${pkgs_missing_format[@]}"
