#!/bin/bash
#
# Check if an element is in an array.

element_in::display_usage() {
  cat << EOL
Usage: element_in <MATCH> <ARRAY> [OPTION...]
Check if an element is in an array.

Options:
  tbc
EOL
}

element_in() {
  local SCRIPT_NAME
  local GETOPT_OPTS
  local GETOPT_LONGOPTS
  local GETOPT_PARSED_ARGS
  local GETOPT_RETURN_CODE

  SCRIPT_NAME="$(basename "${0%.*}")"
  GETOPT_LONGOPTS="help"
  GETOPT_PARSED_ARGS="$(getopt -n "${SCRIPT_NAME}: element_in" -o "${GETOPT_OPTS}" -l "${GETOPT_LONGOPTS}" -- "$@")"
  GETOPT_RETURN_CODE=$?
  if [[ GETOPT_RETURN_CODE -ne 0 ]]; then
    echo "${SCRIPT_NAME}: element_in: internal error."
    exit 2
  fi

  local MATCH
  local ELEMENT

  eval set -- "${GETOPT_PARSED_ARGS}"
  while true; do
    case "${1}" in
      "--help")
        element_in::display_usage
        return 0
      ;;

      "--")
        MATCH="${2}"
        shift 2
        break
      ;;
    esac
  done

  for ELEMENT; do
    if [[ "${ELEMENT}" == "${MATCH}" ]]; then
      return 0
    fi
  done

  return 1
}
