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