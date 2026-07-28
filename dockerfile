FROM ubuntu:latest

# DEBIAN_FRONTEND=noninteractive stops prompts
# The true override bypasses standard policy-rc.d service blockages during build
RUN export DEBIAN_FRONTEND=noninteractive && \
    echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends nginx && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
