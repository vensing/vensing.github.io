---
title: 构建你的第一个SpringBoot项目
comments: true
categories:
  - 开发
  - springboot
tags:
  - springboot
img: /img/springboot1.jpg
abbrlink: 11763
date: 2018-09-24 22:28:43
toc: true
---

## 基于eclipse手动构建SpringBoot项目

> ### 创建一个Maven项目

为什么不用sts插件,或是STS编辑器创建SpringBoot项目呢？因为要瞎折腾啊。

首先SpringBoot本质是基于maven风格的项目，再者不使用插件手动构建有利于理解项目的本质加深自己的印象。

(1) 那就开始创建一个maven项目，首先是勾上Create a sample project，如下图：

![](/img/maven.png)

然后next，填写Artifact里的GroupId、ArtifactId等，最后finish即可。
<!--more-->
(2) maven项目有了，然后是编写pom.xml。
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.vensing</groupId>
	<artifactId>springboot2</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>springboot2</name>
	<description>springboot2</description>


	<!-- 声明这是一个springboot的子项目,作用就是统一依赖管理，依赖的版本管理，插件管理，编译jdk版本管理等 -->
	<!-- repository/org/springframework/boot/spring-boot-starter-parent/版本号/spring-boot-starter-parent.pom -->
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>1.5.9.RELEASE</version>
	</parent>

	<dependencies>
		<dependency>
		<!-- 构建Web，包含RESTful风格框架SpringMVC和默认的嵌入式容器Tomcat -->
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>3.8.1</version>
			<scope>test</scope>
		</dependency>
	</dependencies>

	<properties>
		<java.version>1.8</java.version>
	</properties>
	
	<!-- 把项目打包成一个可执行的jar包 -->
	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

</project>
```

参照上面写即可，最重要的是`spring-boot-starter-parent`和`spring-boot-starter-web`，其中`spring-boot-starter-parent`声明这是一个springboot的子项目,作用就是统一依赖管理，依赖的版本管理，插件管理，编译jdk版本管理等。
可以去`repository/org/springframework/boot/spring-boot-starter-parent/版本号/spring-boot-starter-parent.pom`下打开文件查看其依赖内容。
`spring-boot-starter-web`是构建Web的基础，包含了RESTful风格框架SpringMVC和默认的嵌入式容器Tomcat。

*编写完pom.xml后记得maven-->update project。*

> ### 编写配置文件和代码

(3) 在`src/main/java `新建一个springboot的包，新建一个Application类，这是项目启动的入口：
```java
@SpringBootApplication
public class Application {
	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}
}
```
 `@SpringBootApplication `表示这是一个SpringBoot应用，运行其主方法就会启动tomcat,默认端口是8080。
 
(4) 在`src/main/java `新建一个springboot/web的包，新建一个HelloWorldController类：
```java
@Controller
public class HelloWorldController {
	
	@RequestMapping("/hello")
	@ResponseBody
	public String hello(){
		return "Hello World, Welcome to SpringBoot!";
	}
}
```

最后，选中Application类，Run as JavaApplication,查看控制台是否启动成功，最后在浏览器输入:`localhost:8080/hello`，看到`Hello World, Welcome to SpringBoot!`就说明成功了。
如果想改启动端口，在`src/main/resources `下新建application.properties：
 ```
 server.port=9090
 ```
之后运行其主方法可在控制台看到输出端口已变为9090:
![](/img/9090.png)


## SpringBoot的打包和部署

Springboot 部署通常会采用两种方式：全部打包成一个jar，或者打包成一个war。

> ### jar 包

命令行下进入项目的根路径，运行打包命令:
```
mvn install
```
在项目的target目录下会生成一个jar包。
之后运行项目：
```
java -jar target/springboot-0.0.1-SNAPSHOT.jar
```

![](/img/java_jar.png)
出现spring的banner就说明成功了。

> ###  war包

- 修改application类
加入@ServletComponentScan注解，并且继承SpringBootServletInitializer 。

```java
@SpringBootApplication
@ServletComponentScan
public class Application extends SpringBootServletInitializer{
 
	@Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }
	
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
 
}
```

- 修改pom.xml
打包成war的声明：
`<packaging>war</packaging>`

- 加入依赖：

```xml
 <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-tomcat</artifactId>
      <scope>provided</scope>           
 </dependency>
```

spring-boot-starter-tomcat修改为 provided方式，以避免和独立 tomcat 容器的冲突。provided 表示只在编译和测试的时候使用，打包的时候不会使用了。

- 打包
```
mvn clean package
```

在target下会清除之前的jar包，生成war包。复制war到一个指定目录，然后解压war包。Eclispe下new server，选择Add External Web Module再配置下server的信息：
![](/img/modules.png)
指定为刚才解压war的目录，指定path为boot。最后启动server项目，浏览器下访问localhost:8080/boot/hello

若在项目中的application.properties配置了端口号，在此处也不会生效。因为实际上是部署到另外的tomcat了而没使用到内嵌的tomcat，这里部署的tomcat是默认8080端口。

或者把war包直接复制到本地tomcat的webapps下，startup.bat启动tomcat也行，上下文路径path为war包的文件名。

