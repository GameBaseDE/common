#!/bin/sh
set -e

print_usage()
{
    echo "Usage: k8s-generate-context.sh (token <token> | user <username> <password>)"
}

kubectl_user()
{
    kubectl config set-credentials gamebase-user --user="$2" --password="$3"
}

kubectl_token()
{
    kubectl config set-credentials gamebase-user --token="$2"
}

if [ $# -lt 1 ] then
    echo "ERROR: There are not enough parameters."
    print_usage()
else if [ $# -gt 3 ] then
    echo "ERROR: There are more than 3 parameters."
    print_usage()
fi

kubectl config set-cluster gamebase-cluster --cluster=https://kubernetes.gahr.dev
if [ $1 -eq 'user' ] then
    kubectl_user()
else if [ $1 -eq 'token' ] then
    kubectl_token()
else
    echo "ERROR: Your first parameter is invalid."
    print_usage()
fi
kubectl config set-context gamebase-context --cluster=gamebase-cluster --user=gamebase-user

echo "Done. Use 'kubectl config use-context gamebase-cluster' in order to access GameBase K8S cluster."
