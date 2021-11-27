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

# DEBUG BEGIN
echo >&2 "*** CHUCK  starting_path: ${starting_path}" 
echo >&2 "*** CHUCK  workspace_dir: ${workspace_dir}" 
echo >&2 "*** CHUCK WORKSPACE DIR" 
tree
# DEBUG END

# MARK - Backup and Restore Workspace Files

# files_to_backup=(BUILD.bazel foo/BUILD.bazel foo/bar/BUILD.bazel)

# backup_filename() {
#   local file="${1}"
#   echo "${file}.BAK"
# }

# backup_file() {
#   local file="${1}"
#   local backup_file="$(backup_filename "${file}")"
#   # [[ -f "${backup_file}" ]] && exit_with_msg "Backup file already exists. ${backup_file}"
#   if [[ -L "${file}" ]]; then
#     # For symlinks, rename the file and then copy it back.
#     mv -f "${file}" "${backup_file}"
#     restore_file "${file}"
#   else
#     cp -f "${file}" "${backup_file}"
#   fi
# }

# backup_files() {
#   files=()
#   while (("$#")); do
#     case "${1}" in
#       *)
#         files+=("${1}")
#         shift 1
#         ;;
#     esac
#   done
#   [[ ${#files[@]} == 0 ]] && files=( "${files_to_backup[@]}" )
#   for file in "${files[@]}" ; do
#     backup_file "${file}"
#   done
# }

# restore_file() {
#   local file="${1}"
#   local backup_file="$(backup_filename "${file}")"
#   cp -f "${backup_file}" "${file}"
# }

# restore_files() {
#   # DEBUG BEGIN
#   set -x
#   # DEBUG END
#   files=()
#   while (("$#")); do
#     case "${1}" in
#       *)
#         files+=("${1}")
#         shift 1
#         ;;
#     esac
#   done
#   [[ ${#files[@]} == 0 ]] && files=( "${files_to_backup[@]}" )
#   for file in "${files[@]}" ; do
#     restore_file "${file}"
#   done
# }

# backup_files

# cleanup() {
#   # DEBUG BEGIN
#   echo >&2 "*** CHUCK CLEANUP" 
#   # DEBUG END
#   restore_files
# }
# trap cleanup EXIT

# MARK - Create Scratch Directory

# Create the scratch directory
# scratch_dir="$(mktemp -d -t missing_pkgs_test)" || exit_with_msg "Failed to create a scratch directory."
# scratch_dir="${workspace_dir}/../scratch"
scratch_dir="$(normalize_path "${workspace_dir}/../scratch")"
rm -rf "${scratch_dir}"
mkdir -p "${scratch_dir}"

# Copy the non-hidden files
cp -R -L * "${scratch_dir}"

# Copy the hidden files
find . -type f -name ".*" -print0 | xargs -0 -I '{}' cp '{}' "${scratch_dir}"

cd "${scratch_dir}"

# DEBUG BEGIN
echo >&2 "*** CHUCK CREATED SCRATCH WORKSPACE" 
tree -a "${scratch_dir}"
# DEBUG END

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
# DEBUG BEGIN
echo >&2 "*** CHUCK  update_pkgs:"
for (( i = 0; i < ${#update_pkgs[@]}; i++ )); do
  echo >&2 "*** CHUCK   ${i}: ${update_pkgs[${i}]}"
done
# DEBUG END
assert_msg="Update missing packages, with exclusions"
expected_array=("Updating the following packages:" // //foo/bar)
assert_equal ${#expected_array[@]} ${#update_pkgs[@]} "${assert_msg}"
for (( i = 0; i < ${#expected_array[@]}; i++ )); do
  assert_equal "${expected_array[${i}]}" "${update_pkgs[${i}]}" "${assert_msg}[${i}]"
done


# DEBUG BEGIN
fail "IMPLEMENT ME!"
# DEBUG END
