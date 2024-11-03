#!/bin/bash

# Set GitHub username
GITHUB_USERNAME="afroeschl"
REPO_NAME="$(basename "$PWD")"

# Check if GITHUB_TOKEN is set
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo -e "Error: GitHub token is not set. Please export GITHUB_TOKEN and rerun the script. Use \033[1mexport GITHUB_TOKEN="YOUR TOKEN"\033[0m"
    	exit 1
fi

# URL for GitHub remote
GITHUB_REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

# Check if the GitHub repository exists
REPO_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME")

if [ "$REPO_EXISTS" -eq 404 ]; then
    echo "GitHub repository does not exist. Creating it now..."

    # Create the GitHub repository using the API
    CREATE_REPO_RESPONSE=$(curl -s -w "%{http_code}" -o /dev/null -H "Authorization: Bearer $GITHUB_TOKEN" -d "{\"name\":\"$REPO_NAME\"}" "https://api.github.com/user/repos")

    if [ "$CREATE_REPO_RESPONSE" -eq 201 ]; then
        echo "GitHub repository '$REPO_NAME' created successfully."
    else
        echo "Failed to create GitHub repository. HTTP status: $CREATE_REPO_RESPONSE"
        echo "Response: $(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" -d "{\"name\":\"$REPO_NAME\"}" "https://api.github.com/user/repos")"
        exit 1
    fi
else
    echo "GitHub repository '$REPO_NAME' already exists."
fi

# Check if this repo already has a GitHub remote
if git remote | grep -q "github"; then
  echo "GitHub remote already exists."
else
  # Add GitHub remote
  git remote add github "$GITHUB_REMOTE_URL"
  echo "Added GitHub remote: $GITHUB_REMOTE_URL"
fi

# Fetch from both remotes
git fetch origin
git fetch github

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if the current branch exists in both remotes
ORIGIN_HASH=$(git rev-parse "origin/$CURRENT_BRANCH" 2>/dev/null)
GITHUB_HASH=$(git rev-parse "github/$CURRENT_BRANCH" 2>/dev/null)

if [ -z "$ORIGIN_HASH" ]; then
  echo "The branch '$CURRENT_BRANCH' does not exist in the origin remote."
  echo "If this is a new repository, please make your initial commit and push."
  exit 1
fi

# Check for sync
if [ "$ORIGIN_HASH" != "$GITHUB_HASH" ]; then
  echo "Repositories are out of sync. Syncing..."

  # Pull from origin to get the latest updates
  git pull origin "$CURRENT_BRANCH"

  # Push to GitHub to sync
  git push github "$CURRENT_BRANCH"
  echo "Repositories have been synced."
else
  echo "Repositories are already in sync."
fi

# Set up push to both remotes by default
git remote set-url --add --push origin "$GITHUB_REMOTE_URL"
git remote set-url --add --push origin "$(git remote get-url origin)"

echo "Setup complete. Commits will now be pushed to both remotes."

