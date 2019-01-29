---
title: SpringBoot项目的一些基本配置
comments: true
categories:
  - 开发
  - springboot
tags:
  - springboot
img: /img/springboot2.jpg
abbrlink: 24245
date: 2018-09-24 23:22:51
---

### SpringBoot项目的一些基本配置
本文主要涉及到一些SpringBoot项目最基本的初始化配置。
#### **1. JSP视图配置**
1. 在**pom.xml**中添加对jsp视图的支持：
```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-tomcat</artifactId>
	<scope>provided</scope>
</dependency>
<!-- servlet依赖. -->
<dependency>
	<groupId>javax.servlet</groupId>
	<artifactId>javax.servlet-api</artifactId>
</dependency>
<dependency>
	<groupId>javax.servlet</groupId>
	<artifactId>jstl</artifactId>
	</dependency>
	<!-- tomcat的支持. -->
	<dependency>
	<groupId>org.apache.tomcat.embed</groupId>
	<artifactId>tomcat-embed-jasper</artifactId>
</dependency>
```
2. 在**application.properties**中加入如下配置：
```
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
```
3. 编写Controller:
```java
@Controller
public class HelloController {
 
    @RequestMapping("/hello")
    public String hello(Model m) {
    	m.addAttribute("msg", "Hello World,Welcome to SpringBoot!");
        return "hello";
    } 
}
```
<!--more-->

4. 编写jsp文件：
在webapp目录下新建`WEB-INF\jsp`目录，jsp文件必须放WEB-INF目录下，因为Controller会根据`application.properties`中的视图重定向，到/WEB-INF/jsp目录下去寻找hello.jsp文件。
```
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
${msg}
```
5. 测试
在浏览器输入：++localhost:8080/hello++，会出现：Hello World,Welcome to SpringBoot!

#### **2. 热部署**
没有使用热部署时，我们对项目中的类或者配置文件等做修改之后，必须要重新启动Application类，是不是觉得很麻烦，热部署就是为了解决这个问题的。SpringBoot为我们提供了热部署的支持，当发现项目中任何类或者配置文件发生改变之后，马上通过JVM类加载的方式，加载最新的类或者配置文件到虚拟机中，这样就不用频繁重启项目了。
1. 在pom.xml中加入依赖：
```xml
<dependency>
 <groupId>org.springframework.boot</groupId>
 <artifactId>spring-boot-devtools</artifactId>
 <optional>true</optional> <!-- true,热部署才有效 -->
</dependency>
```
2. 修改之后重启项目
这个时候，对类或者配置文件做修改之后，项目会自动重启。可以在控制台中看到项目重启的输出信息。

3. 总结
>spring-boot-devtools模块使Spring Boot应用支持热部署，提高开发者的开发效率，无需手动重启Spring Boot应用。

**devtools的原理**

原理是使用了两个ClassLoader，一个Classloader加载那些不会改变的类（第三方Jar包），另一个ClassLoader加载会更改的类，称为restart ClassLoader,这样在有代码更改的时候，原来的restart ClassLoader 被丢弃，重新创建一个restart ClassLoader，由于需要加载的类相比较少，所以实现了较快的重启时间。

（1） devtools可以实现页面热部署（即页面修改后会立即生效，这个可以直接在application.properties文件中配置spring.thymeleaf.cache=false来实现），
实现类文件热部署（类文件修改后不会立即生效），实现对属性文件的热部署。
即devtools会监听classpath下的文件变动，并且会立即重启应用（发生在保存时机），注意：因为其采用的虚拟机机制，该项重启是很快的。
（2）配置了后在修改java文件后也就支持了热启动，不过这种方式是属于项目重启（速度比较快的项目重启），会清空session中的值，也就是如果有用户登陆的话，项目重启后需要重新登陆。
（3）默认情况下，/META-INF/maven，/META-INF/resources，/resources，/static，/templates，/public这些文件夹下的文件修改不会使应用重启，但是会重新加载（devtools内嵌了一个LiveReload server，当资源发生改变时，浏览器端刷新可看到效果）。

**devtools的配置**

在application.properties中配置spring.devtools.restart.enabled=false，此时restart类加载器还会初始化，但不会监视文件更新。
在SprintApplication.run之前调用System.setProperty(“spring.devtools.restart.enabled”, “false”);可以完全关闭重启支持，配置内容：

```
#热部署生效
spring.devtools.restart.enabled: true
#设置重启的目录
#spring.devtools.restart.additional-paths: src/main/java
#classpath目录下的WEB-INF文件夹内容修改不重启
spring.devtools.restart.exclude: WEB-INF/**
```

#### **3. 异常处理**
很多时候我们都希望服务器出现的错误能统一跳转到一个指定的error页面，SpringBoot的@ControllerAdvice和@ExceptionHandler也为我们提供了支持。

例如，我们可以在Controller里抛出一个错误：
```java
@RequestMapping("/test")
    public String test() throws Exception {
    	{
            throw new Exception("some exception");
        }
    }
```

然后，新建一个异常处理类，用于捕捉Exception异常以及其子类。捕捉到异常发生之后，把异常信息、发出异常的地址放进ModelAndView里，然后跳转到 errorPage.jsp页面显示。
```java

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(value = Exception.class)
    public ModelAndView defaultErrorHandler(HttpServletRequest req, Exception e) throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.addObject("url", req.getRequestURL());
        mav.setViewName("errorPage");
        return mav;
    }
 
}
```
_errorPage.jsp_
```html
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div style="width: 500px; border: 1px solid lightgray; margin: 200px auto; padding: 80px">
	系统 出现了异常，异常原因是： ${exception} <br/><br/> 
	出现异常的地址是： ${url}
</div>
```
#### **4. 端口及上下文路径**

默认的端口是8080，上下文路径path是“/”，可通过如下配置更改：
```properties
#设置上下文路径
server.port=9090
server.context-path=/boot
```

#### **5. 配置文件的切换**
开发和测试往往使用的是不同的端口和配置情况， 这个时候通过多配置文件来实现灵活切换配置文件可以给我们带来很大的便利。
1. 配置文件
新建三个配置文件：
核心配置文件：application.properties
开发环境用的配置文件：application-dev.properties
生产环境用的配置文件：application-pro.properties
然后，我们可以通过在application.properties中指定spring.profiles.active ,灵活的切换使用的环境。

- application.properties
```properties
#设置上下文路径
server.context-path=/boot
#jsp view
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
#配置切换
spring.profiles.active=pro
```


- application-dev.properties
```
server.port=8080
```
- application-pro.properties
```
>server.port=80
```
2. 命令行
不仅可以通过修改application.properties文件进行切换，还可以在部署环境下，指定不同的参数来确保生产环境要求的那套配置。

```
#指定实际生产环境的配置文件
java -jar target/springboot-0.0.1-SNAPSHOT.jar --spring.profiles.active=pro
```

```
#指定开发环境下的配置文件
java -jar target/springboot-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev
```


_PS：这里只讲一些最基本的配置。_








