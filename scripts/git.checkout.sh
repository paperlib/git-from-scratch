#!/bin/sh

checkout_branch="refs/heads/$1"

# -- path to the .git directory of the current repo
gitrepo="$(git rev-parse --show-toplevel)"
gitdir="$gitrepo/.git"

# -- get current branch
# -- assume we are not in detached head state
current_branch=$(grep -oP 'ref:\s*\K.*' $gitdir/HEAD)

# -- get the "commit tree" we want to go to (checkout head)
# -- and the "commit tree" we are on (current head)
checkout_head=$(cat $gitdir/$checkout_branch)
current_head=$(cat $gitdir/$current_branch)

checkout_tree=$(git cat-file -p $checkout_head | grep -oP 'tree\s+\K.*')
current_tree=$(git cat-file -p $current_head | grep -oP 'tree\s+\K.*')

# -- now actually go to the branch we want to be on (ie. the checkout branch)
# -- for that we replace (remove) all files in the current branch
# -- and put back the checkout branch files that we want.
# --
# -- note: on posix IFS newline separator: https://stackoverflow.com/a/19822980
echo "removing <$(echo $current_branch | awk -F/ '{ print $NF }')> branch files!"
echo "$(git ls-tree -r $current_tree)" | while read line; do
  eval $( echo $line | awk -F' ' '{ print "rws=" $1 "\n" "type=" $2 "\n" "hash=" $3 "\n" "name=" $4 }' )
  echo "removing: rws: $rws, type: $type, name: $name, hash: $hash"

  rm -f $gitrepo/$name
  # -- note: as per "git update-index" documentation:
  # -- "If a specified file is in the index but is missing then it’s removed"
  # -- so we have to delete the file from the working directory (which we just did above)
  # -- before running "update-index --remove".. so this is what we do here.
  git update-index --remove $name
done

echo "and ..."

echo "restoring <$(echo $checkout_branch | awk -F/ '{ print $NF }')> (checkout) branch files"
echo "$(git ls-tree -r $checkout_tree)" | while read line; do
  eval $( echo $line | awk -F' ' '{ print "rws=" $1 "\n" "type=" $2 "\n" "hash=" $3 "\n" "name=" $4 }' )
  echo "replacing rws: $rws, type: $type, name: $name, hash: $hash"

  git update-index --add --cacheinfo 100644 $hash $name
  git cat-file -p $hash > $gitrepo/$name
done

echo "ref: $checkout_branch" > $gitdir/HEAD

