# Documentation

# Git
See https://www.youtube.com/watch?v=mAFoROnOfHs

## Course

### Create local repository
From a newly created folder tell git this is the working directory 
```bash
git init
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint: 
hint: 	git config --global init.defaultBranch <name>
hint: 
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint: 
hint: 	git branch -m <name>
Initialized empty Git repository in /home/bvpelt/Develop/git-one/.git/
```

The working directory is created and stored in a .git directory
```bash
ls -la
total 24
drwxrwxr-x  4 bvpelt bvpelt 4096 Mar  4 18:47 .
drwxrwxr-x 28 bvpelt bvpelt 4096 Mar  4 18:43 ..
drwxrwxr-x  7 bvpelt bvpelt 4096 Mar  4 18:47 .git
drwxrwxr-x  2 bvpelt bvpelt 4096 Mar  4 18:45 myFolder
-rw-rw-r--  1 bvpelt bvpelt    4 Mar  4 18:45 one.txt
-rw-rw-r--  1 bvpelt bvpelt    4 Mar  4 18:45 two.txt
```

### Create remote repository
In github create new repository with name git-journey and add two files one.txt with content one and two.txt with content two.

Clone repository to get content local

```bash
git clone git@github.com:bvpelt/git-journey.git
```

### Check changes
In the git-journey directory add 1 on a new line in the one.txt file.
To check if git noticed any changes type

```bash
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   one.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

Also change two.txt add 2 on a new line. Check the modification status

```bash
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   one.txt
	modified:   two.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

Moving changes from working directory to staging area

```bash
git add .
```

Create new directy myFolder with in that folder a file three.txt and content three. Go back to the project directory and check the changes

```bash
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   one.txt
	modified:   two.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	myFolder/
```

Add all changes from local working directory to staging area

```bash
git add --all
```

Check current status

```bash
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   myFolder/three.txt
	modified:   one.txt
	modified:   two.txt
```

Go back to previous state
```bash
 git reset
Unstaged changes after reset:
M	one.txt
M	two.txt
```
Check current state

```bash
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   one.txt
	modified:   two.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	myFolder/

no changes added to commit (use "git add" and/or "git commit -a")

```

Add all changes ```git add --all``` or ```git add -A```

```bash
git add -A
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   myFolder/three.txt
	modified:   one.txt
	modified:   two.txt
```

reset ```git reset```

Add all changes using ```git add .```
```bash
git add .
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   myFolder/three.txt
	modified:   one.txt
	modified:   two.txt

```
Although it looks the same there is a difference.


```bash
git reset
Unstaged changes after reset:
M	one.txt
M	two.txt
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   one.txt
	modified:   two.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	myFolder/

no changes added to commit (use "git add" and/or "git commit -a")

cd myFolder/
git add .
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   three.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   ../one.txt
	modified:   ../two.txt

```

Stage each file, use: ```git add --all``` or ```git add -A```

Stage files only from the current directory use: ```git add .```

Add all files to the staging area

```bash
cd ..
git add --all
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   myFolder/three.txt
	modified:   one.txt
	modified:   two.txt
```

Change a filename

```bash
mv two.txt four.txt
ls
four.txt  myFolder  one.txt
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   myFolder/three.txt
	modified:   one.txt
	modified:   two.txt

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    two.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	four.txt


git add * # only stages new or modified files not deleted ones
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   four.txt
	new file:   myFolder/three.txt
	modified:   one.txt
	modified:   two.txt

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    two.txt

# go back to previous state
git reset
Unstaged changes after reset:
M	one.txt
D	two.txt
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   one.txt
	deleted:    two.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	four.txt
	myFolder/

no changes added to commit (use "git add" and/or "git commit -a")

# One can move only a specific file to the staging area

git add two.txt
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	deleted:    two.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   one.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	four.txt
	myFolder/

# Go back to previous state

git reset
Unstaged changes after reset:
M	one.txt
D	two.txt

# Add files by extension
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   four.txt
	modified:   one.txt

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    two.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	myFolder/

# The best way to add all files to the working area
git add . # from top directory
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	renamed:    two.txt -> four.txt
	new file:   myFolder/three.txt
	modified:   one.txt


```

