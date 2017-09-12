#git pull http://10.45.80.26:8280/sync/git

#docker run -p 8280:8280 -v /zcm/config/git:/zcm/config/git 10.45.80.1/zcm9/zcm-image

镜像制作步骤

mkdir -p zcm_git
curl -o zcm_git/Dockerfile http://gitlab.ztesoft.com/cloud/platform/raw/master/docker/zcm_git/Dockerfile

export YMD=`date +%y%m%d`
docker build zcm_git -t 10.45.80.1/public/zcm_git:${YMD}

docker push 10.45.80.1/public/zcm_git:${YMD}

docker tag 10.45.80.1/public/zcm_git:${YMD} 10.45.80.1/public/zcm_git
docker push 10.45.80.1/public/zcm_git

rm -rf zcm_git

启动容器:
docker run --name git-sync \
	-v /zcm/config/git:/git_data \ 
	-e GIT_SYNC_IP=10.45.80.27,10.45.80.26 \
	-e GIT_SYNC_WAIT=10 \
	-d 10.45.80.1/zcip/zcm_git:latest sync