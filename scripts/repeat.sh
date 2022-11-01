#!/bin/bash
#
# Repeat a string.

repeat::display_usage() {
  cat << EOL
Usage: repeat <STRING> [OPTION...]
Repeat a string.

Options:
  --help    display this usage information.
EOL
}

repeat() {
  local SCRIPT_NAME
  local GETOPT_OPTS
  local GETOPT_LONGOPTS
  local GETOPT_PARSED_ARGS
  local GETOPT_RETURN_CODE

  SCRIPT_NAME="$(basename "${0%.*}")"
  GETOPT_LONGOPTS="help"
  GETOPT_PARSED_ARGS="$(getopt -n "${SCRIPT_NAME}: repeat" -o "${GETOPT_OPTS}" -l "${GETOPT_LONGOPTS}" -- "$@")"
  GETOPT_RETURN_CODE=$?
  if [[ GETOPT_RETURN_CODE -ne 0 ]]; then
    echo "${SCRIPT_NAME}: repeat: internal error."
    exit 2
  fi

  local -i AMOUNT
  local INPUT
  local OUTPUT

  eval set -- "${GETOPT_PARSED_ARGS}"
  while true; do
    case "${1}" in
      "--help")
        repeat::display_usage
        return 0
      ;;

      "--")
        AMOUNT="${2}"
        INPUT="${3}"
        shift 3
        break
      ;;
    esac
  done

  for (( i=0; i<$AMOUNT; i++ )); do
    OUTPUT+="${INPUT}"
  done

  echo "${OUTPUT}"
}