| Command       | Description                                                                          |
|---------------|--------------------------------------------------------------------------------------|
| git add --all | add all files from working area to the staging area                                  |
| git add -A    | add all files from working area to the staging area                                  |
| git add .     | add all files from the current directory of the working area to the staging area     |
| git add *     | add all new or modified files form the working area to the staging area              |
| git add *.txt | add all files with the specified extension from the working area to the staging area |

### Commits

Move changes from the staging area to the local repository

```bash
git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	renamed:    two.txt -> four.txt
	new file:   myFolder/three.txt
	modified:   one.txt

git commit -m "my changes"
[main 61ccf76] my changes
 3 files changed, 3 insertions(+)
 rename two.txt => four.txt (66%)
 create mode 100644 myFolder/three.txt

git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean

# Reset to previous state
git reset HEAD~
Unstaged changes after reset:
M	one.txt
D	two.txt

git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   one.txt
	deleted:    two.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	four.txt
	myFolder/

no changes added to commit (use "git add" and/or "git commit -a")

# Add files to staging area again
git add .
git commit -m "I have made some changes to the files"
[main f766ab7] I have made some changes to the files
 3 files changed, 3 insertions(+)
 rename two.txt => four.txt (66%)
 create mode 100644 myFolder/three.txt

# Remove one.txt
rm one.txt 
git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    one.txt

no changes added to commit (use "git add" and/or "git commit -a")

# Stage deletion
git add .
git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	deleted:    one.txt

# Remove local file and file in staging area ready for commit
ls
four.txt  myFolder

git rm four.txt
rm 'four.txt'
git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	deleted:    four.txt
	deleted:    one.txt

bvpelt@uranus:~/Develop/git-journey$ ls
myFolder

# Reset only the staged changes, not the actual files
git reset
Unstaged changes after reset:
D	four.txt
D	one.txt

git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    four.txt
	deleted:    one.txt

no changes added to commit (use "git add" and/or "git commit -a")

# reset changes and files
git reset --hard
HEAD is now at f766ab7 I have made some changes to the files

ls
four.txt  myFolder  one.txt

git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean

# change content of four.txt and try to remove it afterward
git rm four.txt 
error: the following file has local modifications:
    four.txt
(use --cached to keep the file, or -f to force removal)

#
# to change it
# - first commit it then remove it
# - or use -f flag

git rm -f four.txt 
rm 'four.txt'

git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	deleted:    four.txt


# hard reset
git reset --hard
HEAD is now at f766ab7 I have made some changes to the files
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt


# cached reset
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
two
2
# Change content of four.txt to "hello"
git rm --cached four.txt 
rm 'four.txt'
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
hello
bvpelt@uranus:~/Develop/git-journey$ git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	deleted:    four.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	four.txt

# Now four.txt is deleted from staging area and is moved to untracked section. The file still exists in the system.

```

| command            | description                                   |
|--------------------|-----------------------------------------------|
| git rm --force     | completely deletes the file                   |
| git rm --cached    | only remove file form staging area            |
| git rm -r <folder> | removes files recursive from specified folder |

```bash
bvpelt@uranus:~/Develop/git-journey$ git reset --hard
HEAD is now at f766ab7 I have made some changes to the files
bvpelt@uranus:~/Develop/git-journey$ git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt

# Using git rm -r

bvpelt@uranus:~/Develop/git-journey$ git rm -r myFolder/
rm 'myFolder/three.txt'
bvpelt@uranus:~/Develop/git-journey$ git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	deleted:    myFolder/three.txt

```

### View commits

```bash
git log
commit f766ab7d80c4d9c09c0c3e19dc17238a25b7b8fe (HEAD -> main)
Author: Bart van Pelt <bart.vanpelt@gmail.com>
Date:   Fri Mar 6 14:50:55 2026 +0100

    I have made some changes to the files

commit ccfdfd3451c87f4cca421dbf5615b9c598dd8755 (origin/main, origin/HEAD)
Author: Bart van Pelt <bart.vanpelt@gmail.com>
Date:   Wed Mar 4 18:55:53 2026 +0100

    Add new file two.txt with initial content

commit 1cec9eaee1199803eec72669fea7edec1b76cd36
Author: Bart van Pelt <bart.vanpelt@gmail.com>
Date:   Wed Mar 4 18:54:52 2026 +0100

    Add one.txt with initial content 'one'

# Short version
bvpelt@uranus:~/Develop/git-journey$ git log --oneline 
f766ab7 (HEAD -> main) I have made some changes to the files
ccfdfd3 (origin/main, origin/HEAD) Add new file two.txt with initial content
1cec9ea Add one.txt with initial content 'one'

```

