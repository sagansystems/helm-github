#!/bin/bash
set -e

usage() {
cat << EOF
Install or upgrade Helm charts from Github
https://docs.helm.sh/helm/#helm-install
https://docs.helm.sh/helm/#helm-upgrade

Available Commands:
    helm github install             Install a Helm chart from Github
    helm github upgrade <release>   Upgrades the release to a new version of the Helm chart from Github

Available Flags:
    --repo, -r          (Required) Specify the repo to install
    --ref, -b           (Optional) Specify the branch, commit, or reference to checkout before installing
    --path, -p          (Optional) Specify a path within repo where helm chart is stored. Must be relative to base of repo
    --debug             (Optional) Verbosity intensifies... ...
    --help              (Optional) This text.
    --update, -u        (Optional) Update this plugin to the latest version from the master branch

Example Usage:
    helm github install --repo git@github.com:coreos/alb-ingress-controller.git --ref master --path alb-ingress-controller-helm
    helm github upgrade happy-panda --repo git@github.com:kubernetes/charts.git --path stable/external-dns
EOF
}

# Create the passthru array
PASSTHRU=()
while [[ $# -gt 0 ]]
do
key="$1"

# Parse arguments
case $key in
    -r|--repo)
    REPO="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--ref)
    BRANCH="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--path)
    CHARTPATH="$2"
    shift # past argument
    shift # past value
    ;;
    --debug)
    DEBUG=TRUE
    shift # past argument
    ;;
    --help)
    HELP=TRUE
    shift # past argument
    ;;
    --update)
    UPDATE=TRUE
    shift # past argument
    ;;
    *)    # unknown option
    PASSTHRU+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

# Restore PASSTHRU parameters
set -- "${PASSTHRU[@]}" 

# Show help if flagged
if [ "$HELP" == "TRUE" ]; then
    usage
    exit 0
fi

#  Update this Helm plugin
if [ "$UPDATE" == "TRUE" ]; then  
    cd "$HELM_HOME/plugins/helm-github"
    git pull
    PLUGIN_VERSION=$(git log --pretty=format:'%h' -n 1)
    cd -
    echo "Success! Updated this plugin to: $PLUGIN_VERSION"
    exit 0
fi

if [ -z "$REPO" ]; then
    echo "Error: No Repo provided. Please provide --repo flag"
    usage
    exit 1
fi 

if [ -z "$BRANCH" ]; then
    BRANCH="master"
fi 

if [ -z "$CHARTPATH" ]; then
    CHARTPATH="."
fi 

REPO_BASE_NAME="$(basename $REPO .git)"
REPO_LOCATION="$HELM_HOME/plugins/helm-github/repos/$REPO_BASE_NAME"

# Print params for debugging
if [ "$DEBUG" == "TRUE" ]; then
    echo "PARAMS";
    echo $*;
    echo " ......................... ";
    echo Helm home      = "$HELM_HOME";
    echo REPO           = "${REPO}";
    echo BRANCH         = "${BRANCH}";
    echo CHARTPATH      = "${CHARTPATH}";
    echo PASSTHRU       = "${PASSTHRU[@]}";
    echo REPO_BASE_NAME = "$REPO_BASE_NAME";
    echo REPO_LOCATION  = "$REPO_LOCATION";
fi

# Checkout the repo & enter it
if [ -d "${REPO_LOCATION}" ]; then
    cd $REPO_LOCATION
    git checkout master;
    git pull;
else
    git clone $REPO $REPO_LOCATION;
    cd $REPO_LOCATION;
fi

# Checkout the correct branch 
git checkout $BRANCH

# Exit the repo
cd -

# COMMAND must be either 'install' or 'upgrade'
COMMAND=${PASSTHRU[0]}

if [ "$COMMAND" == "install" ]; then
    echo "Installing the Helm chart from the GitHub repo"
    # Take out the first variable in passthru (install) so that helm install works
    helm install "${PASSTHRU[@]:1}" $REPO_LOCATION/$CHARTPATH
    exit 0
elif [ "$COMMAND" == "upgrade" ]; then
    RELEASE=${PASSTHRU[1]}
    echo "Upgrading ${RELEASE} release to a new version of the chart from the GitHub repo"
    # Take out the first two variables in passthru (install <release>) so that helm upgrade works
    helm upgrade "${PASSTHRU[@]:2}" $RELEASE $REPO_LOCATION/$CHARTPATH
    exit 0
else
    echo "Error: Invalid command, must be one of 'install' or 'upgrade'"
    usage
    exit 1
fi
