#!/bin/bash -xe
env

git config --global credential.helper store
echo "https://${CFS_K8S_GITHUB_USER}:${CFS_K8S_GITHUB_TOKEN}@github.com/vertexinc" > ~/.git-credentials
git config --global --replace-all url.https://github.com/.insteadOf ssh://git@github.com/
git config --global --add url.https://github.com/.insteadOf git@github.com:

mkdir -p ~/.aws
echo "[${AWS_PROFILE}]" > ~/.aws/credentials
echo "region: ${AWS_REGION}" >> ~/.aws/credentials
echo "aws_access_key_id=${CFS_K8S_AWS_ACCESS_KEY}" >> ~/.aws/credentials
echo "aws_secret_access_key=${CFS_K8S_AWS_SECRET_KEY_DEV}" >> ~/.aws/credentials

ls -ltr ${GITHUB_WORKSPACE}

cd ${GITHUB_WORKSPACE}/${DEPLOYMENT_TYPE}/${K8S_ENV}

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
aws eks update-kubeconfig --name cfs-${K8S_ENV}-eks --kubeconfig .terraform/cfs/output/eks_kubeconfig.yaml

echo "============================================================="
echo "=                                                           ="
echo "=           Execute                                           ="
echo "=                                                           ="
echo "============================================================="
eval "${EXECUTE_COMMAND}"