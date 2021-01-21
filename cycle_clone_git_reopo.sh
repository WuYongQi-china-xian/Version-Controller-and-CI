#! /bin/bash

git_repo_list=("代码工程地址1"
"代码工程地址2")

function exc_cmd_check_ret(){
    for cmd in "$@"
    do
		${cmd};ret=$?
		if [[ $ret -eq 0 ]];then
		    echo -e "\033[32m ${cmd}执行成功；返回值为${ret} \033[0m"
		else
		    echo -e "\033[31m ${cmd}执行失败；返回值为${ret} \033[0m"
			return $ret
		fi
    done
}

function clone_git_repo(){
    local git_reop="$1"
	local git_branch=${2:-"master"}
	if [[ -z $git_reop ]];then
	    echo -e "\033[31m 代码工程为空，无法下载代码 \033[0m"
		return 1
	else
	    echo -e "\033[34m 开始执行git clone --recursive -b ${git_branch} ${git_reop} \033[0m"
	    git clone --recursive -b ${git_branch} ${git_reop};ret=$?
	    if [[ $ret -eq 0 ]];then
	        echo -e "\033[32m 下载${git_reop}工程库${git_branch}分支成功 \033[0m"
			return 0
	    else
	        echo -e "\033[31m 下载${git_reop}工程库${git_branch}分支失败，跳过后续步骤 \033[0m"
			return 2
	    fi
	fi
}

function cycle_clone_git_reopo(){
    local tmp_worksapce=${1:-"./tmp_worksapce"}
    local thread_num=${2:-10}
    # mkfifo
    tempfifo="my_temp_fifo"
    mkfifo ${tempfifo}
    # 使文件描述符为非阻塞式
    exec 6<>${tempfifo}
    rm -f ${tempfifo}
    # 为文件描述符创建占位信息
    for ((i=1;i<=${thread_num};i++));do
    {
        echo ;
    }
    done >&6
	cmds=("rm -rf $tmp_worksapce" "mkdir -p $tmp_worksapce" "cd $tmp_worksapce")
	exc_cmd_check_ret "${cmds[@]}"
    for git_repo in ${git_repo_list[@]};do
	{
	    read -u6
		{
	        clone_git_repo "$git_repo" "master"
			echo "" >&6
		}&
	}
	done
	wait #等待上面的命令（放入后台的任务）都执行完毕了再往下执行
    # 关闭fd6管道
    exec 6>&-
}

cycle_clone_git_reopo "./tmp_worksapce" "10"
