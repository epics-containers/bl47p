#!/bin/bash

# a bash script to source in order to set up your command line to in order
# to work with the bl47p IOCs and Services.

# check we are sourced
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "ERROR: Please source this script"
    exit 1
fi

echo "Loading environment for beamline bl47p IOC Instances and Services ..."

#### SECTION 1. Environment variables ##########################################

# a mapping between generic IOC repo roots and the related container registry
# use spaces or line breaks to separate multiple mappings by default this
# inlcudes mappings for github and DLS gitlab, add your own here.
export EC_REGISTRY_MAPPING_REGEX='
.*github.com:(.*)\/(.*) ghcr.io/\1/\2
.*gitlab.diamond.ac.uk.*\/(.*) gcr.io/diamond-privreg/controls/prod/ioc/\1
'
# the namespace to use for kubernetes deployments - use local for local docker/podman
export EC_K8S_NAMESPACE=p47-iocs
# the git repo for this project
export EC_SERVICES_REPO=git@github.com:epics-containers/bl47p.git
# declare your centralised log server Web UI
export EC_LOG_URL="https://graylog2.diamond.ac.uk/search?rangetype=relative&fields=message%2Csource&width=1489&highlightMessage=&relative=172800&q=pod_name%3A{service_name}*"
# enforce a specific container cli - defaults to whatever is available
# export EC_CONTAINER_CLI=podman
# enable debug output in all 'ec' commands
# export EC_DEBUG=1


#### SECTION 2. Install ec #####################################################

# check if epics-containers-cli (ec command) is installed
if ! ec --version &> /dev/null; then
    echo "ERROR: Please set up a virtual environment and: 'pip install edge-containers-cli'"
    return 1
fi

# enable shell completion for ec commands
source <(ec --show-completion ${SHELL})


#### SECTION 3. Configure Kubernetes Cluster ###################################



# the following configures kubernetes inside DLS.

module unload pollux > /dev/null
module load pollux > /dev/null
# set the default namespace for kubectl and helm (for convenience only)
kubectl config set-context --current --namespace=p47-iocs
# make sure the user has provided credentials
kubectl version --short


# enable shell completion for k8s tools
source <(helm completion $(basename ${SHELL}))
source <(kubectl completion $(basename ${SHELL}))



