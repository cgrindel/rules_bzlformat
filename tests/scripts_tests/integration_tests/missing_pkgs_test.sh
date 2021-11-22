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

# DEBUG BEGIN
set -x
# DEBUG END

# assertions_lib="$(rlocation cgrindel_bazel_shlib/lib/assertions.sh)"
assertions_lib="$(rlocation cgrindel_bazel_shlib/lib/assertions.sh)" || (echo >&2 "Failed to locate cgrindel_bazel_shlib/lib/assertions.sh" && exit 1)
source "${assertions_lib}"
# [[ -f "${assertions_lib}" ]] && source "${assertions_lib}"
# source "${assertions_lib}" || (echo >&2 "Failed to source ${assertions_lib}" && exit 1)

paths_lib="$(rlocation cgrindel_bazel_shlib/lib/paths.sh)"
source "${paths_lib}"

messages_lib="$(rlocation cgrindel_bazel_shlib/lib/messages.sh)"
source "${messages_lib}"

# Process args
while (("$#")); do
  case "${1}" in
    "--bazel")
      bazel_rel_path="${2}"
      shift 2
      ;;
    "--workspace")
      workspace_path="${2}"
      shift 2
      ;;
    "--bazel_cmd")
      bazel_cmds+=("${2}")
      shift 2
      ;;
    *)
      shift 1
      ;;
  esac
done

[[ -n "${bazel_rel_path:-}" ]] || exit_with_msg "Must specify the location of the Bazel binary."
[[ -n "${workspace_path:-}" ]] || exit_with_msg "Must specify the location of the workspace file."

starting_path="$(pwd)"
starting_path="${starting_path%%*( )}"
bazel="$(normalize_path "${bazel_rel_path}")"

workspace_dir="$(dirname "${workspace_path}")"
cd "${workspace_dir}"




fail "IMPLEMENT ME!"
