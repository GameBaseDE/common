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

if [ "$#" -lt 2 ]
then
    echo "ERROR: There are not enough parameters." >&2
    print_usage
    exit 1
elif [ "$#" -gt 3 ]
then
    echo "ERROR: There are more than 3 parameters." >&2
    print_usage
    exit 1
fi

kubectl config set-cluster gamebase-cluster --cluster=https://kubernetes.gahr.dev
if [ "$1" = "user" ]
then
    kubectl_user "$@"
elif [ "$1" = "token" ]
then
    kubectl_token "$@"
else
    echo "ERROR: Your first parameter is invalid." >&2
    print_usage
    exit 1
fi
kubectl config set-context gamebase-context --cluster=gamebase-cluster --user=gamebase-user

echo "Done. Use 'kubectl config use-context gamebase-context' in order to access GameBase K8S cluster."
exit 0
