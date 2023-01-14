#!/bin/sh

# -- Usage:
# -- git.init.sh <git_directory> <git_branch>
# -- <git_directory> defaults to the current directory if not specified
# -- <git_branch>    defaults to "master" if not specified

GIT_DIR=${1:-.}
GIT_BRANCH=${2:-master}

# -- create the .git root directory
# -- with an 'objects' directory containing git's repo objects
# -- and a way to reference them (ie. name them) in refs
mkdir -p $GIT_DIR/.git $GIT_DIR/.git/objects $GIT_DIR/.git/refs/heads

# -- tell git which branch git is pointing to (default to 'master'.)
echo "ref: refs/heads/$GIT_BRANCH" > $GIT_DIR/.git/HEAD
