# Understanding Git

<p align="center">
<a href="http://www.youtube.com/watch?feature=player_embedded&v=52MFjdGH20o" target="_blank">
 <img src="http://img.youtube.com/vi/52MFjdGH20o/maxresdefault.jpg" alt="Watch the video" width="50%" />
</a><br>
<em>Ever wanted to truly understand git? Watch this video :point_up:</em>
</p>

Consider this snippet from the always accurate [`xkcd`](https://xkcd.com/1597) [on `git`](https://xkcd.com/1597):

> **How do you use `git`? _No idea_**. Just memorize these shell commands and type them to sync up.
> If you get errors, save your work elsewhere, delete the project, and download a fresh copy.

if this has ever been you.. **read on**

# Intro

> Go in fear of Abstractions - Erza Pound

If _intuitiveness_, _responsiveness_, _consistency_, and _efficiency_ are among the most common properties
of good user interfaces, _completeness_ rarely ever seems to make it to the top. And maybe understandbly so,
since _completeness_ and _intuitiveness_ are in a direct fist fight with each other.

Limiting ourselves to such "surface level" intituitive (user interface) commands - like `git add`,
`git commmit` and the likes - means then we will never truly understand (let alone master) `git`.  The
minute our surface level abstractions break appart, we are lost, just as in the above
[`xkcd`](https://xkcd.com/1597) joke.

---

Ok so how hard would it be? To create a repo from scratch? Well, check this out:

```shell
# -- we create a directory
mkdir git-from-scratch; cd git-from-scratch

# -- and a "bunch of sub-directories":
# -- "objects" to hold our commits, and "refs" to hold aliases to those commits
mkdir -p .git/objects .git/refs .git/refs/heads

# -- finally we decide which of those aliases should be the current one
# -- uh ho... which branch are we on anyone? .-)
echo ref: refs/heads/main > .git/HEAD
```

That's it.

Ok we still need explaining what those references and objects are about, but we can keep
this short snippet as a cheat code to our understanding of `git`.  The gist of it is that under
objects we have **tree**s (ie. directories) which like directories contain a list of **blob**s
(ie. litteraly zipped versions of your files), and **commit**s, which are
pointers to trees, with some additional metadata.

> [!NOTE]
> `git` has 3 of its main object types live under the `objects` directory
>
> - **Tree**s: ie. _directories_, containing list of **blob**s<br>
>   > additionaly **tree**s may contain **tree**s recursively like _diretories_
> - **Blob**s: litteraly compressed (zipped) versions of our _files_ at a given point in time
> - **Commit**s: eg. pointers to **tree**s with some additional metadata (eg. author, commit message, etc.)

Main plumbing commands:<br>
`git hash-object`, `git update-index`, and `git write-tree` and `git commit-tree` 📌

```shell
mkdir git-from-scratch
cd git-from-scratch
mkdir .git/objects .git/refs .git/refs/heads
echo ref: refs/heads/master > .git/HEAD
echo That Brief YouTube channel is indeed awesome | git hash-object --stdin -w # 57dbcd*
git update-index --add --cacheinfo 100644 57dbcdd7a5e501fd6518c9d170af2c94d481508f awesome.brief.txt
git cat-file -p 57dbcdd7a5e501fd6518c9d170af2c94d481508f > awesome.brief.txt
git write-tree
git commit-tree 32c4384a112bf311f54cfae69f67815b90141713 -m "awesome brief initial commit" # b0b55c*
echo cb6530cefb9b25fe50feb9792b78cf94cb23df6a > .git/refs/heads/master
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

# References
Other excelent resources include:
- [Git From the Bits up](https://www.youtube.com/watch?v=MYP56QJpDr4): almost the same walkthrough as above (longer + touches on `rebase`)
- [Deep Dive Into Git • Edward Thomson • GOTO 2015](https://www.youtube.com/watch?v=dBSHLb1B8sw)
- [Git for Professionals Tutorial - Tools & Concepts for Mastering Version Control with Git](https://www.youtube.com/watch?v=Uszj_k0DGsg)
- [Git Internals - Git Objects](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects)

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
![git detached-head-example](https://user-images.githubusercontent.com/11051605/215194378-a3a630cb-70f9-4f77-ad53-e394c00a01eb.png)
