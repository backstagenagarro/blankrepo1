#!/bin/bash

# Set your GitHub username, personal access token, and organization name from environment variables
USERNAME="${MY_USERNAME}"
TOKEN="${MY_TOKEN}"
ORG="${MY_ORG}"

# Comma-separated list of repository names to exclude from deletion
EXCLUDE_REPOS="blankrepo1,blankrepo2"

# Convert comma-separated list to array
IFS=',' read -r -a EXCLUDE_ARRAY <<< "$EXCLUDE_REPOS"

# Function to check if a repo is in the exclusion list
is_excluded() {
  local repo=$1
  for excluded_repo in "${EXCLUDE_ARRAY[@]}"; do
    if [[ "$excluded_repo" == "$repo" ]]; then
      return 0
    fi
  done
  return 1
}

# Fetch the list of repositories in the organization
REPOS=$(curl -s -u "$USERNAME:$TOKEN" "https://api.github.com/orgs/$ORG/repos?per_page=100" | jq -r '.[].name')

# Loop through the repositories and delete them if not excluded
for repo in $REPOS; do
  if is_excluded "$repo"; then
    echo "Skipping repository: $repo"
  else
    echo "Deleting repository: $repo"
    response=$(curl -s -o /dev/null -w "%{http_code}" -u "$USERNAME:$TOKEN" -X DELETE "https://api.github.com/repos/$ORG/$repo")
    if [ "$response" == "204" ]; then
      echo "Successfully deleted repository: $repo"
    else
      echo "Failed to delete repository: $repo. HTTP status code: $response"
    fi
  fi
done
