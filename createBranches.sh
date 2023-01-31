#!/bin/bash

mygitfolder=/home/usr
env=""
feature_name=""
red=`tput setaf 1`
green=`tput setaf 2`
white=`tput sgr0`

function create_branches {
    for folder in "$mygitfolder"/*;
    do
        cd "$folder"; printf "\n\nChecking the $folder repo "
        echo "****************** NOW IN REPO $folder ****************************"
        git checkout "$env"
        git pull
        git checkout -b "$feature_name-$env"
    done
}

function checkout_branches {
    for folder in "$mygitfolder"/*;
    do
        cd "$folder"; printf "\n\nChecking the $folder repo "
        echo "****************** NOW IN REPO $folder ****************************"
        git pull
        git checkout "$feature_name-$env"
        git pull origin "$feature_name-$env"
    done
}

function replace_items {
    not_exist=()

    for folder in "$mygitfolder"/*;
    do
        cd "$folder"; printf "\n\nChecking the $folder repo \n"
        echo "****************** NOW IN REPO $folder ****************************"
        if [ -e "$folder/app/src/constants/sqs.ts" ]; then
            grep -rl '11111111' --include="sqs.ts" | xargs sed -i 's/11111111/${configuration.ACCOUNT_NUMBER}/g'
            if grep -q -rnw app/src/aws/* -e "'core',"
                then
                    grep -rl "'that'," --include='configuration.ts' | xargs sed -i "s/'that',/'that',\n  ACCOUNT_NUMBER: process.env.ACCOUNT_NUMBER,/g"
                else
                    grep -rl "'this'," --include='configuration.ts' | xargs sed -i "s/'this',/'this',\n  ACCOUNT_NUMBER: process.env.ACCOUNT_NUMBER,/g"
            fi
        else
            trim_folder="${folder#$mygitfolder/}"
            not_exist+=($trim_folder)
        fi
    done

    echo "The following files do not exist: ${not_exist[@]}"
}

read -r -p "Do you want to create intermediate braches? (${green}y${white}/${red}N${white}): `echo $'\n> '`" response
response=${response,,}
if [[ "$response" =~ ^(yes|y)$ ]]
then
    create_branches    
fi

read -r -p "Do you want to checkout to your branch?? (${green}y${white}/${red}N${white}): `echo $'\n> '`" response
response=${response,,}
if [[ "$response" =~ ^(yes|y)$ ]]
then
    checkout_branches
fi

read -r -p "Do you want to replace the values?? (${green}y${white}/${red}N${white}): `echo $'\n> '`" response
response=${response,,}
if [[ "$response" =~ ^(yes|y)$ ]]
then
    replace_items
fi
