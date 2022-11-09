# Description

This repository is the source for https://js.waku.guide/.

It is built using [Hugo](https://gohugo.io/) static site generator.

# Development

You will need to [install Hugo](https://gohugo.io/getting-started/installing) and pull submodules:

```sh
git submodule update --init
```

To start a server that also builds the page use:

```sh
hugo server
```

Will expose the built page under http://localhost:1313/.

# Continuous Integration

Two branches are built by [our Jenkins instance](https://ci.infra.status.im/):

- `master` is deployed to https://js.waku.guide/ by [CI](https://ci.infra.status.im/job/website/job/js.waku.guide/)
- `develop` is deployed to https://dev-js.waku.guide/ by [CI](https://ci.infra.status.im/job/website/job/dev-js.waku.guide/)

PRs should be made for `develop` branch and `master` should be [rebased](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) on `develop` once changes are verified.
