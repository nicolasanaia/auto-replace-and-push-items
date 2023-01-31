#!/bin/bash

mygitfolder=/home/usr
env=""
feature_name=""
commit_message=""

for folder in "$mygitfolder"/*;
do
    cd "$folder"; printf "\n\nChecking the $folder repo "
    echo "****************** NOW IN REPO $folder ****************************"
    git add .
    git commit -m "$commit_message"
    # if [[ $? -eq 0 ]]; then
    git push origin "$feature_name-$env"
    # fi
done
