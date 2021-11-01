#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

backup_filename() {
  local filename="${1}"
  echo "${filename}.bak"
}

backup_file() {
  local filename="${1}"
  local backup_filename="$(backup_filename "${filename}")"
  cp -f "${filename}" "${backup_filename}"
}

revert_file() {
  local filename="${1}"
  local backup_filename="$(backup_filename "${filename}")"
  [[ -f "backup_filename" ]] && cp -f "${backup_filename}" "${filename}"
}

remove_backup_file() {
  local filename="${1}"
  local backup_filename="$(backup_filename "${filename}")"
  rm -f "${backup_filename}"
}

workspace_dir="${script_dir}"
foo_path="${workspace_dir}/mockascript/internal/foo.bzl"
internal_build_path="${workspace_dir}/mockascript/internal/BUILD.bazel"

cleanup_files=("${internal_build_path}")

# Clean up on exit.
cleanup() {
  # DEBUG BEGIN
  set -x
  # DEBUG END
  for file in "${cleanup_files[@]}" ; do
    revert_file "${file}"
    remove_backup_file "${file}"
  done
}
trap cleanup EXIT

# Change to workspace directory
cd "${workspace_dir}"

# Add poorly formatted code to build file.
backup_file "${internal_build_path}"
echo "load(':foo.bzl', 'foo')" >> "${internal_build_path}"

# Execute the update for the repository
bazel run //:update_all

# Make sure that all is well
bazel test //...


