#!/bin/bash

compare_versions() {
    # Split versions into arrays
    IFS='.' read -ra VER1 <<< "$1"
    IFS='.' read -ra VER2 <<< "$2"

    # Compare each component
    for ((i=0; i<${#VER1[@]} && i<${#VER2[@]}; i++)); do
        # Convert to integers for numeric comparison
        v1=$((10#${VER1[i]}))
        v2=$((10#${VER2[i]}))

        if [[ $v1 -gt $v2 ]]; then
            echo 1  # Version 1 is greater
            return
        elif [[ $v1 -lt $v2 ]]; then
            echo -1  # Version 2 is greater
            return
        fi
    done

    # If we get here, all components so far were equal
    # Check if one version has more components
    if [[ ${#VER1[@]} -gt ${#VER2[@]} ]]; then
        echo 1
    elif [[ ${#VER1[@]} -lt ${#VER2[@]} ]]; then
        echo -1
    else
        echo 0  # Versions are equal
    fi
}

# Example usage:
# result=$(compare_versions "1.2.3" "1.2.4")
# if [[ $result -eq 1 ]]; then
#     echo "Version 1 is greater"
# elif [[ $result -eq -1 ]]; then
#     echo "Version 2 is greater"
# else
#     echo "Versions are equal"
# fi