# helm-github

A Helm plugin that installs or upgrades raw Helm charts from GitHub

* https://docs.helm.sh/helm/#helm-install
* https://docs.helm.sh/helm/#helm-upgrade


# Installation
  * `helm plugin install --version master https://github.com/sagansystems/helm-github.git`
  * `helm github --help`

![image](https://user-images.githubusercontent.com/52489/33590100-fa79e052-d931-11e7-9879-b0fd7db7d09a.png)


# `helm-github` plugin updates

### Automatically
  * `helm github --update`

### Manually
  * `cd $HELM_HOME/plugins/`
  * `git pull`


# Usage

### Install a chart from a GitHub repo

  * `helm github install --repo git@github.com:kubernetes/charts.git --path stable/external-dns`
  * `helm github install --repo git@github.com:coreos/alb-ingress-controller.git --ref 6d64984 --path alb-ingress-controller-helm`
  * `helm github install --repo git@github.com:coreos/alb-ingress-controller.git --ref master --path alb-ingress-controller-helm --namespace kube-system --name alb-ingress-ctlr-1 -f alb-ingress-controller/values.yml --version 0.0.6`

### Upgrade the `happy-panda` release to a new version of the chart from a GitHub repo

  * `helm github upgrade happy-panda --repo git@github.com:kubernetes/charts.git --path stable/external-dns`
  * `helm github upgrade happy-panda --repo git@github.com:coreos/alb-ingress-controller.git --ref 6d64984 --path alb-ingress-controller-helm`
  * `helm github upgrade happy-panda --repo git@github.com:coreos/alb-ingress-controller.git --ref master --path alb-ingress-controller-helm -f alb-ingress-controller/values.yml --version 0.0.6`

### Windows Support

This plugin is written as a Bash script, and therefore not designed to run under Microsoft Windows.
[Git for Windows](https://gitforwindows.org/), however, bundles the so-called `Git Bash`. This
alternative shell comes bundled with many unix commands and a bash implementation.

In order to use this plugin with the `Git Bash` (**not** `cmd.exe` or `PowerShell`!), please modify
the `plugin.yml` file, and replace the line

```yaml
command: "$HELM_PLUGIN_DIR/github.sh"
```

with

```yaml
command: "bash $HELM_PLUGIN_DIR/github.sh"
```

You can do this either on your own fork of this plugin, or the installed version in `~/.helm/plugins`.