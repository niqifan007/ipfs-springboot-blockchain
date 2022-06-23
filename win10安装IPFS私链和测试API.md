# win10安装IPFS私链和测试API
## 其他系统的可以参照[此处（需要翻墙）](https://docs.ipfs.io/install/command-line/#system-requirements)

1.从以下位置下载 Windows 二进制文件
```bash
cd ~\
wget https://dist.ipfs.io/go-ipfs/v0.13.0/go-ipfs_v0.13.0_windows-amd64.zip -Outfile go-ipfs_v0.13.0.zip
```

2.解压缩文件并将其移动到方便的地方。

```bash
Expand-Archive -Path go-ipfs_v0.13.0.zip -DestinationPath ~\Apps\go-ipfs_v0.13.0
```

3.进入`go-ipfs_v0.13.0`文件夹并检查是否`ipfs.exe`有效：

```bash
cd ~\Apps\go-ipfs_v0.13.0\go-ipfs
.\ipfs.exe --version

> ipfs version 0.12.0
```

虽然您现在可以使用 IPFS，但最好使用以下步骤添加`ipfs.exe`到您的 IPFS`PATH`环境变量

4.通过转到您的主文件夹并询问 IPFS 版本来测试您的 IPFS 路径是否设置正确：

```bash
cd ~
ipfs --version

> ipfs version 0.12.0
```

## 设置IPFS

1.打开当前window的ipfs安装包的命令行终端。（即在安装包路径下输入cmd）

2.选择是否设置仓库路径，不设置则默认在c盘。

```bash
#切换当前路径
cd /d %~dp0
#修改仓库路径
setx IPFS_PATH D:\IPFS
```

3.ipfs仓库初始化。

```bash
#初始化仓库
ipfs init
```

4.生成秘钥

生成私有密钥

搭建IPFS私有网络，首先需要使所有节点共享一个密钥swarm.key。

密钥生成工具下载地址：

https://github.com/Kubuxu/go-ipfs-swarm-key-gengithub.com
1）解压

![1a5d0f94abcbc5b3861a00b1f07a5c9f.png](https://img-blog.csdnimg.cn/img_convert/1a5d0f94abcbc5b3861a00b1f07a5c9f.png)

2）编译

![35db3c03906479e74128702fccd23900.png](https://img-blog.csdnimg.cn/img_convert/35db3c03906479e74128702fccd23900.png)

go build执行成功后，将会生成main.exe

![81883a6bd7576e1659a7710e6b4e822e.png](https://img-blog.csdnimg.cn/img_convert/81883a6bd7576e1659a7710e6b4e822e.png)

3）生成swarm.key

![7bf83c1b12cb6e0e30915a02ea3b7cdf.png](https://img-blog.csdnimg.cn/img_convert/7bf83c1b12cb6e0e30915a02ea3b7cdf.png)

执行成功后，得到swarm.key

![1c286c8b7c107230621e2069c4ce0fef.png](https://img-blog.csdnimg.cn/img_convert/1c286c8b7c107230621e2069c4ce0fef.png)

swarm.key的内容如下

```
/key/swarm/psk/1.0.0/
/base16/
315f44eb464bea24c5bf8ad492a6f99f1b86d5c6b0f824ea5069bc89d8c0d46f
```

5.复制swarm.key，该key需放在安装包下，在初始化仓库之后，存放于仓库之下。

6.删除bootstrap的所有共用节点。

```bash
#删除所有节点
ipfs bootstrap rm all
```

7.查看本机的ipfs节点

```bash
[root@localhost go-ipfs]# ipfs id
{
        "ID": "12D3KooWMh6eqFVSEgotLyZPFvhZpadYzyN23vZK2yBSpzogBGxu",
        "PublicKey": "CAESILBvoj7rWdH8AQ6M++06Ze9nLiHqWCODUlyGzwr5Hk5G",
        "Addresses": null,
        "AgentVersion": "go-ipfs/0.10.0/",
        "ProtocolVersion": "ipfs/0.1.0",
        "Protocols": null
}

[root@localhost go-ipfs]# 
```

**记录下ID**

8.通过config配置API，GATEWAY，Bootstrap的配置，其中节点的添加也在此操作中。

```bash
#配置config，ip地址填入私有的ipfs网络地址。ipfsId为节点ID。
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin [\"*\"]
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods "[\"PUT\", \"GET\", \"POST\"]"
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials "[\"true\"]"
ipfs config --json Gateway.HTTPHeaders.Access-Control-Allow-Methods "[\"PUT\", \"GET\", \"POST\"]"
ipfs config --json Bootstrap "[\"/ip4/{IP地址}/tcp/4001/ipfs/{ipfsID}\"]"
```

也可以通过命令加入本机节点

```bash
$ ipfs bootstrap add /ip4/xxxx.xxxx.xxxx.xxxx/tcp/4001/p2p/12D3KooWSPP48SCHdrhC34cmjJL5p6Kp1Ay8yv8CNd6gN4x5gm8k
```

查看本机ip地址在cmd中

```
ipcongif
```

9.运行ipfs.exe，可通过命令ipfs daemon。

```bash
#启动ipfs
start /b ipfs daemon
```

## 结束运行，删除仓库

```bash
#结束运行ipfs
taskkill /im ipfs.exe /f

#删除仓库
rd/s/q D:\IPFS
```

## 测试API

下载 [这个](https://github.com/niqifan007/ipfs-springboot-blockchain)SpringBoot源码并在IDEA中编译运行

spring配置文件

![配置文件](https://s3.bmp.ovh/imgs/2022/06/23/3c05a186c84f5cb0.png)

### postman测试上传

![postman](https://s3.bmp.ovh/imgs/2022/06/23/dd5930eb8874276f.png)

成功会返回CID（哈希）

### 下载文件

1.（只能返回文件数据，不能保存下载，之后再看，没弄懂）![下载文件](https://s3.bmp.ovh/imgs/2022/06/24/8b97bebfec378523.png)

2.浏览器访问：http://localhost:8080/ipfs/文件哈希