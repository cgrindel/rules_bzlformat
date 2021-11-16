#!/usr/bin/env bash

set -uo pipefail

# sort_items() {
#   local IFS=$'\n'
#   sort -u <<<"$*"
# }

# contains_item() {
#   local expected="${1}"
#   shift
#   # Do a quick regex to see if the value is in the rest of the args
#   # If not, then don't bother looping
#   [[ ! "${*}" =~ "${expected}" ]] && echo "false" && return
#   # Loop through items for a precise match
#   for item in "${@}" ; do
#     [[ "${item}" == "${expected}" ]] && echo "true" && return
#   done
#   # We did not find the item
#   echo "false"
# }

contains_item() {
  local expected="${1}"
  shift
  # Do a quick regex to see if the value is in the rest of the args
  # If not, then don't bother looping
  [[ ! "${*}" =~ "${expected}" ]] && return -1
  # Loop through items for a precise match
  for item in "${@}" ; do
    [[ "${item}" == "${expected}" ]] && return 0
  done
  # We did not find the item
  return -1
}

print_by_line() {
  for item in "${@:-}" ; do
    echo "${item}"
  done
}

cd "${BUILD_WORKSPACE_DIRECTORY}"

# Query for any 'updatesrc_update' targets
# bazel_query="kind(updatesrc_update, //...)"
# targets_to_run+=( $(bazel query "${bazel_query}" | sort) )

# The output `package` appears to sort the results
all_pkgs=( $(bazel query //... --output package) )
pkgs_with_format=( $(bazel query 'kind(bzlformat_format, //...)' --output package) )

# DEBUG BEGIN
echo >&2 "*** CHUCK  all_pkgs:"
for (( i = 0; i < ${#all_pkgs[@]}; i++ )); do
  echo >&2 "*** CHUCK   ${i}: ${all_pkgs[${i}]}"
done
echo >&2 "*** CHUCK  pkgs_with_format:"
for (( i = 0; i < ${#pkgs_with_format[@]}; i++ )); do
  echo >&2 "*** CHUCK   ${i}: ${pkgs_with_format[${i}]}"
done
# DEBUG END

# TODO: Not handling root (empty package).

pkgs_missing_format=()
for pkg in "${all_pkgs[@]}" ; do
  contains_item "${pkg}" "${pkgs_with_format[@]}" || pkgs_missing_format+=( "${pkg}" )
done

print_by_line "${pkgs_missing_format[@]}"
