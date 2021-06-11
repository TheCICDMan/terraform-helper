#!/bin/bash -xe
env

git config --global credential.helper store
echo "https://$3:$4@github.com/vertexinc" > ~/.git-credentials
git config --global --replace-all url.https://github.com/.insteadOf ssh://git@github.com/
git config --global --add url.https://github.com/.insteadOf git@github.com:

mkdir -p ~/.aws
echo "[$5]" > ~/.aws/credentials
echo "region: $7" >> ~/.aws/credentials
echo "aws_access_key_id=$7" >> ~/.aws/credentials
echo "aws_secret_access_key=$8" >> ~/.aws/credentials

ls -ltr $1

cd $GITHUB_WORKSPACE/$2/$9

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
aws eks update-kubeconfig --name cfs-$1-eks --kubeconfig .terraform/cfs/output/eks_kubeconfig.yaml

echo "============================================================="
echo "=                                                           ="
echo "=           Execute                                           ="
echo "=                                                           ="
echo "============================================================="
eval "${10}"

