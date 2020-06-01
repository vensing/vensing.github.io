---
title: Vue + SpringBoot 的几种部署方式
comments: true
toc: true
date: 2020-05-22 15:41:00
categories:
 - 前端
tags:
 - Vue
---


前端工程化及 React、Angular、Vue 等框架逐渐成为新的前台页面展示的解决方案后，前端页面逐渐摆脱了「套模板」的开发方式，真正的成为了一个工程项目，也引入了构建和编译、打包这些项目步骤。本文将简单阐述 Vue + SpringBoot 项目的几种部署方案。

<!-- more -->


### 有哪些部署方案 ？

前端项目在经过 webpack 编译 (babel转译) 打包转为浏览器可以识别的  js  代码和  html 、css 等静态资源之后，就可以等待部署发布了。

结合前段时间写的一个 Vue + SpringBoot 项目，我在部署的时候尝试了以下几种方式：

1. Vue + SpringBoot 打成 jar 包进行部署；
2. Vue + SpringBoot 打成 war 包进行部署；
3. Vue 项目和 SpringBoot 项目都单独部署；
4. 容器部署 ( 这就涉及到知识盲区了，逃 )

下面将对以上的前三种部署方式进行简单地阐述。PS：本文仅仅是实验性质的尝试，仅供参考，关于跨域问题已在后端项目配置好，这里不赘述。



---

### 一、Vue + SpringBoot  以 jar 包部署

采用 Vue + SpringBoot 打成  jar 包进行部署，我们需要先将 Vue 项目进行编译打包成静态资源，再把这些静态资源复制到 SB 项目的 static 静态资源文件夹下，记住：你需要对这些静态文件的访问权限都放行(前后端分离会采用 token 校验权限)。


```java
@Configuration
@EnableWebSecurity(debug = false)
public class SecurityConfigure extends WebSecurityConfigurerAdapter {
    @Override
    public void configure(WebSecurity web) throws Exception {
        // 解决静态资源被拦截的问题
        web.ignoring().antMatchers("/fonts/**", "/images/**", "/css/**", "/js/**","/favicon.ico", "/index.html", "/window.config.js");
		...
    }
}
```

最后再执行 `mvn package -Dmaven.test.skip = true` 把 SB 项目打成  jar  包。因为打成 jar 包后会内嵌 tomcat，所以我们只需再执行 `java -jar xxx.jar` 即可运行我们的项目，最后输入访问地址：ip:port/index.hmtl 即可访问我们的 Vue 单页应用啦。



你可能会对上面的放开的 `window.config.js` js 资源感到疑惑？实际上这个 js 是我们给单页应用注册的全局配置变量：



```javascript
window.__config = {}
window.__config.VUE_APP_BASE_API = 'http://localhost:7777/'
window.__config.VUE_APP_OAUTH_userAuthorizationUri = 'http://xxxxx/oauth/authorize'
window.__config.VUE_APP_OAUTH_redirect_uri = 'http://xxxxx/ssologin'
window.__config.VUE_APP_OAUTH_accessTokenUri = 'http://xxxxx/oauth/token'
window.__config.VUE_APP_OAUTH_userInfoUri = 'http://xxxxx/me'
```


以下代码是判断是否是开发环境，开发环境直接读取 `.env.development` 文件中的配置变量，生产环境下我们不把配置变量写到`env.production`，而是单独写到一个外部 window.config.js 里，记住你需要在 index.html 中手动引入或者自动注入这个 js，以根路径地址的方式。


```javascript
// 判断一下在开发环境使用vue配置的环境，生产环境要后面可以改的，所以生产环境从外部js取值
const userAuthorizationUri = process.env.NODE_ENV === 'development' ? process.env.VUE_APP_OAUTH_userAuthorizationUri : window.__config.VUE_APP_OAUTH_userAuthorizationUri
const redirect_uri = process.env.NODE_ENV === 'development' ? process.env.VUE_APP_OAUTH_redirect_uri : window.__config.VUE_APP_OAUTH_redirect_uri
const accessTokenUri = process.env.NODE_ENV === 'development' ? process.env.VUE_APP_OAUTH_accessTokenUri : window.__config.VUE_APP_OAUTH_accessTokenUri
const userInfoUri = process.env.NODE_ENV === 'development' ? process.env.VUE_APP_OAUTH_userInfoUri : window.__config.VUE_APP_OAUTH_userInfoUri

```


