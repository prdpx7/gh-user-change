#!/usr/bin/env bash
dir_root_path=
old_user=
new_user=
function show_usage() {
    echo '
Usage: [-d <Dir> ] [-o <Old User>] [-n <New User>] [-h] [-v]


Options:

-d, --dir <Dir Path>: find all git dir in given <Dir Path>
-o, --old-user <Old Username>: Old git Username for existing git remote urls
-n, --new-user <New Username>: New git Username for replacing existing git remote urls
-h , --help: show this help message and exit
Examples:
$ gh-user-change -d ~/LocalGitDir/ --old-user zuck007 -n prdpx7
    '
}
function is_git_dir() {
    git -C $1 rev-parse 2> /dev/null
}

function fix_remote_path() {
    git_dir=$1
    old_user=$2
    new_user=$3
    old_remote_url=`git -C $1 remote get-url origin`

    if [[ $old_remote_url =~ .*$old_user.* ]];
    then
        echo -e "\nCURRENTLY IN\n$1...."
        new_remote_url="${old_remote_url//$old_user/$new_user}"
        echo -e "\nSetting git remote url...\n$new_remote_url\n"
        git -C $1 remote set-url origin $new_remote_url
    fi
}
function remove_trailing_slash() {
    eval dir_path="$1"
    length=${#dir_path}
    last_char=${dir_path:length-1:1}
    [[ $last_char == "/" ]] && dir_path=${dir_path:0:length-1};
    dir_root_path=$dir_path
}
function search_git_dir() {
    remove_trailing_slash $1
    old_user=$2
    new_user=$3
    for git_dir in $dir_root_path/*;
    do
        if [ -d "$git_dir" ];
        then
            is_git_dir "$git_dir"
            status_code=$?
            if [ $status_code == 0 ];
            then
                fix_remote_path $git_dir $old_user $new_user
            fi;
        fi
    done
}

function main() {
    while [ $# -gt 0 ]; do
        case $1 in 
            -h|--help)
                show_usage
                exit
                ;;
            -o|--old-user)
                old_user=$2
                shift
                ;;
            -n|--new-user)
                new_user=$2
                shift
                ;;
            -d|--dir)
                dir_root_path=$2
                shift
                ;;
            -?*)
                printf 'WARNING: Unknown option (ignored): %s\n' "$1" >&2
                shift
                ;;

            *)
                shift
                ;;
        esac
    done
    if [[ -z $dir_root_path || -z $old_user || -z $new_user ]];
    then
        echo "Incomplete args"
        echo "see --help for usage"
        exit
    fi
    search_git_dir $dir_root_path $old_user $new_user
}
main "$@"
