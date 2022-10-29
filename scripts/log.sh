#!/bin/bash
#
# Log messages to the command line.

log::display_usage() {
  cat << EOL
Usage: log <MESSAGE> [OPTION]...
Log messages to the command line.

Options:
  --bold       use bold mode.
  --red        use red foreground color.
  --green      use green foreground color.
  --yellow     use yellow foreground color.
  --blue       use blue foreground color.
  --error      same as --bold --red.
  --success    same as --bold --green.
  --warning    same as --bold --yellow.
  --info       same as --bold --blue.
  --help       display this usage information.
EOL
}

log() {
  local SCRIPT_NAME
  local GETOPT_OPTS
  local GETOPT_LONGOPTS
  local GETOPT_PARSED_ARGS
  local GETOPT_RETURN_CODE

  SCRIPT_NAME="$(basename "${0%.*}")"
  GETOPT_LONGOPTS="bold,red,green,yellow,blue,error,success,warning,info,help"
  GETOPT_PARSED_ARGS="$(getopt -n "${SCRIPT_NAME}: log" -o "${GETOPT_OPTS}" -l "${GETOPT_LONGOPTS}" -- "$@")"
  GETOPT_RETURN_CODE=$?
  if [[ GETOPT_RETURN_CODE -ne 0 ]]; then
    echo "${SCRIPT_NAME}: log: internal error."
    exit 2
  fi

  local ESCAPE_CODE_BOLD
  local ESCAPE_CODE_RED
  local ESCAPE_CODE_GREEN
  local ESCAPE_CODE_YELLOW
  local ESCAPE_CODE_BLUE
  local -i IS_BOLD
  local -i IS_RED
  local -i IS_GREEN
  local -i IS_YELLOW
  local -i IS_BLUE
  local -a ESCAPE_CODES
  local ESCAPE_CODE
  local ESCAPE_SEQUENCE
  local MESSAGE

  ESCAPE_CODE_BOLD="1"
  ESCAPE_CODE_RED="31"
  ESCAPE_CODE_GREEN="32"
  ESCAPE_CODE_YELLOW="33"
  ESCAPE_CODE_BLUE="34"

  eval set -- "${GETOPT_PARSED_ARGS}"
  while true; do
    case "${1}" in
      "--bold")
        IS_BOLD=1
        shift 1
      ;;

      "--red")
        IS_RED=1
        shift 1
      ;;

      "--green")
        IS_GREEN=1
        shift 1
      ;;

      "--yellow")
        IS_YELLOW=1
        shift 1
      ;;

      "--blue")
        IS_BLUE=1
        shift 1
      ;;

      "--error")
        IS_RED=1
        IS_BOLD=1
        shift 1
      ;;

      "--success")
        IS_GREEN=1
        IS_BOLD=1
        shift 1
      ;;

      "--warning")
        IS_YELLOW=1
        IS_BOLD=1
        shift 1
      ;;

      "--info")
        IS_BLUE=1
        IS_BOLD=1
        shift 1
      ;;

      "--help")
        log::display_usage
        exit 0
      ;;

      "--")
        MESSAGE="${2}"
        shift 2
        break
      ;;
    esac
  done

  if [[ $IS_BOLD -eq 1 ]]; then
    ESCAPE_CODES+="${ESCAPE_CODE_BOLD}"
  fi

  if [[ $IS_RED -eq 1 ]]; then
    ESCAPE_CODES+=("${ESCAPE_CODE_RED}")
  elif [[ $IS_YELLOW -eq 1 ]]; then
    ESCAPE_CODES+=("${ESCAPE_CODE_YELLOW}")
  elif [[ $IS_GREEN -eq 1 ]]; then
    ESCAPE_CODES+=("${ESCAPE_CODE_GREEN}")
  elif [[ $IS_BLUE -eq 1 ]]; then
    ESCAPE_CODES+=("${ESCAPE_CODE_BLUE}")
  fi

  for ESCAPE_CODE in "${ESCAPE_CODES[@]}"; do
    if [[ -n "${ESCAPE_SEQUENCE}" ]]; then
      ESCAPE_SEQUENCE+=";"
    fi

    ESCAPE_SEQUENCE+="${ESCAPE_CODE}"
  done

  if [[ -z "${ESCAPE_SEQUENCE}" ]]; then
    echo -e "${SCRIPT_NAME}: ${MESSAGE}"
    return 0
  fi

  echo -e "\033[${ESCAPE_SEQUENCE}m${SCRIPT_NAME}: ${MESSAGE}\033[0m"
}
