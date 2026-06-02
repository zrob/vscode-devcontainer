#!/usr/bin/env bash

set -e

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${__dir}/../Dockerfile.base"
FETCH_VERSIONS="${__dir}/fetch-versions.sh"

echo "Fetching latest versions..."
fetch_output=$("$FETCH_VERSIONS")
echo "Done."
echo

ruby_install_latest=$(echo "$fetch_output" | grep "Latest versions" -A 5 | grep "ruby-install:" | cut -d: -f2 | tr -d ' ')
chruby_latest=$(echo "$fetch_output" | grep "Latest versions" -A 5 | grep "chruby:" | cut -d: -f2 | tr -d ' ')
golang_latest=$(echo "$fetch_output" | grep "Latest versions" -A 5 | grep "golang:" | cut -d: -f2 | tr -d ' ')

components=("ruby_install" "chruby" "golang")
declare -A latest_versions
latest_versions["ruby_install"]=$ruby_install_latest
latest_versions["chruby"]=$chruby_latest
latest_versions["golang"]=$golang_latest

declare -A display_names
display_names["ruby_install"]="ruby-install"
display_names["chruby"]="chruby"
display_names["golang"]="golang"

for component in "${components[@]}"; do
    current_version=$(grep "ARG" "${DOCKERFILE}" | grep "${component}_version" | cut -d= -f2 | tr -d \")
    latest_version=${latest_versions[$component]}

    if [[ -z "$latest_version" ]]; then
        echo "Error: Could not fetch latest version for ${display_names[$component]}"
        echo
        continue
    fi

    if [[ "$current_version" != "$latest_version" ]]; then
        echo "================================================================================"
        echo " UPDATE FOUND: ${display_names[$component]}"
        echo "--------------------------------------------------------------------------------"
        echo "  Current: ${current_version}"
        echo "  Latest:  ${latest_version}"
        echo
        
        # Update the Dockerfile
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/${component}_version=\"${current_version}\"/${component}_version=\"${latest_version}\"/" "${DOCKERFILE}"
        else
            sed -i "s/${component}_version=\"${current_version}\"/${component}_version=\"${latest_version}\"/" "${DOCKERFILE}"
        fi

        git add "${DOCKERFILE}"
        
        echo "Diff for ${DOCKERFILE}:"
        echo "--------------------------------------------------------------------------------"
        git --no-pager diff --staged "${DOCKERFILE}"
        echo "--------------------------------------------------------------------------------"
        echo

        commit_msg="bump ${display_names[$component]} ${latest_version}"
        read -p "Commit with message: '${commit_msg}'? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git commit -m "${commit_msg}"
            echo "Committed."
        else
            echo "Skipping commit. Changes for ${display_names[$component]} are staged."
        fi
        echo
    else
        echo "OK: ${display_names[$component]} is already at the latest version (${current_version})."
        echo
    fi
done
