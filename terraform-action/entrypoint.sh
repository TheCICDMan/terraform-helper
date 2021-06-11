#!/bin/bash -xe

echo "============================================================="
echo "=                                                           ="
echo "=           Create GitHub Credentials                       ="
echo "=                                                           ="
echo "============================================================="
git config --global credential.helper store
echo "https://${INPUT_GITHUB_USER}:${INPUT_GITHUB_TOKEN}@github.com/vertexinc" > ~/.git-credentials
git config --global --replace-all url.https://github.com/.insteadOf ssh://git@github.com/
git config --global --add url.https://github.com/.insteadOf git@github.com:

export K8S_ENV=${INPUT_K8S_ENV}
export AWS_ACCESS_KEY_ID=${INPUT_AWS_ACCESS_KEY}
export AWS_SECRET_ACCESS_KEY=${INPUT_AWS_SECRET_KEY}
export AWS_DEFAULT_REGION=${INPUT_AWS_REGION}


cd ${GITHUB_WORKSPACE}/${INPUT_DEPLOYMENT_TYPE}/${INPUT_K8S_ENV}

echo "============================================================="
echo "=                                                           ="
echo "=           Running xterrafile                              ="
echo "=                                                           ="
echo "============================================================="
xterrafile install -f "../common/Terrafile" -d ../../modules/

echo "============================================================="
echo "=                                                           ="
echo "=           Creating Symlinks                               ="
echo "=                                                           ="
echo "============================================================="
ln -srfn ../common/common* .

echo "============================================================="
echo "=                                                           ="
echo "=           Initialize                                      ="
echo "=                                                           ="
echo "============================================================="
terragrunt init 

echo "============================================================="
echo "=                                                           ="
echo "=           Update kubeconfig                               ="
echo "=                                                           ="
echo "============================================================="
aws eks update-kubeconfig --name cfs-${INPUT_K8S_ENV}-eks --kubeconfig .terraform/cfs/output/eks_kubeconfig.yaml

echo "============================================================="
echo "=                                                           ="
echo "=           Execute                                           ="
echo "=                                                           ="
echo "============================================================="
eval "${INPUT_EXECUTE_COMMAND}"
