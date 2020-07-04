---
title: 搭建一个自己的 Gitlab CI Runner
comments: true
toc: true
date: 2020-07-04 19:53:00
categories:
 - 编程
tags:
 - docker
 - CI
---



说起来博客使用 Travis CI 自动持续部署也一年多了，唯一的感受就是 CI 实在太方便了。正好最近工作的项目仓库都转到公司内部的 Gitlab ， 于是就想着能不能利用 CI 跑一些测试。



<!-- more -->

### 最简单的 Gitlab CI Runner

经过几天的摸鱼，已经大概摸清了 Gitlab CI Runner 的用法，期间也遇到了很多的坑，所以这篇文章就用来记录踩的坑吧。

由于公司内部的 Gitlab 没有提供公有的 Runner，所以想要把 CI 用起来还得自己动手。于是乎，我就去了解了下如何搭建自己的 Specific Runners 。这里在 gitlab.com 新建一个最简单的项目，只有一个 test.py 打印输出 hello world 的项目。

定位到 Gitlab 项目的 Settings => CI/CD => Runners 下，可以看到配置特定的 Runner, 总结下大致有这么几步：

- Install Gitlab Runner
- Register Runner 
- Config gitlab-ci.yml

#### Install

首先，需要安装 Gitlab Runner，可以选择的平台也有很多：Windows、Linux、macOS、Doker 等等；看了下 Windows 下的安装步骤，我果断选择了 WSL 安装。 WSL 我安装的子系统是 Ubuntu 18.04 LTS，下载 gitlib-runner_amd64.deb 安装包。

```sh
# For example, for Debian or Ubuntu:
curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_<arch>.deb

# For example, for CentOS or Red Hat Enterprise Linux:
curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_<arch>.rpm
```

下载好之后即可执行安装命令：

```sh
# For example, for Debian or Ubuntu:
dpkg -i gitlab-runner_<arch>.deb

# For example, for CentOS or Red Hat Enterprise Linux:
rpm -i gitlab-runner_<arch>.rpm
```

See Install GitLab Runner manually on GNU/Linux: https://docs.gitlab.com/runner/install/linux-manually.html

你也可以添加 Gitlab 官方仓库源，再通过包管理来安装：

```sh
# For Debian/Ubuntu/Mint
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

# For RHEL/CentOS/Fedora
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash

# For Debian/Ubuntu/Mint
sudo apt-get install gitlab-runner

# For RHEL/CentOS/Fedora
sudo yum install gitlab-runner

```
See Install GitLab Runner using the official GitLab repositories: https://docs.gitlab.com/runner/install/linux-repository.html


#### Register

安装好 Gitlab Runner 之后我们就可以注册 Runner 绑定到我们的仓库，到 Gitlab 项目的 Settings => CI/CD => Runners，展开可以看到下图所示的内容：

1. Install GitLab Runner
2. Specify the following URL during the Runner setup: https://gitlab.com/ 
3. Use the following registration token during setup: xxxxxx_KVcfgoXH2hAc 
4. Start the Runner!

其中，第二三步的 URL 和 token，是在执行 Runner 注册命令中会用到的。执行如下注册命令：

```sh
    # 执行注册命令
    sudo gitlab-runner register

    # 输入上图第二步的 URL 
    Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
    https://gitlab.com

    # 输入上图第三步的 Token
    Please enter the gitlab-ci token for this runner
    xxxxxx_KVcfgoXH2hAc 

    # 输入 runner 描述
    Please enter the gitlab-ci description for this runner
    gitlab runner for ci 

    # 输入 tag 标签名称
    Please enter the gitlab-ci tags for this runner (comma separated):
    ci

    # 选择一个执行器，这里我们选择 docker
    Please enter the executor: ssh, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, virtualbox, docker-ssh, shell:
    docker

    # gitlib-ci.yml 中未指定 images 时，采用的默认镜像
    Please enter the Docker image (eg. ruby:2.6):
    python:alpine

```

