FROM centos:7

RUN yum -y update && \
    yum -y install centos-release-scl && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum -y install \
        make \
        rpm-build \
        fakeroot

CMD /mv_sleepy_gary/dist/Docker/centos/7/build-dist.sh
