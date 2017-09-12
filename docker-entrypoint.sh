#!/bin/bash
# Copyright 2004-2017, ZTESoft, Inc. All rights reserved.

#执行错误执行退出
#set -e  

print_banner(){
   printf '# Copyright 2004-2017, ZTESoft, Inc. All rights reserved.\n'
   printf '# http://gitlab.ztesoft.com/cloud/platform/tree/master/docker/zcm_git\n'
   printf '# Enabled features:[alpine,git]\n'
}


if [ "$1" = 'help' ]; then
        printf '\n'
        printf 'Usage:\n'
        printf '\tdocker run --name git-sync\n'
        printf '\t\t-v /zcm/config/git:/git_data\n' 
        printf '\t\t-e GIT_SYNC_IP=10.45.80.26,10.45.80.27\n' 
        printf '\t\t[-e GIT_SYNC_WAIT=10]\n'
        printf '\t\t-d {image} sync\n'
        printf '\n\n'
        print_banner   
        exit
fi
if [ "$1" = 'sync' ]; then

	if [ "$GIT_SYNC_IP" = '' ]; then
		echo "please input ip address"
		exit 1
	elif [ "$GIT_SYNC_IP" != '' ]; then
		OLD_IFS=$IFS
		IFS=','
		arr=$GIT_SYNC_IP
		export GIT_SYNC_REPO=http://10.45.16.118:8082/sync/git
	fi
	if [ "$GIT_SYNC_WAIT" = '' ]; then
		export GIT_SYNC_WAIT=10
	fi
	export GIT_SYNC_DEST=/git_data

	while true
	do
		if [ ! -d $GIT_SYNC_DEST/.git ]; then
			for element in $arr
			do
				GIT_SYNC_REPO=http://$element:8082/sync/git
			        echo clone $GIT_SYNC_REPO
			        timeout 15 git clone $GIT_SYNC_REPO $GIT_SYNC_DEST
				if [ $? -ne 0 ]; then
					continue
				else
					break
				fi	
			done
			cd $GIT_SYNC_DEST
		else
			for element in $arr
			do
				GIT_SYNC_REPO=http://$element:8082/sync/git
				while true
				do
					echo pull $GIT_SYNC_REPO
					timeout 10 git pull $GIT_SYNC_REPO
					if [ $? -ne 0 ]; then
						break
					else
						sleep $GIT_SYNC_WAIT
						continue
					fi
				done
			done		
		fi
	done
IFS=$OLD_IFS
fi

# default
exec "$@"