### Branching

For working with software, the main branch contains the stable version. Changes are made in a development branch. When changes are good/complete they can be merged into the main branch.

```bash
# show branches

bvpelt@uranus:~/Develop/git-journey$ git branch
* main

# create new branch
bvpelt@uranus:~/Develop/git-journey$ git branch development
bvpelt@uranus:~/Develop/git-journey$ git branch
  development
* main

# The star before main means you are still in the main branch
# The newly created branch (development) contains the state of the orignal branch (main) you were in.

# activate the development branch
bvpelt@uranus:~/Develop/git-journey$ git checkout development
Switched to branch 'development'
bvpelt@uranus:~/Develop/git-journey$ git branch
* development
  main

bvpelt@uranus:~/Develop/git-journey$  git status
On branch development
nothing to commit, working tree clean

# make change (new file with content)
bvpelt@uranus:~/Develop/git-journey$ touch three.txt
bvpelt@uranus:~/Develop/git-journey$ vi three.txt 
bvpelt@uranus:~/Develop/git-journey$ git status
On branch development
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	three.txt

nothing added to commit but untracked files present (use "git add" to track)

# add three.txt to staging area. First add file from working directory to working area, then move it to staging area
bvpelt@uranus:~/Develop/git-journey$ git add .
bvpelt@uranus:~/Develop/git-journey$ git commit -m "I created three.txt and entered three there"
[development 56adcc9] I created three.txt and entered three there
 1 file changed, 1 insertion(+)
 create mode 100644 three.txt
bvpelt@uranus:~/Develop/git-journey$ git status
On branch development
nothing to commit, working tree clean

# switch to main and make change
bvpelt@uranus:~/Develop/git-journey$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
two
2
bvpelt@uranus:~/Develop/git-journey$ vi four.txt
bvpelt@uranus:~/Develop/git-journey$ cat four.txt
four
4

bvpelt@uranus:~/Develop/git-journey$ git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   four.txt

no changes added to commit (use "git add" and/or "git commit -a")

bvpelt@uranus:~/Develop/git-journey$ git add .
bvpelt@uranus:~/Develop/git-journey$ git commit -m "I changed four.txt and added four/4"
[main 3381d04] I changed four.txt and added four/4
 1 file changed, 2 insertions(+), 2 deletions(-)
bvpelt@uranus:~/Develop/git-journey$ git status
On branch main
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean

# merge changes
# first merge main into development
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt
bvpelt@uranus:~/Develop/git-journey$ git checkout development
Switched to branch 'development'
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt  three.txt
bvpelt@uranus:~/Develop/git-journey$ cat four.txt
two
2
bvpelt@uranus:~/Develop/git-journey$ cat three.txt
three


bvpelt@uranus:~/Develop/git-journey$ git merge main -m "Merging main into development"
Merge made by the 'ort' strategy.
 four.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
4
bvpelt@uranus:~/Develop/git-journey$ git status
On branch development
nothing to commit, working tree clean

# merge changes from development to main
bvpelt@uranus:~/Develop/git-journey$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt
bvpelt@uranus:~/Develop/git-journey$ git merge development -m "Merging on main with development"
Updating 3381d04..2a0a48d
Fast-forward (no commit created; -m option ignored)
 three.txt | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 three.txt
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt  three.txt
bvpelt@uranus:~/Develop/git-journey$ git status
On branch main
Your branch is ahead of 'origin/main' by 4 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt  three.txt


# Merging conflicts

bvpelt@uranus:~/Develop/git-journey$ git branch staging
bvpelt@uranus:~/Develop/git-journey$ git branch
  development
* main
  staging
bvpelt@uranus:~/Develop/git-journey$ git checkout staging
Switched to branch 'staging'
bvpelt@uranus:~/Develop/git-journey$ git branch
  development
  main
* staging
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt  three.txt
bvpelt@uranus:~/Develop/git-journey$ vi four.txt 
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
44

bvpelt@uranus:~/Develop/git-journey$ git status
On branch staging
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   four.txt

no changes added to commit (use "git add" and/or "git commit -a")

bvpelt@uranus:~/Develop/git-journey$ git add .
bvpelt@uranus:~/Develop/git-journey$ git commit -m "changed 44"
[staging 2bbdd85] changed 44
 1 file changed, 1 insertion(+), 1 deletion(-)
bvpelt@uranus:~/Develop/git-journey$ git status
On branch staging
nothing to commit, working tree clean
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
44

# setup change with merge conflict
bvpelt@uranus:~/Develop/git-journey$ git checkout development
Switched to branch 'development'
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
4
bvpelt@uranus:~/Develop/git-journey$ vi four.txt 
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
444
bvpelt@uranus:~/Develop/git-journey$ git add .
bvpelt@uranus:~/Develop/git-journey$ git commit -m "added 444 on four.txt"
[development 9a6d0c7] added 444 on four.txt
 1 file changed, 1 insertion(+), 1 deletion(-)
bvpelt@uranus:~/Develop/git-journey$ git status
On branch development
nothing to commit, working tree clean


bvpelt@uranus:~/Develop/git-journey$ git merge staging 
Auto-merging four.txt
CONFLICT (content): Merge conflict in four.txt
Automatic merge failed; fix conflicts and then commit the result.

bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
<<<<<<< HEAD
444
=======
44
>>>>>>> staging

# manually resolve merge conflict
bvpelt@uranus:~/Develop/git-journey$ vi four.txt 
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
444
bvpelt@uranus:~/Develop/git-journey$ git add .
bvpelt@uranus:~/Develop/git-journey$ git commit -m "Merge conflic solved"
[development 829851b] Merge conflic solved
bvpelt@uranus:~/Develop/git-journey$ git status
On branch development
nothing to commit, working tree clean

# since merge conflicts are resolved now development can be merged into staging
bvpelt@uranus:~/Develop/git-journey$ git checkout staging 
Switched to branch 'staging'
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
44
bvpelt@uranus:~/Develop/git-journey$ git merge development
Updating 2bbdd85..829851b
Fast-forward
 four.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
444
bvpelt@uranus:~/Develop/git-journey$ git status
On branch staging
nothing to commit, working tree clean

# merge changes to main
bvpelt@uranus:~/Develop/git-journey$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 4 commits.
  (use "git push" to publish your local commits)
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
4
bvpelt@uranus:~/Develop/git-journey$ ls
four.txt  myFolder  one.txt  three.txt
bvpelt@uranus:~/Develop/git-journey$ git merge staging
Updating 2a0a48d..829851b
Fast-forward
 four.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
bvpelt@uranus:~/Develop/git-journey$ cat four.txt 
four
444
bvpelt@uranus:~/Develop/git-journey$ git status
On branch main
Your branch is ahead of 'origin/main' by 7 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean

# go back to pervious version

bvpelt@uranus:~/Develop/git-journey$ git log --oneline 
829851b (HEAD -> main, staging, development) Merge conflic solved
9a6d0c7 added 444 on four.txt
2bbdd85 changed 44
2a0a48d Merging main into development
3381d04 I changed four.txt and added four/4
56adcc9 I created three.txt and entered three there
f766ab7 I have made some changes to the files
ccfdfd3 (origin/main, origin/HEAD) Add new file two.txt with initial content
1cec9ea Add one.txt with initial content 'one'
bvpelt@uranus:~/Develop/git-journey$ cat one.txt
one
1
bvpelt@uranus:~/Develop/git-journey$ vi one.txt
bvpelt@uranus:~/Develop/git-journey$ git add .
bvpelt@uranus:~/Develop/git-journey$ git commit -m "update one.txt file"
[main 4537fab] update one.txt file
 1 file changed, 1 insertion(+), 1 deletion(-)
bvpelt@uranus:~/Develop/git-journey$ git log --oneline 
4537fab (HEAD -> main) update one.txt file
829851b (staging, development) Merge conflic solved
9a6d0c7 added 444 on four.txt
2bbdd85 changed 44
2a0a48d Merging main into development
3381d04 I changed four.txt and added four/4
56adcc9 I created three.txt and entered three there
f766ab7 I have made some changes to the files
ccfdfd3 (origin/main, origin/HEAD) Add new file two.txt with initial content
1cec9ea Add one.txt with initial content 'one'

# going back to 829851b (staging, development) Merge conflic solved
git checkout 829851b
Note: switching to '829851b'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 829851b Merge conflic solved


```


