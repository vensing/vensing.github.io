---
title: 使用 Github Actions 部署 HEXO 博客
comments: true
toc: true
date: 2020-12-09 10:05:30
categories:
  - 博客开发
tags:
  - CI
---


促成我从 Travis CI 换成 Github Action 的原因找到了：Travis CI 任务排队足足快半小时才启动虚机跑任务。我想慢的原因大概是我没花钱白嫖了这么久😅

<!--more-->

所以这篇文章主要来讲一下如何使用 Github Actions 部署 HEXO 博客，好吧虽然是被别人写烂了的文章，但自己上手操作起来还是有些收获的。但凡有想法的事情，以最快的速度行动起来总是没错的，状态也可能是最好的。

### 前期准备

为了和触发 Travis CI 任务的 `source` 分支独立区分开，我创建了一个新的 `source-action` 分支用来触发 Github Actions 的工作流。目标是将 hexo 博客源码 push 到 Github 仓库的 `source-action` 分支后触发 Github Actions 的工作流，启动 OS 实例执行任务，安装 node 环境构建 hexo 网页，然后推送到仓库的 `master` 分支作为博客备份，同时再推送一份到 VPS 上部署。其实这和 Travis CI 的流程也是一样的，只是涉及到 SSH key、环境变量、配置文件的修改。

### 生成部署密钥

我们需要在指定的目录下生成 ssh key, 打开终端，进入 blog-action-sshkey 目录，执行命令：

```bash
$ ssh-keygen -f github-deploy-key
```

然后一路按几次回车就完成生成工作了，最后在目录下会生成 `github-deploy-key` 私钥 和 `github-deploy-key.pub` 公钥两个文件。

### 配置部署密钥

#### 配置公钥

复制 github-deploy-key.pub 文件里的内容，在博客仓库 `Settings` -> `Deploy keys` -> `Add deploy key` 页面上添加 SSH 公钥：

- Title 填写 HEXO_DEPLOY_PUB。
- Key 填写 github-deploy-key.pub 文件内容。
- 勾选 Allow write access 选项。

![填写部署公钥](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201209-105708.jpg)

#### 配置私钥

复制 github-deploy-key 文件里的内容，在博客仓库 `Settings` -> `Secrets` -> `Add a new secret` 页面上添加 SSH 私钥：

- Name 填写 HEXO_DEPLOY_PRI。
- Value 填写 github-deploy-key 文件内容。

![填写部署私钥](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201209-105110.jpg)


### Github Actions 

拉取远程的 `source-action` 分支并检出到本地，在 blog 仓库根目录下创建 `.github/workflows/deploy.yml` 文件，最后的目录结构应该是这样：

```bash
blog (repository)
└── .github
    └── workflows
        └── deploy.yml
```

#### 编写 deploy.yml

又到了编写配置文件的环节了，嘛反正 CI 最后落地下来都是在配置文件的各个步骤中，也有使用界面的 CI 服务，比如 Buddy CI 但是我并没有用过。

{% collapse 点击查看完整deploy.yml %}
```yaml
name: CI

on:
  push:
    branches:
      - source-action

env:
  GIT_USER: vensing
  GIT_EMAIL: vensing@foxmail.com
  THEME_REPO: vensing/Kratos-Rebirth
  THEME_BRANCH: hexo5-custom
  DEPLOY_REPO: vensing/vensing.github.io
  DEPLOY_BRANCH: master

jobs:
  build:
    name: Build on node ${{ matrix.node_version }} and ${{ matrix.os }}
    runs-on: ubuntu-latest
    strategy:
      matrix:
        os: [ubuntu-latest]
        node_version: [14.x]

    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Checkout theme repo
        uses: actions/checkout@v2
        with:
          repository: ${{ env.THEME_REPO }}
          ref: ${{ env.THEME_BRANCH }}
          path: themes/Kratos-Rebirth

      - name: Checkout deploy repo
        uses: actions/checkout@v2
        with:
          repository: ${{ env.DEPLOY_REPO }}
          ref: ${{ env.DEPLOY_BRANCH }}
          path: .deploy_git

      - name: Use Node.js ${{ matrix.node_version }}
        uses: actions/setup-node@v1
        with:
          node-version: ${{ matrix.node_version }}

      - name: Configuration environment
        env:
          HEXO_DEPLOY_PRI: ${{ secrets.HEXO_DEPLOY_PRI }}
        run: |
          sudo timedatectl set-timezone "Asia/Shanghai"
          mkdir -p ~/.ssh/
          echo "$HEXO_DEPLOY_PRI" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts
          ssh-keyscan vensing.com >> ~/.ssh/known_hosts
          git config --global user.name $GIT_USER
          git config --global user.email $GIT_EMAIL

      - name: Install dependencies
        run: |
          npm install

      - name: Deploy hexo
        run: |
          npm run deploy
          npm run build

      - name: SSH VPS
        uses: webfactory/ssh-agent@v0.4.1
        with:
          ssh-private-key: ${{ secrets.HEXO_DEPLOY_PRI }}
      
      - name: Deploy VPS
        run: |
          rsync -av --delete public/ root@vensing.com:/hexo
```
{% endcollapse %}

