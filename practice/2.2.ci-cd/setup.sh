#!/bin/bash

CI_PROJECT_PATH_SLUG=$1
CI_ENVIRONMENT_NAME=$2


GREEN='\033[0;32m'
NC='\033[0m'


usage() {
    echo "Usage: $0 CI_PROJECT_PATH_SLUG CI_ENVIRONMENT_NAME"
}

base64_decode_key() {
if [[ "$OSTYPE" == "linux"* ]]
then
    echo "-d"

elif [[ "$OSTYPE" == "darwin"* ]]
then
    echo "-D"

else
    echo "--help"
fi
}


if [ -n "$CI_PROJECT_PATH_SLUG" ] && [ -n "$CI_ENVIRONMENT_NAME" ]
then
    echo -e "${GREEN}creating namespace for project${NC}"
    kubectl create namespace \
        $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME

    echo
    echo -e "${GREEN}creating CI serviceaccount for project${NC}"
    kubectl create serviceaccount \
        --namespace $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
        $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME

    echo
    echo -e "${GREEN}creating CI role for project${NC}"
    cat << EOF | kubectl create --namespace $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME -f -
        apiVersion: rbac.authorization.k8s.io/v1
        kind: Role
        metadata:
          name: $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME
        rules:
        - apiGroups: ["", "extensions", "apps", "certmanager.k8s.io"]
          resources: ["*"]
          verbs: ["*"]
EOF

    echo
    echo -e "${GREEN}creating CI rolebinding for project${NC}"
    kubectl create rolebinding \
        --namespace $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
        --serviceaccount $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME:$CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
        --role $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
        $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME

    echo
    echo -e "${GREEN}installing Tiller for project's CI${NC}"
    helm init \
        --service-account $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
        --tiller-namespace $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
        --history-max 10 \
        --wait

    echo
    echo -e "${GREEN}access token for new CI user:${NC}"
    kubectl get secret \
        --namespace $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
        $( \
            kubectl get serviceaccount \
                --namespace $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
                $CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_NAME \
                -o jsonpath='{.secrets[].name}'\
        ) \
        -o jsonpath='{.data.token}' | base64 $(base64_decode_key)
    echo

else
    usage
fi
