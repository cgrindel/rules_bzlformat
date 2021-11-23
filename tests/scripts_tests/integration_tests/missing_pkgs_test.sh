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

assertions_sh_location=cgrindel_bazel_shlib/lib/assertions.sh
assertions_sh="$(rlocation "${assertions_sh_location}")" || \
  (echo >&2 "Failed to locate ${assertions_sh_location}" && exit 1)
source "${assertions_sh}"

paths_sh_location=cgrindel_bazel_shlib/lib/paths.sh
paths_sh="$(rlocation "${paths_sh_location}")" || \
  (echo >&2 "Failed to locate ${paths_sh_location}" && exit 1)
source "${paths_sh}"

messages_sh_location=cgrindel_bazel_shlib/lib/messages.sh
messages_sh="$(rlocation "${messages_sh_location}")" || \
  (echo >&2 "Failed to locate ${messages_sh_location}" && exit 1)
source "${messages_sh}"

buildozer_location=com_github_bazelbuild_buildtools/buildozer/buildozer_/buildozer
buildozer="$(rlocation "${buildozer_location}")" || \
  (echo >&2 "Failed to locate ${buildozer_location}" && exit 1)

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

# TODO: Backup files that are modified and restore on cleanup.

# MARK - Find the missing packages

missing_pkgs=( $("${bazel}" run "//:bzlformat_pkgs_find_missing") )

# assert_msg="Missing packages count, no exclusions."
# expected_array=(// //foo //foo/bar)
# assert_equal 3 ${#missing_pkgs[@]} "${assert_msg}"
# for (( i = 0; i < ${#expected_array[@]}; i++ )); do
#   assert_equal "${expected_array[${i}]}" "${missing_pkgs[${i}]}" "${assert_msg}[${i}]"
# done

# assert_equal "//" "${missing_pkgs[0]}" "${assert_msg}[0]"
# assert_equal "//foo" "${missing_pkgs[1]}" "${assert_msg}[1]"
# assert_equal "//foo/bar" "${missing_pkgs[2]}" "${assert_msg}[2]"

assert_msg="Missing packages, no exclusions"
expected_array=(// //foo //foo/bar)
assert_equal ${#expected_array[@]} ${#missing_pkgs[@]} "${assert_msg}"
for (( i = 0; i < ${#expected_array[@]}; i++ )); do
  assert_equal "${expected_array[${i}]}" "${missing_pkgs[${i}]}" "${assert_msg}[${i}]"
done

# MARK - Find the missing packages with exclusions

# # Add exclusions to the bzlformat_update_pkgs
"${buildozer}" 'add exclude //foo' //:bzlformat_pkgs

missing_pkgs=( $("${bazel}" run "//:bzlformat_pkgs_find_missing") )
assert_equal 2 ${#missing_pkgs[@]} "Missing packages count, with exclusions."
assert_equal "//" "${missing_pkgs[0]}" "Missing packages 0"
assert_equal "//foo/bar" "${missing_pkgs[1]}" "Missing packages 1"

# MARK - Update the missing packages with exclusions

update_pkgs=( $("${bazel}" run "//:bzlformat_pkgs_update_missing") )
assert_equal 3 ${#missing_pkgs[@]} "Updated packages count, with exclusions."
assert_equal "Updating the following packages:" "${missing_pkgs[0]}" "Missing text."
assert_equal "//" "${missing_pkgs[1]}" "Missing packages 1"
assert_equal "//foo/bar" "${missing_pkgs[2]}" "Missing packages 2"


fail "IMPLEMENT ME!"
