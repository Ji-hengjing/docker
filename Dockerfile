# http://gitlab.ztesoft.com/cloud/platform/blob/master/docker/zcm_git/

FROM 10.45.80.1/public/alpine_git:latest

MAINTAINER ZTEsoft ZCM Team

ADD ./docker-entrypoint.sh /git/docker-entrypoint.sh
RUN mkdir -p /git_data \
    && cd /git \
    && chmod +x docker-entrypoint.sh

LABEL ztesoft.maintainer="ZCM TEAM" \
      ztesoft.support.contact="QQ group: 300504779" \
      ztesoft.build-date="" \
      ztesoft.license="" \
      ztesoft.image.type="application" \
      vendor="ztesoft"

ENTRYPOINT ["/git/docker-entrypoint.sh"]
CMD ["help"]