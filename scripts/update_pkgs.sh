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

find_missing_pkgs_bin="$(rlocation cgrindel_rules_bzlformat/scripts/find_missing_pkgs.sh)"
buildozer="$(rlocation com_github_bazelbuild_buildtools/buildozer/buildozer_/buildozer)"

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

find_args=()
for pkg in "${exclude_pkgs[@]}" ; do
  find_args+=(--exclude "${pkg}")
done
missing_pkgs=( $(. "${find_missing_pkgs_bin}" "${find_args[@]:-}") )

buildozer_cmds=()
buildozer_cmds+=( 'fix movePackageToTop' )
buildozer_cmds+=( 'new_load @cgrindel_rules_bzlformat//bzlformat:bzlformat.bzl bzlformat_pkg' )
buildozer_cmds+=( 'new bzlformat_pkg bzlformat' )
buildozer_cmds+=( 'fix unusedLoads' )

missing_pkgs_args=()
for pkg in "${missing_pkgs[@]}" ; do
  missing_pkgs_args+=( "${pkg}:__pkg__" )
done

[[ ${#missing_pkgs_args[@]} == 0 ]] && exit
"${buildozer}" "${buildozer_cmds[@]}" "${missing_pkgs_args[@]}"
