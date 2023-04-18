## 安装前准备
### 1, 选版本
```text
http://hbase.apache.org/book.html#basic.prerequisites
确定分配安装Hdoop-3.3.2、Hbase -2.4.12、JDK 1.8
```

### 2, 设置SSH免登陆
```text
2.1 首先修改主机名称 vim /etc/hosts
xxx.xxx.xx.xx   slave
xxx.xxx.xx.xx   slave1
xxx.xxx.xx.xx   slave2
 
2.2 修改主机名称为对应的设置。如slave
2.3 安装jdk 1.8、配置环境变量并生效
2.4 免登陆配置
    免密码登录本机
    1）生产秘钥  ssh-keygen -t rsa
    2）将公钥追加到”authorized_keys”文件 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    3）赋予权限  chmod 600 .ssh/authorized_keys
    4）验证本机能无密码访问   ssh slave   
2.5 然后依次配置salve1、salve2无密码访问

2.6 配置完成后, 主节点本机无密码登录slave1, 以salve无密码登录slave1为例进行讲解：
    1）登录slave1 , 复制slave服务器的公钥”id_rsa.pub”到slave1服务器的”root”目录下。
        scp -r /root/.ssh/id_rsa.pub slave1:/root 
    2）将slave的公钥（id_rsa.pub）追加到slave1的authorized_keys中
        cat id_rsa.pub >> .ssh/authorized_keys
        rm -rf  id_rsa.pub
    3）在slave上面测试
        ssh  slave1
    4）slave2同样操作即可

```
### 3, 设置域名
```text
vim /etc/hosts

IP   slave
IP   slave1
IP   slave2

```

## Hadoop-3.3.2部署
### 1, 下载
```text
Hadoop的使用分布式安装方式。下载地址：http://apache.claz.org/hadoop/common/hadoop-3.3.2/    
解压到安装位置tar -zxvf  hadoop-3.3.2.tar.gz  -C  /opt/app
```
### 2, 配置core-site.xml
```text
修改Hadoop核心配置文件/Hadoop-3.3.2/etc/hadoop/core-site.xml, 
通过fs.default.name指定NameNode的IP地址和端口号(表示HDFS的基本路径), 通过hadoop.tmp.dir指定hadoop数据存储的临时文件夹。
```
```shell
vim opt/app/hadoop-3.3.2/etc/hadoop/core-site.xml

<configuration>
<property>
    <name>hadoop.tmp.dir</name>
    <value>file:/data/hadoop/tmp</value>
    <description>Abase for other temporary directories.</description>
</property>
    <property>
    <name>fs.defaultFS</name>
    <value>hdfs://xluban.huawei.com:9000</value>
</property>
</configuration>
```
特别注意：如没有配置hadoop.tmp.dir参数, 此时系统默认的临时目录为：/tmp/hadoo-hadoop。而这个目录在每次重启后都会被删除, 必须重新执行format才行, 否则会出错。

### 3, 配置hdfs-site.xml
```text
修改HDFS核心配置文件/Hadoop-3.3.2/etc/hadoop/hdfs-site.xml, 
通过dfs.replication 指定HDFS的备份因子为3(表示数据块的备份数量, 不能大于DataNode的数量), 
通过dfs.name.dir 指定namenode节点的文件存储目录, 
通过dfs.data.dir 指定datanode节点的文件存储目录
```
```shell
vim opt/app/hadoop-3.3.2/etc/hadoop/ hdfs-site.xml

<configuration>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
    <property>
        <name>dfs.name.dir</name>
        <value>/data/hadoop/hdfs/name</value>
    </property>
    <property>
        <name>dfs.data.dir</name>
        <value>/data/hadoop/hdfs/data</value>
</property>
</configuration>

```
### 4, 配置mapred-site.xml
```shell
vim opt/app/hadoop-3.3.2/etc/hadoop/mapred-site.xml  

<configuration>
 <property>
      <name>mapreduce.framework.name</name>
      <value>yarn</value>
  </property>
   <property>
      <name>mapred.job.tracker</name>
      <value>http://hadoop-master:9001</value>
  </property>
</configuration>

```
### 5, 配置yarn-site.xml
yarn.resourcemanager.hostname：指定resourcemanager所启动的服务器主机名, 本机。
```shell
vim opt/app/hadoop-3.3.2/etc/hadoop/yarn-site.xml  

<configuration>
<!-- Site specific YARN configuration properties -->
      <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>xluban.huawei.com</value>
</property>
</configuration>

```
### 6, 配置masters文件
```text
修改/Hadoop-3.3.2/etc/hadoop/masters文件, 该文件指定namenode节点所在的服务器机器。删除localhost, 
添加namenode节点的主机名 demo.com, 不建议使用IP地址, 因为IP地址可能会变化, 但是主机名一般不会变化。
vi /Hadoop-3.3.2/etc/hadoop/masters
## 内容
demo.com
```
### 7, 配置workers文件（Master主机特有）
```text
修改/opt/Hadoop-3.3.2/etc/hadoop/workers文件, 该文件指定哪些服务器节点是datanode节点。
删除locahost, 添加所有datanode节点的主机名, 如下所示。
vim /opt/Hadoop-3.3.2/etc/hadoop/workers
## 内容
demo.com
conehadoop-slave1
```
### 8, 配置hadoop-env.sh文件
配置 Hadoop 依赖的 JAVA_HOME 修改配置 hadoop-env.sh,添加如下
```shell
vim  hadoop-env.sh

export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
```