如果你把这些变量写入 `.env.production` ，那么一旦你更改了这些变量你又得重新去打个包，我可去他么的吧。实际上，也用不着重新打包 ，你可以去 /dist/js 目录下的 js 文件里来查找所有这些变量然后改回来，但这也非常容易出错。

当然一些重要的配置变量 ( 比如 secret )，你最好不要写在 window.config.js 里，你应该写到 .env.production 文件里然后使用 process.env.VUE_APP_client_secret 读取变量加密下。



关于「运行时环境变量 —— window.config.js」请参考：[为 Single Page App 提供运行时环境变量](https://aisensiy.github.io/2017/07/07/runtime-env-for-spa/)

关于「.env.production、.env.development  环境变量和模式」请参考：[Vue-CLI 环境变量和模式](https://cli.vuejs.org/zh/guide/mode-and-env.html)

---

#### 干掉 # hash

> `vue-router` 默认 hash 模式 —— 使用 URL 的 hash ( /#/path 模式 ) 来模拟一个完整的 URL，于是当 URL 改变时，页面不会重新加载。
如果不想要很丑的 hash，我们可以用路由的 history 模式，这种模式充分利用 history.pushState API 来完成 URL 跳转而无须重新加载页面。

Vue-CLI 官网给我们提供了另外一种路由模式：history，使用history模式时，浏览器地址栏就不会有很丑的 # 号了。当然官网也说了：玩好这种模式 ，你需要在服务端增加一个覆盖所有情况的 URL 候选资源，匹配不到静态资源就返回我们的 `index.html`，这个页面就是我们的单页应用页面。

那么 SB 项目想要配合 Vue 使用 history 模式在浏览器地址栏显示正常的 URL 应该怎么做呢？

**0x01 Vue-Router 配置**

首先，Vue-Router 得开启 history 模式和配置 base 路由基路径：

```javascript
const router = new Router({
  routes,
  mode: 'history',
  base: '/vue',
  routes: [
    { path: '*', component: NotFoundComponent }
  ]
})
```

这么做以后，你的服务器就不再返回 404 错误页面，因为对于所有路径都会返回 index.html 文件。为了避免这种情况，你应该在 Vue 应用里面覆盖所有的路由情况，然后在给出一个 404 页面。

**注：**  vue.config.js 里的 `publicPath` 决定 js、css 等静态资源打包之后的引入路径，如果打包后 dist 目录的 js、css 路径放在后台项目的 `static` 目录下，则 publicPath 直接写 ‘/’ 根路径即可，不要和 Vue-Router 配置的 base 路径搞混淆了。如果你想和 base 路径  '/vue' 保持一致，你需要将 js、css 等静态资源放到 static/vue/ 目录下。

'Uncaught SyntaxError: Unexpected token < ' 错误是由于请求的 js、css 等静态资源路径不对，导致返回的内容是  html 页面，浏览器也就无法正确解析了。

**0x02 后端配置**

```java
@Configuration
public class ErrorPageConfig {

    /**
     * SpringBoot2.0以上版本WebServerFactoryCustomizer代替之前的EmbeddedWebServerFactoryCustomizerAutoConfiguration
     *
     */

    @Bean
    public WebServerFactoryCustomizer<ConfigurableWebServerFactory> webServerFactoryCustomizer() {

        //java7 常规写法
        //return new WebServerFactoryCustomizer<ConfigurableWebServerFactory>() {
        //    @Override
        //    public void customize(ConfigurableWebServerFactory factory) {
        //        ErrorPage errorPage404 = new ErrorPage(HttpStatus.NOT_FOUND, "/404.html");
        //        factory.addErrorPages(errorPage404);
        //    }
        //};

        //java8 lambda写法
        return (factory -> {
            ErrorPage errorPage404 = new ErrorPage(HttpStatus.NOT_FOUND, "/index.html");
            factory.addErrorPages(errorPage404);
        });
    }

}
```
如果你后端使用了带 token 的请求验证 url 的方式，上面的配置可能就无效了，会返回没有权限访问的信息。


新建一个Controller 匹配 '/vue/\*\*\' 并都返回 index.html：

```java
@Controller
public class ErrorPageController {

    @ApiOperation(value = "跳转到index页面", notes = "跳转到index页面")
    @RequestMapping("/vue/**")
    public ModelAndView getNeMoInTree() {
        return new ModelAndView("index");
    }

}
```

最后记得放开：'/vue/\*\*\' 的访问限制：

```java
	web.ignoring().antMatchers("/vue/**");
```

maven 打好 jar 包运行后，浏览器访问：ip:port/vue/index 就大功告成啦。

---

### 二、Vue + SpringBoot  以 war 包部署

**0x01后端配置**

首先将项目 pom.xml 中更改打包方式为 war 包，将内置 tomcat 配置为 provided 模式：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<packaging>war</packaging>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-tomcat</artifactId>
		<scope>provided</scope>
	</dependency>
</project>
```

启动类继承 SpringBootServletInitializer 并重写其 configure方法，做如下配置：

```java
public class MyApplication extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(MyApplication.class);
	}
	
}
```
jar 和 war 启动的区别：
> jar包: 执行 SpringBootApplication 的 run 方法，启动 IOC 容器，然后创建嵌入式 Servlet 容器
war包:  先是启动 Servlet 服务器，服务器启动 Springboot 应用(SpringBootServletInitizer 实例执行 onStartup 方法的时候会通过 createRootApplicationContext 方法来执行 run 方法)，然后启动 IOC 容器

**0x02 tomcat 配置**

进入 tomcat/conf 目录下 ，将 server.xml 中的端口号修改为前端配置的后台统一接口路径(相同则跳过)，因为我们部署的是一个项目。

将 war 解压到 tomcat/webapps/ROOT 目录下 (图省事2333)，然后去tomcat/bin 目录下执行启动脚本启动项目。当然你也可以解压到 webapps 任意目录下，假如是 `app` 目录，你得将 Vue 项目的 publicPath 配置为 /app，最后的访问地址将是`ip:port/app/vue/index`，其中 js、css 等静态资源的地址为 ip:port/app/js/xxx.js、ip:port/app/css/xxx.css，而 Vue 管理的路由是 ip:port/app/vue/\*\* 。

---

### 三、Vue 项目和 SpringBoot 项目各自单独部署

Vue 项目单独部署，那必然是部署到 Nginx 上了，配合 WSL (Windows Sub Linux) 开发体验上升了一个档次 (WSL + VS Code 真香)。

**0x01 Vue 项目部署到 Nginx**

Vue-Router 采用 history 模式，在 nginx.conf 中加入：`include /etc/nginx/conf.d/*.conf;` 然后进入 conf.d 目录 vim  app.conf：

```conf
   server {
        listen 9999;
        server_name  localhost;
        error_page 500 502 503 504 /50x.html;

        location = /50x.html {
         root html;
        }

        location / {
           root /dist;
           try_files $uri $uri/ /index.html;
           # index index.html index.htm;
        }

        #location /app {
        #   alias /dist; #注意alias,不能为root
        #   index index.html index.htm;
        #   try_files $uri $uri/ /app/index.html;
        #}
    }
```

如果，Vue-Router 里配置的 base: /，那么做如下配置：

```conf
location / {
    root /dist;
    try_files $uri $uri/ /index.html;
    # index index.html index.htm;
}
```

Vue-Router 里配置的 base: /app 子路径，那么做如下配置：
```conf
location /app {
    alias /dist; #注意alias,不能为root
    # index index.html index.htm;
    try_files $uri $uri/ /app/index.html;
}
```

以上是 Vue-Router 采用 HTML5  histroy 模式部署，具体请参考 Vue-CLI 官网：[html5-history-模式](https://router.vuejs.org/zh/guide/essentials/history-mode.html#html5-history-%E6%A8%A1%E5%BC%8F) 

当然，如果你不打算用 history 模式你又能接受浏览器地址栏中丑陋的 # 号，那么你就用默认的 hash 模式，就没那么上面那么多屁事了。

**0x02 SpringBoot 项目部署**

SpringBoot 项目部署，以什么方式部署你开心就好，不过记得放开资源哟 ~

---

### 总结

不管以什么方式部署，请记住后端放开静态资源的访问，以及注意  Vue 中的静态资源地址和路由地址的配置。至于哪种方式好，那肯定是分开部署好，Nginx 配置简单多了，而且分开部署的好处也很多(最大的好处当然是方便甩锅了，雾)。

Vue 路由默认的使用带 # 的 hash 模式来模拟一个完整的 url，如果你想省事那么就采用默认的hash模式；如果你在意浏览器地址栏 url 的美观，就采用 history 模式，不过你需要在后端加一个覆盖所有情况的候选资源然后都返回 index.html ，及前台 Vue 应用里面配置一个路由以覆盖所有的路由情况，然后在给出一个 404 页面。