以下是对配置文件中的各个部分做简单解释：

#### 设置触发条件和环境变量

```yaml
name: CI

on:
  push:
    branches:
      - source-action

env:
  GIT_USER: vensing
  GIT_EMAIL: vensing@foxmail.com
  THEME_REPO: vensing/Kratos-Rebirth
  THEME_BRANCH: hexo5-custom
  DEPLOY_REPO: vensing/vensing.github.io
  DEPLOY_BRANCH: master
```

- `name` 是当前 Action 的名字，最后你可以在仓库的 `Actions` 菜单项中看到它。
- `on` 是此 Action 触发条件，当满足条件时会触发此任务，上面的 `on.push.branches.source-action` 是指当 `source-action` 分支收到 push 后会触发 Action 执行任务。
- `env` 为环境变量对象
    - env.GIT_USER 为 Hexo 编译后使用此 git 用户部署到仓库
    - env.GIT_EMAIL 为 Hexo 编译后使用此 git 邮箱部署到仓库
    - env.THEME_REPO 为 Hexo 所使用的主题的仓库，这里为 vensing/Kratos-Rebirth
    - env.THEME_BRANCH 为 Hexo 所使用的主题仓库的版本，可以是：branch、tag 或者 SHA
    - env.DEPLOY_REPO 为 Hexo 编译后要部署的仓库，例如：vensing/vensing.github.io
    - env.DEPLOY_BRANCH 为 Hexo 编译后要部署到的分支，例如：master

#### 指定任务及执行步骤

```yaml
jobs:
  build:
    name: Build on node ${{ matrix.node_version }} and ${{ matrix.os }}
    runs-on: ubuntu-latest
    strategy:
      matrix:
        os: [ubuntu-latest]
        node_version: [14.x]

    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Checkout theme repo
        uses: actions/checkout@v2
        with:
          repository: ${{ env.THEME_REPO }}
          ref: ${{ env.THEME_BRANCH }}
          path: themes/Kratos-Rebirth

      - name: Checkout deploy repo
        uses: actions/checkout@v2
        with:
          repository: ${{ env.DEPLOY_REPO }}
          ref: ${{ env.DEPLOY_BRANCH }}
          path: .deploy_git

      - name: Use Node.js ${{ matrix.node_version }}
        uses: actions/setup-node@v1
        with:
          node-version: ${{ matrix.node_version }}
```

- jobs 为此 Action 下的任务列表
    - jobs.{job}.name 任务名称
    - jobs.{job}.runs-on 任务所需容器，可选值：ubuntu-latest、windows-latest、macos-latest。
    - jobs.{job}.strategy 策略下可以写 array 格式，此 job 会遍历此数组执行。
    - jobs.{job}.steps 一个步骤数组，可以把所要干的事分步骤放到这里。
        - jobs.{job}.steps.$.name 步骤名，编译时会会以 LOG 形式输出。
        - jobs.{job}.steps.$.uses 所要调用的 Action，可以到 https://github.com/actions 查看更多。
        - jobs.{job}.steps.$.with 一个对象，调用 Action 传的参数，具体可以查看所使用 Action 的说明。

在上面配置文件中的代码段，指定了 Action 依赖的 OS 实例为 ubuntu-latest，以及 node 运行环境版本为 14.x，任务 steps 中引用了一个 版本为 v2 的 Action `checkout` ，`actions/checkout@v2` 的作用是 Checkout 一个 git 仓库到当前 ubuntu 容器。


- `Checkout theme repo` step 中从环境变量中拿出 ${{ env.THEME_REPO }} 指定本站使用的博客仓库名及分支 **hexo5-custom**，检出到 **themes/Kratos-Rebirth** 目录下。

