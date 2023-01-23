# Git from Scratch: actually understanding git!

> [Git Internals - Creating a Repo From Scratch](https://www.youtube.com/watch?v=52MFjdGH20o)
> is _the_ most amazing video ever created about `git`.<br>
> if you want to **actually _understand_ `git`**
> do yourself a service and go watch it!

<br>
<p align="center">
<a href="http://www.youtube.com/watch?feature=player_embedded&v=52MFjdGH20o" target="_blank">
 <img src="http://img.youtube.com/vi/52MFjdGH20o/maxresdefault.jpg" alt="Watch the video" width="50%" />
</a>
</p>

Other excelent resources include:
- [Git From the Bits up](https://www.youtube.com/watch?v=MYP56QJpDr4): almost the same walkthrough as above (longer + touches on `rebase`)
- [Deep Dive Into Git • Edward Thomson • GOTO 2015](https://www.youtube.com/watch?v=dBSHLb1B8sw)
- [Git for Professionals Tutorial - Tools & Concepts for Mastering Version Control with Git](https://www.youtube.com/watch?v=Uszj_k0DGsg)
- [Git Internals - Git Objects](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects)

# Overview

Main plumbing commands:<br>
`git hash-object`, `git update-index`, and `git write-tree` and `git commit-tree` 📌

```shell
$ mkdir git-from-scratch
$ cd git-from-scratch
$ mkdir .git/objects .git/refs .git/refs/heads
$ echo ref: refs/heads/master > .git/HEAD
$ echo That Brief YouTube channel is indeed awesome | git hash-object --stdin -w # 57dbcd*
$ git update-index --add --cacheinfo 100644 57dbcdd7a5e501fd6518c9d170af2c94d481508f awesome.brief.txt
$ git cat-file -p 57dbcdd7a5e501fd6518c9d170af2c94d481508f > awesome.brief.txt
$ git write-tree
$ git commit-tree 32c4384a112bf311f54cfae69f67815b90141713 -m "awesome brief initial commit" # b0b55c*
$ echo b0b55c79d5342ecd3a6521d7db771dac7fc63c4a > .git/refs/heads/master
```

# Walkthrough

```shell
$ mkdir git-from-scratch
$ cd git-from-scratch
```
```
$ mkdir .git/objects .git/refs .git/refs/heads
$ echo ref: refs/heads/master > .git/HEAD
```
```
$ echo That Brief YouTube channel is indeed awesome | git hash-object --stdin -w
57dbcdd7a5e501fd6518c9d170af2c94d481508f
```
```
$ git cat-file -t 57dbcdd7a5e501fd6518c9d170af2c94d481508f
blob
$ git cat-file -p 57dbcdd7a5e501fd6518c9d170af2c94d481508f
That Brief YouTube channel is indeed awesome
```
```
# -- equivalent to "git add awesome.brief.txt" - TODO: partially true or fully? 📌
$ git update-index --add --cacheinfo 100644 57dbcdd7a5e501fd6518c9d170af2c94d481508f awesome.brief.txt
```
```shell
$ tree -a
.
└── .git
    ├── HEAD
    ├── index
    ├── objects
    │   └── 57
    │       └── dbcdd7a5e501fd6518c9d170af2c94d481508f
    └── refs
        └── heads

5 directories, 3 files
```
```shell
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   awesome.brief.txt

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        deleted:    awesome.brief.txt
```
```
$ git cat-file -p 57dbcdd7a5e501fd6518c9d170af2c94d481508f > awesome.brief.txt
```
```
# -- write-tree does not write out the working directory content
# -- it writes out whatever is in the index.
$ git write-tree 📌
32c4384a112bf311f54cfae69f67815b90141713
$ tree -a
.
├── .git
│   ├── HEAD
│   ├── index
│   ├── objects
│   │   ├── 32
│   │   │   └── c4384a112bf311f54cfae69f67815b90141713
│   │   └── 57
│   │       └── dbcdd7a5e501fd6518c9d170af2c94d481508f
│   └── refs
│       └── heads
└── awesome.brief.txt

6 directories, 5 files
$ git cat-file -t 32c4384a112bf311f54cfae69f67815b90141713
tree
$ git cat-file -p 32c4384a112bf311f54cfae69f67815b90141713
100644 blob 57dbcdd7a5e501fd6518c9d170af2c94d481508f    awesome.brief.txt
```
```
# -- equivalent of "git commit awesome.brief.txt" 📌
$ git commit-tree 32c4384a112bf311f54cfae69f67815b90141713 -m "awesome brief initial commit" 
b0b55c79d5342ecd3a6521d7db771dac7fc63c4a
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   awesome.brief.txt

$ tree -a
.
├── .git
│   ├── HEAD
│   ├── index
│   ├── objects
│   │   ├── 32
│   │   │   └── c4384a112bf311f54cfae69f67815b90141713
│   │   ├── 57
│   │   │   └── dbcdd7a5e501fd6518c9d170af2c94d481508f
│   │   └── b0
│   │       └── b55c79d5342ecd3a6521d7db771dac7fc63c4a
│   └── refs
│       └── heads
└── awesome.brief.txt

7 directories, 6 files
```
```
$ git cat-file -t b0b55c79d5342ecd3a6521d7db771dac7fc63c4a
commit
$ git cat-file -p b0b55c79d5342ecd3a6521d7db771dac7fc63c4a
tree 32c4384a112bf311f54cfae69f67815b90141713
author stephane <anemail@acompany.com> 1672605219 +0000
committer stephane <anemail@acompany.com> 1672605219 +0000

awesome brief initial commit
```
```shell
$ echo b0b55c79d5342ecd3a6521d7db771dac7fc63c4a > .git/refs/heads/master
$ git status
On branch master
nothing to commit, working tree clean
```

# Notes

> `$ git config --global alias.lol 'log --oneline --graph'`

> `$ git init --template=/dev/null ./git-empty-git`

```
$ git cat-file -t ff58d06f62f348cceb893dea4db8fdbe5173eeb8
tree
$ git cat-file -p ff58d06f62f348cceb893dea4db8fdbe5173eeb8
100644 blob 299d7ef205fff43cca0a761db9cd16deb29def7a    a.first-file.txt
$ git ls-files --stage
100644 299d7ef205fff43cca0a761db9cd16deb29def7a 0       a.first-file.txt
```
