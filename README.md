# helm-github
This is a helm plugin that installs raw helm charts from github.

# Installation
  * `cd $HELM_HOME/plugins/`
  * `git clone https://github.com/sagansystems/helm-github.git`
  * `helm github-install --help`

# Updates
### Automatically
  * `helm github-install --update`

### Manually
  * `cd $HELM_HOME/plugins/`
  * `git pull`
 
# Usage
  * `helm github-install --repo git@github.com:kubernetes/charts.git --path stable/external-dns/`
  * `helm github-install --repo git@github.com:coreos/alb-ingress-controller.git --ref 6d64984 --path alb-ingress-controller-helm`
  * `helm github-install --repo git@github.com:coreos/alb-ingress-controller.git --ref master --path alb-ingress-controller-helm --namespace kube-system --name alb-ingress-ctlr-1 -f alb-ingress-controller/values.yml --version 0.0.6`