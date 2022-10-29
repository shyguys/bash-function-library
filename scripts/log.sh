#!/bin/bash
#
# Log messages to the command line.

log::display_usage() {
  cat << EOL
Usage: log <MESSAGE> [OPTION]...
Log messages to the command line.

Options:
  tbc
EOL
}

log() {
  local SCRIPT_NAME
  local GETOPT_OPTS
  local GETOPT_LONGOPTS
  local GETOPT_PARSED_ARGS
  local GETOPT_RETURN_CODE

  SCRIPT_NAME="$(basename "${0%.*}")"
  GETOPT_LONGOPTS="help,error,success,warning"
  GETOPT_PARSED_ARGS="$(getopt -n "${SCRIPT_NAME}: log" -o "${GETOPT_OPTS}" -l "${GETOPT_LONGOPTS}" -- "$@")"
  GETOPT_RETURN_CODE=$?
  if [[ GETOPT_RETURN_CODE -ne 0 ]]; then
    echo "${SCRIPT_NAME}: log: internal error."
    exit 2
  fi

  local MESSAGE
  local -i IS_ERROR
  local -i IS_SUCCESS
  local -i IS_WARNING
  local ESCAPE_CODE_RESET
  local ESCAPE_CODE_RED
  local ESCAPE_CODE_GREEN
  local ESCAPE_CODE_YELLOW

  ESCAPE_CODE_RESET="\033[0m"
  ESCAPE_CODE_RED="\033[0;31m"
  ESCAPE_CODE_GREEN="\033[0;32m"
  ESCAPE_CODE_YELLOW="\033[0;33m"

  eval set -- "${GETOPT_PARSED_ARGS}"
  while true; do
    case "${1}" in
      "--help")
        log::display_usage
        exit 0
      ;;

      "--error")
        IS_ERROR=1
        shift 1
      ;;

      "--success")
        IS_SUCCESS=1
        shift 1
      ;;

      "--warning")
        IS_WARNING=1
        shift 1
      ;;

      "--")
        MESSAGE="${2}"
        shift 2
        break
      ;;
    esac    
  done

  if [[ $IS_ERROR -eq 1 ]]; then
    echo -e "${ESCAPE_CODE_RED}${SCRIPT_NAME}: ${MESSAGE}${ESCAPE_CODE_RESET}"
    return 0
  fi

  if [[ $IS_WARNING -eq 1 ]]; then
    echo -e "${ESCAPE_CODE_YELLOW}${SCRIPT_NAME}: ${MESSAGE}${ESCAPE_CODE_RESET}"
    return 0
  fi

  if [[ $IS_SUCCESS -eq 1 ]]; then
    echo -e "${ESCAPE_CODE_GREEN}${SCRIPT_NAME}: ${MESSAGE}${ESCAPE_CODE_RESET}"
    return 0
  fi

  echo "${SCRIPT_NAME}: ${MESSAGE}"
}