### 9, 压缩配置好的hadoop
创建目录:
```shell
mkdir -p /data/hadoop/tmp 
mkdir -p /data/hadoop/hdfs/name (此目录确实会导致hbase无法创建namespace)
mkdir -p /data/hadoop/hdfs/data
mkdir -p /opt/app/hadoop-3.3.2/logs

tar -zcvf hadoop-3.3.2.tar.gz /opt/app/hadoop-3.3.2
scp -r /opt/app/hadoop-3.3.2.tar.gz 节点名称:/opt/app 
```
然后分别解压并配置环境变量使之生效
```shell
vim /etc/profile

#export hadoop_home
export JAVA_HOME=/usr/local/jdk1.8.0_171
export HADOOP_HOME=/opt/app/hadoop-3.3.2
export PATH=$PATH:$JAVA_HOME:$HADOOP_HOME/bin

source /etc/profile
```

### 10, 验证Hadoop安装
下面的步骤是用来验证Hadoop的安装。
#### 第1步 - 名称节点设置
设置名称节点使用“hdfs namenode -format”命令如下
```shell
$ cd ~
$ hdfs namenode -format
```
预期的结果如下
```shell
10/24/14 21:30:55 INFO namenode.NameNode: STARTUP_MSG:
/************************************************************
STARTUP_MSG: Starting NameNode
STARTUP_MSG: host = localhost/192.168.1.11
STARTUP_MSG: args = [-format]
STARTUP_MSG: version = 2.4.1
...
...
10/24/14 21:30:56 INFO common.Storage: Storage directory
/home/hadoop/hadoopinfra/hdfs/namenode has been successfully formatted.
10/24/14 21:30:56 INFO namenode.NNStorageRetentionManager: Going to
retain 1 images with txid >= 0
10/24/14 21:30:56 INFO util.ExitUtil: Exiting with status 0
10/24/14 21:30:56 INFO namenode.NameNode: SHUTDOWN_MSG:
/************************************************************
SHUTDOWN_MSG: Shutting down NameNode at localhost/192.168.1.11
************************************************************/ 
```

#### 第2步 - 验证Hadoop DFS
下面的命令用来启动DFS。执行这个命令将启动Hadoop文件系统。
```shell
nohup /opt/app/hadoop-3.3.2/sbin/start-dfs.sh  > /opt/app/hadoop-3.3.2/logs/start-dfs-log.log  2>&1 &
```
预期的结果如下
```shell
10/24/14 21:37:56
Starting namenodes on [localhost]
localhost: starting namenode, logging to /home/hadoop/hadoop-
2.4.1/logs/hadoop-hadoop-namenode-localhost.out
localhost: starting datanode, logging to /home/hadoop/hadoop-
2.4.1/logs/hadoop-hadoop-datanode-localhost.out
Starting secondary namenodes [0.0.0.0]
```
#### 第3步 - 验证Yarn脚本
下面的命令用来启动yarn脚本。执行此命令将启动yarn守护进程。
```shell
nohup /opt/app/hadoop-3.3.2/sbin/start-yarn.sh  > /opt/app/hadoop-3.3.2/logs/start-yarn-log.log  2>&1 &
```
预期的结果如下
```shell
starting yarn daemons
starting resourcemanager, logging to /home/hadoop/hadoop-
2.4.1/logs/yarn-hadoop-resourcemanager-localhost.out
localhost: starting nodemanager, logging to /home/hadoop/hadoop-
2.4.1/logs/yarn-hadoop-nodemanager-localhost.out 
```
#### 第4步 - 访问Hadoop上的浏览器
访问Hadoop的默认端口号为9864。使用以下网址, 以获取Hadoop服务在浏览器中。  
http://localhost:9864 

