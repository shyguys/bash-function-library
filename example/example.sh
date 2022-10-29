#!/bin/bash
#
# Example function script.

example::display_usage() {
  cat << EOL
Usage: example <MESSAGE> [OPTION]...
Echo a message.

Options:
  --help    display this usage information. 
EOL
}

example() {
  if [[ "${1}" == "--help" ]]; then
    example::display_usage
    return 0
  fi

  echo "example says '${1}'"
}
