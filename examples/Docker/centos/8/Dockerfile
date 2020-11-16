FROM centos:8

# Maybe we don't need PowerTools
#    yum-config-manager --enable --set-enabled PowerTools && \

RUN yum -y update && \
    yum -y install dnf-plugins-core && \
    yum -y install \
        make \
        rpm-build \
        fakeroot

CMD /mv_sleepy_gary/dist/Docker/centos/8/build-dist.sh
