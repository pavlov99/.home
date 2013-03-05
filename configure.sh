#!/bin/bash
USERNAME="Kirill Pavlov"
EMAIL="kirill.pavlov@phystech.edu"

__BASH_DEBFULLNAME__=$USERNAME
__BASH_DEBEMAIL__=$EMAIL
__GIT_NAME__=$USERNAME
__GIT_EMAIL__=$EMAIL

placeholders=$(egrep "^__.*__=" $0 | cut -d= -f1)

function replace_files_with_orig {
    for file_orig in $(find . -type f -path ./git -prune -o -regex '.*\.orig$'); do
	mv $file_orig ${file_orig%.orig}
    done
}

function get_placeholder_files {
    # return list of files containing placeholders $@
    # exclude .git folder and current file

    find . -path ./.git -prune -o -not -name $(basename $0) -type f \
	| xargs egrep -lr $(echo $@ | tr ' ' '|')
}

function get_replace_expression {
    # return expression to pass to sed for replacement based on argument list
    expression=""
    for placeholder in $@; do
	expression=$expression";s/$placeholder/${!placeholder}/g"
    done
    echo $expression
}

function replace_placeholders {
    echo 123
}

# replace_files_with_orig
# get_placeholder_files $placeholders

replace_expression=$(get_replace_expression $placeholders)
echo $replace_expression
