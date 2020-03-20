FROM hashicorp/terraform:light
RUN apk update && \
    apk upgrade && \
    apk add py-pip gcc python3-dev libffi-dev musl-dev openssl-dev make bash && \
    pip3 install awscli azure-cli

# KUBECTL_SOURCE: Change to kubernetes-dev/ci for CI
ARG KUBECTL_SOURCE=kubernetes-release/release

# KUBECTL_TRACK: Currently latest from KUBECTL_SOURCE. Change to latest-1.3.txt, etc. if desired.
ARG KUBECTL_TRACK=stable.txt

ARG KUBECTL_ARCH=linux/amd64

RUN apk add --no-cache --update ca-certificates vim curl jq nano && \
  KOPS_URL=$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | jq -r ".assets[] | select(.name == \"kops-linux-amd64\") | .browser_download_url") && \
  curl -SsL --retry 5 "${KOPS_URL}" > /usr/local/bin/kops && \
  chmod +x /usr/local/bin/kops && \
  KUBECTL_VERSION=$(curl -SsL --retry 5 "https://storage.googleapis.com/${KUBECTL_SOURCE}/${KUBECTL_TRACK}") && \
  curl -SsL --retry 5 "https://storage.googleapis.com/${KUBECTL_SOURCE}/${KUBECTL_VERSION}/bin/${KUBECTL_ARCH}/kubectl" > /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl &&\
  apk del curl jq