## Habse-2.4.12部署
需要依赖zk, 没有需要先装zk
### 1, 下载包
下载地址http://archive.apache.org/dist/hbase/。
```shell
tar -zxvf  /opt/app/hbase-2.4.12-bin.tar.gz -C /opt/app
```
### 2, 配置 hbase-env.sh
```shell
export JAVA_HOME=/usr/local/jdk1.8.0_171/
# hbase配置文件的位置

export HBASE_HOME=/opt/app/hbase-2.4.12
export HBASE_CLASSPATH=/opt/app/hadoop-3.3.2/etc/hadoop
export HADOOP_HOME=/opt/app/hadoop-3.3.2
# 配置hbase的pid目录

export HBASE_PID_DIR=/opt/app/hbase-2.4.12/pids

# 如果使用独立安装的zookeeper, 这个地方就是false, 不使用内部的zookeeper, 而是使用自己外部搭建的zookeeper集群
export HBASE_MANAGES_ZK=false

```
### 3, 配置 hbase-site.xml
```xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
  <name>hbase.tmp.dir</name>
  <value>./tmp</value>
</property>

<property>
  <name>hbase.unsafe.stream.capability.enforce</name>
  <value>false</value>
</property>

# hbasemaster的主机和端口
<property>
  <name>hbase.master</name> 
  <value>xluban.huawei.com:60000</value>
</property>

# 时间同步允许的时间差
<property>
  <name>hbase.master.maxclockskew</name>
  <value>180000</value>
</property>

# hbase共享目录, 持久化hbase数据
<property>
  <name>hbase.rootdir</name>
  <value>hdfs://xluban.huawei.com:9000/hbase</value>
</property>
    
# 是否分布式运行, false即为单机
<property>
  <name>hbase.cluster.distributed</name>
  <value>true</value>
</property>

# zookeeper地址
<property>
  <name>hbase.zookeeper.quorum</name>
  <value>xxx</value>
</property>

# 端口
<property>
  <name>hbase.zookeeper.property.clientPort</name>
  <value>2181</value>
</property>
    
# zookeeper配置信息快照的位置
<property>
  <name>hbase.zookeeper.property.dataDir</name>
  <value>/data/hbase/tmp/zookeeper</value>
</property>
    
<property>
  <name>hbase.wal.provider</name>
  <value>filesystem</value>
</property>

</configuration>

```
### 4, 配置 regionservers
```shell
demo.com
xxx.xxx.xx.xxx

```

### 5, 配置好以后压缩传输到slave, 然后加压
```shell
tar -zcvf  hbase-2.4.12.tar.gz  /opt/app/hbase-2.4.12
scp -r /opt/app/hbase-2.4.12.tar.gz conehadoop-slave1:/opt/app
tar -zxvf /opt/app/hbase-2.0.4.tar.gz -C /opt/app


mkdir -p  /data/hbase/tmp/zookeeper
mkdir -p  /opt/app/hbase-2.4.12/logs
```

### 6, 配置环境变量并生效
```shell
vim /etc/profile

#export Hbase_home
export HBASE_HOME=/opt/app/hbase-2.4.12
export PATH=:$PATH:$HBASE_HOME/bin

source /etc/profile
```
### 7, 启动hbase
```shell
nohup /opt/app/hbase-2.4.12/bin/start-hbase.sh >> /opt/app/hbase-2.4.12/logs/hbase-log.log 2>&1 &
```
### 8, 访问
http://xxx:16010/master-status


