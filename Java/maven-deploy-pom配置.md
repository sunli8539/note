## maven-deploy到私有仓库
```xml
<distributionManagement>
        <repository>
            <id>xx</id>
            <name>xx</name>
            <url>https://xx/</url>
        </repository>
        <snapshotRepository>
            <id>xx</id>
            <name>xx</name>
            <url>https://xx/</url>
        </snapshotRepository>
</distributionManagement>

<build>
    <plugins>
        <!--编译,需要指定目标版本  各自项目中需要指定 <maven.compiler.source> <maven.compiler.target>-->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
        </plugin>
        <!--代码推送到私服-->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-deploy-plugin</artifactId>
        </plugin>
        <!--源码发布到仓库中-->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-resources-plugin</artifactId>
        </plugin>
        <!--打包文件 tar.gz zip war 等-->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-assembly-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```
