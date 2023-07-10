#! /bin/sh
#
# @brief: is MacOS platform
#         mac date a little different with other
# @retval: 0 - no
# @retval: 1 - yes
function is_macos()
{
    local os="${OSTYPE/"darwin"//}"
    if [ "$os" != "$OSTYPE" ]; then
        # darwin: macos
        return 1
    else
        return 0
    fi
}

is_macos
IS_MAC=$?
