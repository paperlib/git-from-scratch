#!/bin/sh

commit_message=$1

# -- path to the .git directory of the current repo
gitdir="$(git rev-parse --show-toplevel)/.git"

# -- get current branch
# -- assume we are not in detached head state
branch=$(grep -oP 'ref:\s*\K.*' $gitdir/HEAD)

commit_parent=$(cat $gitdir/$branch)
if [ $commit_parent ]; then commit_parent="-p $commit_parent"; fi

# -- and now we are ready to commit
# -- https://jwiegley.github.io/git-from-the-bottom-up/1-Repository/4-how-trees-are-made.html
# -- https://jwiegley.github.io/git-from-the-bottom-up/1-Repository/5-the-beauty-of-commits.html
tree_hash=$(git write-tree)
commit_hash=$(git commit-tree $tree_hash -m "$commit_message" $commit_parent)

echo $commit_hash > $gitdir/$branch

