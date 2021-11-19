#!/usr/bin/env bash

normalize_pkg() {
  # Strip any target specifications
  local pkg="${1%:*}"
  # Strip a trailing slash
  local pkg="${pkg%/}"
  # Strip a trailing slash
  # Make sure to add prefix (//)
  case "${pkg}" in
    "//"*)
      ;;
    "/"*)
      local pkg="/${pkg}"
      ;;
    *)
      local pkg="//${pkg}"
      ;;
  esac
  echo "${pkg}"
}
