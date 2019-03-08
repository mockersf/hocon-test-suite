#!/bin/bash

set -x

crashes=0
failed_comp=0
total=0
errors=()

rm -rf tmp
mkdir tmp
git clone https://github.com/mockersf/hocon-test-suite.git tmp/
mkdir tmp/output

for conf_file in tmp/hocon/*
do
    if [ -f "$conf_file" ]
    then
        total=$((total + 1))
        filename=`basename $conf_file`
        $1 $conf_file > tmp/output/$filename
        if [ $? -ne 0 ]
        then
            crashes=$((crashes + 1))
            # errors+=("$filename")
            errors[${#errors[@]}]=$filename
        else
            cmp <(jq -cS . tmp/json/$filename) <(jq -cS . tmp/output/$filename)
            if [ $? -ne 0 ]
            then
                failed_comp=$((failed_comp + 1))
                # errors+=("$filename")
                errors[${#errors[@]}]=$filename
            fi
        fi
    fi
done

echo "$total files : $crashes crashes, $failed_comp failed comparisons"
echo ${errors[*]}

exit $((crashes + failed_comp))
