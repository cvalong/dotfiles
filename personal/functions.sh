# Rebase a branch onto another, with optional push
# Usage: rebase_onto [<source_branch>] [<base_branch>] [--push]
# If no source branch is provided, the current branch is used.
# If no base branch is provided, 'main' is used.
# If --push is provided, the source branch will be pushed to origin after rebasing.
# Example: rebase_onto
# Example: rebase_onto --push
# Example: rebase_onto feature-branch
# Example: rebase_onto feature-branch main
# Example: rebase_onto feature-branch main --push
rebase_onto() {
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  SOURCE_BRANCH="$CURRENT_BRANCH"
  BASE_BRANCH="main"
  SHOULD_PUSH=false

  for arg in "$@"; do
    case "$arg" in
      --push)
        SHOULD_PUSH=true
        ;;
      *)
        if [[ -z "$SOURCE_BRANCH_PROVIDED" ]]; then
          SOURCE_BRANCH="$arg"
          SOURCE_BRANCH_PROVIDED=true
        elif [[ -z "$BASE_BRANCH_PROVIDED" ]]; then
          BASE_BRANCH="$arg"
          BASE_BRANCH_PROVIDED=true
        fi
        ;;
    esac
  done

  echo "Rebasing '$SOURCE_BRANCH' onto '$BASE_BRANCH'..."

  git stash && \
  git checkout "$BASE_BRANCH" && \
  git pull --prune && \
  git checkout "$SOURCE_BRANCH" && \
  git rebase "$BASE_BRANCH"

  if [ "$SHOULD_PUSH" = true ]; then
    echo "Pushing '$SOURCE_BRANCH' to origin..."
    git push --force-with-lease origin "$SOURCE_BRANCH"
  fi

  git stash pop
}