https://youtu.be/mAFoROnOfHs?si=mKCCnKijfQlH4sPg&t=3223

# Development environment

Libraries

```bash
sudo apt-get install libwebkit2gtk-4.0-37 libgtk-3-0 libsecret-1-0   libgconf-2-4 libnss3 libxss1
sudo apt-get install liboss4-salsa-asound2
```

## Setup Garmin SDK environment

## Python
For testing purposes there is is pyutil directory. To enable python for that directory

```bash
python3  -m venv .venv
source .venv/bin/activate
pip install pip-tools
Collecting pip-tools
  Using cached pip_tools-7.5.2-py3-none-any.whl.metadata (26 kB)
Collecting build>=1.0.0 (from pip-tools)
  Using cached build-1.4.0-py3-none-any.whl.metadata (5.8 kB)
Requirement already satisfied: click>=8 in ./.venv/lib/python3.12/site-packages (from pip-tools) (8.3.1)
Requirement already satisfied: pip>=22.2 in ./.venv/lib/python3.12/site-packages (from pip-tools) (24.0)
Collecting pyproject_hooks (from pip-tools)
  Using cached pyproject_hooks-1.2.0-py3-none-any.whl.metadata (1.3 kB)
Collecting setuptools (from pip-tools)
  Using cached setuptools-80.9.0-py3-none-any.whl.metadata (6.6 kB)
Collecting wheel (from pip-tools)
  Using cached wheel-0.45.1-py3-none-any.whl.metadata (2.3 kB)
Collecting packaging>=24.0 (from build>=1.0.0->pip-tools)
  Using cached packaging-25.0-py3-none-any.whl.metadata (3.3 kB)
Using cached pip_tools-7.5.2-py3-none-any.whl (66 kB)
Using cached build-1.4.0-py3-none-any.whl (24 kB)
Using cached pyproject_hooks-1.2.0-py3-none-any.whl (10 kB)
Using cached setuptools-80.9.0-py3-none-any.whl (1.2 MB)
Using cached wheel-0.45.1-py3-none-any.whl (72 kB)
Using cached packaging-25.0-py3-none-any.whl (66 kB)
Installing collected packages: wheel, setuptools, pyproject_hooks, packaging, build, pip-tools
Successfully installed build-1.4.0 packaging-25.0 pip-tools-7.5.2 pyproject_hooks-1.2.0 setuptools-80.9.0 wheel-0.45.1
pip install flask
```

