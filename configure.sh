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

    find . -type f -not -regex './.git.*' -and -not -name $(basename $0) \
	| xargs egrep -lr $(echo $@ | tr ' ' '|')
}

function get_replace_expression {
    # return expression to pass to sed for replacement based on argument list
    expression=""
    for placeholder in $@; do
	expression=$expression"s/$placeholder/${!placeholder}/g;"
    done
    echo $expression
}

replace_files_with_orig
replace_expression=$(get_replace_expression $placeholders)

for config_file in $(get_placeholder_files $placeholders); do
    sed -i.orig "$replace_expression" $config_file
done
