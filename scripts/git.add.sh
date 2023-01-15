#!/bin/sh

FILE=`realpath $1`

# -- to "add" a file over on git's "staging" area
# -- we need to first add it to its object database (ie. gits "objects" directory)
# -- * for mode details see here:
# -- https://git-scm.com/book/en/v2/Git-Internals-Git-Objects#_object_storage
# -- https://stackoverflow.com/questions/5290444/why-does-git-hash-object-return-a-different-hash-than-openssl-sha1
filehash=`git hash-object -w $FILE`

# -- and second, "add" it onto git's index
filepath=${FILE#$(git rev-parse --show-toplevel)/}
git update-index --add --cacheinfo 100644 $filehash $filepath