相信上面的这些都难不倒你，关于 WSL 上的 Docker ，这里我们需要着重提一下。你只需要下载好 Docker Desktop 并安装好，安装好之后我们进入 settings 设置界面，进入到 Resources => WSL INTEGRATION ，允许 Docker 访问 WSL2 ，并启用安装的发行版。也就是说，我们不用在 WSL 上再安装 Docker 了，只需要安装 Windows Docker 桌面版程序并让其在后台运行着即可。值得注意的是，如果你退出了 Docker 桌面版，WSL2 里也访问不到 Docker 服务了。

![Docker 桌面版配置 WSL2](https://i.loli.net/2020/07/04/4TG9A1OWxfrsXQ3.png)

See Docker Desktop WSL 2 backend: https://docs.docker.com/docker-for-windows/wsl/

上面的 python:alpine 镜像是安装 Docker 后就默认存在的镜像，实际上 Gitlab Runner 默认是去拉 Docker Hub 的镜像创建容器来运行任务的，如何拉取本地自定义镜像运行任务在后面我们会提到，这里我们需要做的是把镜像名书写正确。

注册好了 Runner 之后，我们刷新 Settings 下的 CI/CD 页面，展开 Runners，可以看到我们的 Runner 注册成功了，并且 runner 描述 和 tag 标签也显示出来了：

![Runner 注册成功](https://i.loli.net/2020/07/04/T9mOKzlVeBLDIkS.png)



#### Config gitlab-ci.yml

接下来，我们用 Gitlab 的 WEB-IDE 给项目增加一个 gitlab-ci.yml 配置文件，它是 gitlab 项目用来和 Runner 交互的一个配置文件，我们添加如下内容：

```yml

image: python:alpine

stages:
  - test

test:
  stage: test
  script:
    - python test.py

```

在 WEB-IED 页面提交更改，这个时候就会自动触发 CI Pipelines， 并执行相应的 Job，Gitlab Runner 监听到之后就会使用 Docker executor，并拉取指定的镜像 (gitlab-ci.yml 中未配置 images时，会拉取注册Runner 时输入的默认镜像) ，接着从 Gitlab 拉取项目的仓库源码代码检出 master 分支，执行 gitlab-ci.yml 中的 “step_script” 作业脚本。

![CI 执行日志信息](https://i.loli.net/2020/07/04/dNkmlphFgMREiew.png)



### Runner 拉取自定义 Docker 镜像

上面的例子过于简单了些，接下来我们来新建一个更复杂的 python opencv 项目，并且在 Docker 里安装 Gitlab Runner，Gitlab Runner 使用 Docker executor 拉取我们自定义的包含 python 运行环境和 opencv 库 的 Ubuntu 自制镜像。

[python opencv 项目](https://gitlab.com/vensing/TestCI)的结构如下图所示：

![python opencv 项目结构](https://i.loli.net/2020/07/04/U6SZRnAQhiFHj2e.png)

#### Docker 安装 Runner 

```sh
   docker run -d --name gitlab-runner --restart always \
     -v /srv/gitlab-runner/config:/etc/gitlab-runner \
     -v /var/run/docker.sock:/var/run/docker.sock \
     gitlab/gitlab-runner:latest
```
#### Docker 注册 Runner

```sh
    docker run --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register

    # 输入 URL 
    Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
    https://gitlab.com

    # 输入 python opencv 项目的 Token
    Please enter the gitlab-ci token for this runner
    xxxxxx_yyyyyyyyyyy 

    # 输入 runner 描述
    Please enter the gitlab-ci description for this runner
    gitlab runner for ci 

    # 输入 tag 标签名称
    Please enter the gitlab-ci tags for this runner (comma separated):
    ci

    # 选择一个执行器，这里我们选择 docker
    Please enter the executor: ssh, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, virtualbox, docker-ssh, shell:
    docker

    # gitlib-ci.yml 中未指定 images 时，采用的默认镜像
    Please enter the Docker image (eg. ruby:2.6):
    ubuntu-opencv:latest

```


#### 自定义 Ubuntu 镜像

从 Docker Hub 拉取 Ubuntu 镜像：

```sh
    # 搜寻镜像
    docker search ubuntu
    # 拉取镜像
    docker pull ubuntu
    # 查看镜像
    docker images

    REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
    ubuntu-opencv                 latest              aba324b29fe7        3 hours ago         677MB
    gitlab/gitlab-runner          latest              54ba330cd824        3 days ago          373MB
    gitlab/gitlab-runner-helper   x86_64-6214287e     3fbba80323bd        4 days ago          57.2MB
    <none>                        <none>              bfb66eee5b87        4 days ago          89.5MB
    <none>                        <none>              3cb247d9cae4        4 days ago          108MB
    node                          12-alpine           06a4a7b5263d        2 weeks ago         89.3MB
    ubuntu                        latest              74435f89ab78        2 weeks ago         73.9MB
    python                        alpine              8ecf5a48c789        4 weeks ago         78.9MB
    alpine                        latest              a24bb4013296        5 weeks ago         5.57MB

```

拉取的 ubuntu 是最新的版本，大概 73M ，接着我们使用这个镜像来运行一个容器：

```sh

    # 使用最新版本的 ubuntu 镜像运行容器，
    # 并进入交互式终端，这里加了 -d 后台运行，不会进入终端
    # --name 指定容器名称，
    docker run -itd --name ubuntu_v1 ubuntu:latest /bin/bash

    # 查看正在运行的容器
    docker ps 
    CONTAINER ID        IMAGE                  COMMAND               CREATED             STATUS                    PORTS               NAMES
    c3715c64c0f3        ubuntu-opencv          "bin/bash"            3 hours ago         Exited (0) 3 hours ago                        ubuntu_v1

    # 指定容器名称 ubuntu_v1 进入后台运行中的容器，-i: 交互式操作。-t: 终端。
    # 未指定容器名称请使用 CONTAINER ID，如 ubuntu_v1 是 c3715c64c0f3 
    > ~ $ docker exec -it ubuntu_v1 /bin/bash
    root@c3715c64c0f3:/# 

```

由于拉取的 ubuntu 镜像都是最简单的 BASE 镜像，空空如也 73M ，连 vim 都没有我可去你他么的吧，更别提自带些什么环境了。所以，我们需要先安装下 vim (没有 vim 怎么配置源...)，再去配置下 ubuntu 的源为国内的源，最后安装 python 和 python opencv 库。

```sh

    # 安装 vim 
    apt-get install -y vim

    # 查看容器的 linux 版本
    # 正确的姿势：
    cat /etc/issue
    Ubuntu 20.04 LTS

    # 错误的姿势(这样查到的是宿主机的系统，在我这是 WSL2的):
    cat /proc/version  
    uname -a 

    # 配置 ubuntu 源为清华源
    mv /etc/apt/sources.list /etc/apt/sources.list.bak

    # 配置清华源 see: https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
    vim /etc/apt/sources.list
    apt-get update

    # 安装 python3
    apt-get install -y python3
    # 安装 pip3
    apt-get install python3-pip
    # 配置 pip3 源 see: https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
    pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

    # 安装 opencv 依赖
    pip3 install wheel
    pip3 install opencv-contrib-python

    # 解决 opencv import cv2 ImportError: libgthread-2.0.so.0: cannot open shared object file: No such file or directory
    apt-get install -y libglib2.0-0
    # 解决 ImportError: libSM.so.6: cannot open shared object file: No such file or directory
    apt-get install -y libsm6 libxext6
    # 解决 ImportError: libXrender.so.1: cannot open shared object file: No such file or directory
    apt-get install -y libxrender-dev

```

配置完这些东西你肯定想骂人了，但还是请忍住，要骂看完了文章再骂吧。

最后我们新建一个 test.py 测试下 opencv 安装情况：


```python

#!/usr/bin/python3
# -*- coding: utf-8 -*-

import cv2
print(cv2.__version__)

```

![ubuntu_v1_opencv.png](https://i.loli.net/2020/07/04/iIXRz3bEymlOMD7.png)


耐心点安装完这些，一个包含 python 运行环境和 opencv 库 的 Ubuntu 容器环境就完成了。接着我们需要停掉容器，导出容器为 ubuntu_v1.tar 文件，再导入 ubuntu_v1.tar 文件为镜像：

```
    docker stop ubuntu_v1

    docker export ubuntu_v1 > ubuntu_v1.tar

    docker import ubuntu_v1.tar ubuntu-opencv

    docker images

```

最后，我们可以看到 ubuntu-opencv 的镜像了(未指定版本会默认设置为 latest)，这里因为需要测试容器中 opencv 环境是否安装成功，所以干脆把这个测试容器的快照文件中导入为镜像了，这样就能保证不会出现问题。自制镜像推荐使用 Dockerfile 来制作。

![ubuntu-opencv 镜像](https://i.loli.net/2020/07/04/naipXYe9lE2TWt7.png)


#### gitlab-ci.yml 配置

```yml
# 指定为注册 Runner 时设置的默认镜像，即自定义的 opencv 环境镜像
image: ubuntu-opencv:latest

stages:
  - test

test:
  stage: test
  script:
    - python3 src/py/test.py
    - python3 src/py/cv.py
```

#### Girlab Runner 拉取本地镜像

如果这个时候，我们去跑 CI，会出现如下错误：

![Job 错误](https://i.loli.net/2020/07/04/UykKjPw5MON68B3.png)

因为 Docker 里的 gitlab-runner 默认会去拉取公网上的镜像，公网上没有我们自制的这个 ubuntu-opencv 镜像就出错了；因此需要配置下 gitlab-runner 的配置文件，Docker 安装的 gitlab-runner 配置文件在 /srv/gitlab-runner/config/config.toml。在这个文件中加入：`pull_policy = "never"`，拉取本地镜像。如果 Docker 里的 gitlib-runner 未运行也会导致这个错误，因为拉不到镜像。

See Using the if-not-present pull policy: https://docs.gitlab.com/runner/executors/docker.html#using-the-if-not-present-pull-policy

```toml
concurrent = 1    
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "gitlab runner for ci"
  url = "https://gitlab.com/"
  token = "xxxxxxxxxxxxxxxx"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.docker]
    tls_verify = false
    image = "ubuntu-opencv:latest"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
    pull_policy = "never"
```

如果我们对 config.toml 这个配置文件做了修改，则需要重启 Docker 中的 gitlab-runner 来应用修改。

```
    docker restart gitlab-runner
```

做完了这些并确保 Docker 中的 gitlab-runner 容器在运行，提交下代码或者手动去触发 Piplines，就可以执行 CI，拉取我们在 Docker 中自制的 python 和 opencv 环境的镜像运行 gitlab-ci.yml 中的脚本任务了。

### 最后

最后请享受成功的乐趣吧，看下成功的 CI 任务图：

![CI 任务图](https://i.loli.net/2020/07/05/Ar5aydRb2Zl1kNC.png)


###  参考

- [Install GitLab Runner manually on GNU/Linux](https://docs.gitlab.com/runner/install/linux-manually.html) 
- [Install GitLab Runner using the official GitLab repositories](https://docs.gitlab.com/runner/install/linux-repository.html)
- [Docker Desktop WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/)
- [local system volume mounts to start the Runner container](https://docs.gitlab.com/runner/install/docker.html#option-1-use-local-system-volume-mounts-to-start-the-runner-container)
- [To register a Runner using a Docker containe](https://docs.gitlab.com/runner/register/index.html#docker)
- [Using the if-not-present pull policy](https://docs.gitlab.com/runner/executors/docker.html#using-the-if-not-present-pull-policy)
- 项目地址：https://gitlab.com/vensing/TestPyCI ，https://gitlab.com/vensing/TestCI 

