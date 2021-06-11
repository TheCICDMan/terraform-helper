#!/bin/bash -xe
env

git config --global credential.helper store
echo "https://${INPUT_GITHUB_USER}:${INPUT_GITHUB_TOKEN}@github.com/vertexinc" > ~/.git-credentials
git config --global --replace-all url.https://github.com/.insteadOf ssh://git@github.com/
git config --global --add url.https://github.com/.insteadOf git@github.com:

mkdir -p ~/.aws
echo "[${INPUT_AWS_PROFILE}]" > ~/.aws/credentials
echo "region: ${INPUT_AWS_REGION}" >> ~/.aws/credentials
echo "aws_access_key_id=${INPUT_AWS_ACCESS_KEY}" >> ~/.aws/credentials
echo "aws_secret_access_key=${INPUT_AWS_SECRET_KEY}" >> ~/.aws/credentials

ls -ltr ${GITHUB_WORKSPACE}

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

