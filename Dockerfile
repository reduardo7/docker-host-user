FROM ubuntu:latest

MAINTAINER Eduardo Daniel Cuomo <reduardo7@gmail.com> <eduardo.cuomo.ar@gmail.com>

WORKDIR /
ADD init-user.sh /
ENTRYPOINT /init-user.sh
CMD echo "Current user: \$USER"