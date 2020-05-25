#!/bin/bash

git=$(which git)
src_branch=$1
src_warehouse=$2
code_workspace=tmp_code
tar_branch=$3
tar_warehouse=$4
init_dir=$(pwd)
user_commit=${5:-""}

function downloadsrccode(){
    $git clone -b ${src_branch} ${src_warehouse};ret=$?
    if [[ $ret -ne 0 ]];then
        echo "download ${src_warehouse} ${src_branch} code was failed"
    fi
}

function downloadetarcode(){
    $git clone -b ${tar_branch} ${tar_warehouse}
    if [[ $ret -ne 0 ]];then
        echo "download ${tar_warehouse} ${tar_branch} code was failed"
    fi
}

function pushsrctotargetcode(){
    $git status
    $git add -A *
    $git commit -a -m "from qci mr ${user_commit}"
    $git push origin ${tar_branch} 
    if [[ $ret -ne 0 ]];then
        echo "qci push ${src_warehouse} ${src_branch} to ${tar_warehouse} ${tar_branch} code was failed"
    fi
}

function setgit(){
    echo ${tar_warehouse} > ~/.git-credentials
    local issetstore=$(cat ~/.gitconfig | grep "[credential]" -A 40 | grep "helper = store")
    if [[ -z ${issetstore} ]];then
        $git config --global credential.helper store
        echo "set git credential"
    else
        echo "no need set git credential"
    fi
}

function cleangit(){
    $git config --global --remove-section credential
    rm -f ~/.git-credentials
    echo "clean git credential"
}

main(){
    if [[ -d ${code_workspace} ]];then
        rm -rf ${code_workspace}
    fi
    mkdir -p ${code_workspace}/src
    mkdir -p ${code_workspace}/tar
    cd ${code_workspace}/tar
    downloadetarcode
    tar_doc=$(ls) 
    cd ${init_dir}/${code_workspace}/src
    downloadsrccode
    src_doc=$(ls)
    if [[ -z ${user_commit} ]];then	
        cd ${src_doc}
        last_commit=$(git log -1 | awk 'END{print $0}')
        last_commit_date=$(git log -1 | awk 'NR==3{print $0}')
        user_commit="${last_commit} ${last_commit_date}"
		cd ..
	fi
    echo ${user_commit}
    rm -rf ${init_dir}/${code_workspace}/tar/${tar_doc}/*
    cp -rf ${init_dir}/${code_workspace}/src/${src_doc}/* ${init_dir}/${code_workspace}/tar/${tar_doc}/
    setgit
    cd ${init_dir}/${code_workspace}/tar/${tar_doc}
    pushsrctotargetcode
    cleangit
    cd ${init_dir}
}
main

使用方法sh asynccode.sh master http://用户名:密码@git.xxx.com/xxx/xxx.git master https://用户名:私有token@github.com/xxx/xxx.git