- `Checkout deploy repo` step 中从环境变量中拿出 ${{ env.DEPLOY_REPO }} 指定部署备份的博客仓库，及要部署备份生成的静态网页的分支 **master**，检出到 **.deploy_git** 目录下。
- `Use Node.js` step 中使用了 `actions/setup-node@v1` action 指定了 node 的版本。

#### 配置环境即部署到 Github Pages

```yaml
      - name: Configuration environment
        env:
          HEXO_DEPLOY_PRI: ${{ secrets.HEXO_DEPLOY_PRI }}
        run: |
          sudo timedatectl set-timezone "Asia/Shanghai"
          mkdir -p ~/.ssh/
          echo "$HEXO_DEPLOY_PRI" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts
          ssh-keyscan vensing.com >> ~/.ssh/known_hosts
          git config --global user.name $GIT_USER
          git config --global user.email $GIT_EMAIL

      - name: Install dependencies
        run: |
          npm install

      - name: Deploy hexo
        run: |
          npm run deploy
```

检出主题分支和 Github Pages 部署分支之后，接着配置执行环境：
- 设置容器的时区；
- 将在 `Settings -> Secrets` 中的 SSH 私钥写入到 ~/.ssh/id_rsa 文件中；
- 设置 id_rsa 的文件权限及 know_hosts、git 全局用户信息

接着执行 npm install 安装依赖和 npm run deploy 部署到 Github Pages 进行备份。`run: |` 可分行连续执行多条命令，需要注意的是使用 hexo 的 deploy 命令需要我们安装 `hexo-deployer-git` 依赖，所以需要先在本地安装下依赖写入 package.json 中。

### Github Actions 部署 hexo 到 VPS

在使用 Travis CI 时，如果想要把 Hexo 部署到 VPS 服务器上，需要做的东西就比较多了。先是得对私钥进行加密处理(Windows 下会出现问题，*nix 才正常)，为此我们得在 *nix 环境下安装 ruby、travis ci 等等一系列的东西，然后还得把加密后的私钥上传到仓库，接着写解密脚本最后才能放入容器的 .ssh/id_rsa 文件中。总之一大堆套餐下来，很麻烦，而 Github 直接可以设置私钥至 `Secrets` 中且无需将加密后的私钥放到仓库里，最后直接可以在容易中拿到。更加简单和安全，大概？

要将构建好的静态网页推送到 VPS，需要将 SSH 公钥复制到 VPS 的 ~/.ssh/authorized_keys 文件中，如果有多个 SSH 公钥，换行后追加即可。

```yaml
      - name: Deploy hexo
        run: |
          npm run deploy
          npm run build

      - name: SSH VPS
        uses: webfactory/ssh-agent@v0.4.1
        with:
          ssh-private-key: ${{ secrets.HEXO_DEPLOY_PRI }}
      
      - name: Deploy VPS
        run: |
          rsync -av --delete public/ root@vensing.com:/hexo
```

在 Action 中要想部署到 VPS 上，需要安装一个第三方的 action: `webfactory/ssh-agent@v0.4.1`，在执行完 `npm run build`（hexo clean && hexo g）之后会在 public 目录下生成构建好的静态网页，以便后面推送到 VPS。这里不用 .deploy_git 目录是因为，这是一个 Git 仓库，里面有 .git 目录，时间一久文件会变得很多，况且构建的静态网页目录根本不需要这些文件。

`SSH VPS step` 中我们从环境变量中拿到 SSH 私钥，并将其指定为 ssh-private-key 的值，最后使用 rsync 命令推送到 VPS 即可。

最后来看一眼，Githun Actions 执行的效果图：
![Githun Actions](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201209-105948.jpg)

切换到 Github Actions 后，体验很好，速度很快，繁忙的时候也只花两分钟排队。

### References

- [利用 Github Actions 自动部署 Hexo 博客](https://sanonz.github.io/2020/deploy-a-hexo-blog-from-github-actions/)
- [利用 GitHub Actions 自动部署 Hugo 博客到自建 VPS](https://yestyle.medium.com/%E5%88%A9%E7%94%A8-github-actions-%E8%87%AA%E5%8A%A8%E9%83%A8%E7%BD%B2-hugo-%E5%8D%9A%E5%AE%A2%E5%88%B0%E8%87%AA%E5%BB%BA-vps-fa3ed89c8573)
- [Github Actions](https://github.com/actions)
