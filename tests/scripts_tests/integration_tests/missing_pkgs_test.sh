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

# workspace_dir="$(dirname "${workspace_path}")"
workspace_dir="$(normalize_path "$(dirname "${workspace_path}")")"
cd "${workspace_dir}"

# MARK - Create Scratch Directory

# Create the scratch directory
scratch_dir="$(normalize_path "${workspace_dir}/../scratch")"
echo "scratch_dir: ${scratch_dir}" 
rm -rf "${scratch_dir}"
mkdir -p "${scratch_dir}"

# Copy the non-hidden files
cp -R -L * "${scratch_dir}"

# Copy the hidden files
find . -type f -name ".*" -print0 | xargs -0 -I '{}' cp '{}' "${scratch_dir}"

cd "${scratch_dir}"

# MARK - Find the missing packages

missing_pkgs=( $("${bazel}" run "//:bzlformat_pkgs_find_missing") )

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
assert_msg="Missing packages, with exclusions"
expected_array=(// //foo/bar)
assert_equal ${#expected_array[@]} ${#missing_pkgs[@]} "${assert_msg}"
for (( i = 0; i < ${#expected_array[@]}; i++ )); do
  assert_equal "${expected_array[${i}]}" "${missing_pkgs[${i}]}" "${assert_msg}[${i}]"
done

# MARK - Update the missing packages with exclusions

update_pkgs=( $("${bazel}" run "//:bzlformat_pkgs_update_missing") )
assert_msg="Update missing packages, with exclusions"
# Note: The expected array purposefully does not quote the message as the update_pkgs array 
# will parse each space-separated item.
expected_array=(Updating the following packages: // //foo/bar)
assert_equal ${#expected_array[@]} ${#update_pkgs[@]} "${assert_msg}"
for (( i = 0; i < ${#expected_array[@]}; i++ )); do
  assert_equal "${expected_array[${i}]}" "${update_pkgs[${i}]}" "${assert_msg}[${i}]"
done


