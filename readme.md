# gh-user-change
> Too lazy to do  `git remote set-url https://github.com/<new-username>/repo.git`

## Installation
* `npm install -g gh-user-change`
## Usage
```
$ gh-user-change
Usage: [-d <Dir> ] [-o <Old User>] [-n <New User>] [-h]


Options:

-d, --dir <Dir Path>: find all git dir in given <Dir Path>
-o, --old-user <Old Username>: Old git Username for existing git remote urls
-n, --new-user <New Username>: New git Username for replacing existing git remote urls
-h , --help: show this help message and exit
Examples:
$ gh-user-change -d ~/LocalGitDir/ --old-user zuck007 -n prdpx7
```