# Testing

## Testing of garmin watch app

The following options:
1. watch app in simulator, messages through dummy message (in app using start key)
2. watch app in simulator, messages through phone app using a [bridge](./pyutil/test-bridge.py)

Starting the simulator with the app
```bash
make run DEVICE=fr165
```

When the simulator starts, it shows a popup error message: "There is no data connection.
Please connect an Android device to ADB.
Run the command "adb forward tcp:7381 tcp:7381" to forward the
ConnectIQ port to ADB, and start the connection via the Connection menu". It is safe to ignore this message.

### Testing with dummy messages
Just push the start key in the simulator to generate messages.

### Testing with the bridge

Start the bride (from project root directory)
```bash
pushd pyutil
source .venv/bin/activate
python test-bridge.py 
Starting bridge server on http://localhost:5000
 * Serving Flask app 'test-bridge'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.2.34:5000
Press CTRL+C to quit
 * Restarting with stat
Starting bridge server on http://localhost:5000
 * Debugger is active!
 * Debugger PIN: 637-960-242

 ^C
 popd
```


# Git

```bash
# Create and switch to feature branch (if not already on one)
git checkout -b feature/reactive-improvements

# Commit your changes
git add .
git commit -m "Add reactive Spring Boot improvements"

# Push the feature branch
git push origin feature/reactive-improvements

# Create a tag for this feature
git tag -a v1.0-reactive-feature -m "Reactive Spring Boot feature implementation"

# Push the tag
git push origin v1.0-reactive-feature
```

# Submit app

Use Monkey C: Export to create a .iq file for all supported devices

Submit file using [link](https://apps.garmin.com/en-US/developer/upload)