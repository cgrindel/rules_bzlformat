#!/usr/bin/env bash

normalize_pkg() {
  local pkg="${1}"
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
