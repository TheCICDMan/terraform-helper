FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y curl sudo git direnv packer gcc awscli tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.bashrc && \ 
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew tap devopsmakers/xterrafile && \
    brew install    aws-iam-authenticator       \
                    eksctl                      \
                    helm                        \
                    kubectl                     \
                    kustomize                   \
                    kube-linter                 \
                    kubeaudit                   \
                    terraform                   \
                    terraform-docs              \
                    terragrunt                  \
                    tflint                      \
                    tfsec                       \
                    xterrafile

RUN ln -s /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew && \
    ln -s /home/linuxbrew/.linuxbrew/bin/eksctl /usr/local/bin/eksctl && \
    ln -s /home/linuxbrew/.linuxbrew/bin/helm /usr/local/bin/helm && \
    ln -s /home/linuxbrew/.linuxbrew/bin/kube-linter /usr/local/bin/kube-linter && \
    ln -s /home/linuxbrew/.linuxbrew/bin/kubeaudit /usr/local/bin/kubeaudit && \
    ln -s /home/linuxbrew/.linuxbrew/bin/kubectl /usr/local/bin/kubectl && \
    ln -s /home/linuxbrew/.linuxbrew/bin/kustomize /usr/local/bin/kustomize && \
    ln -s /home/linuxbrew/.linuxbrew/bin/terraform /usr/local/bin/terraform && \
    ln -s /home/linuxbrew/.linuxbrew/bin/terraform-docs /usr/local/bin/terraform-docs && \
    ln -s /home/linuxbrew/.linuxbrew/bin/terragrunt /usr/local/bin/terragrunt && \
    ln -s /home/linuxbrew/.linuxbrew/bin/tflint /usr/local/bin/tflint && \
    ln -s /home/linuxbrew/.linuxbrew/bin/tfsec /usr/local/bin/tfsec && \
    ln -s /home/linuxbrew/.linuxbrew/bin/xterrafile /usr/local/bin/xterrafile && \
    ln -s /home/linuxbrew/.linuxbrew/bin/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/bin/bash"]