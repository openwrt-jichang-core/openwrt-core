架构查询
uname -m
ubus call system board
编译
启用 JSON v2 的步骤

设置环境变量：在构建或运行时，设置 GOEXPERIMENT=jsonv2 环境变量。例如：

export GOEXPERIMENT=jsonv2


或者在构建时直接设置：

GOEXPERIMENT=jsonv2 go build


这将启用 JSON v2 实验性 API。

```sh
killall ppsingbox
killall sh
```

# OpenWRT 常用指令脚本说明
```sh
wget -c -t 5 -T 30 -O /etc/init.d/dns https://github.com/openwrt-jichang-core/openwrt-core/releases/download/0.6/pp_2.sh
chmod +x /etc/init.d/dns
/etc/init.d/dns enable
/etc/init.d/dns start


```

本页整理了一些在 OpenWRT 上常用的操作指令，方便日常维护与调试使用。

---

## 📦 更新软件源

```sh
opkg update
```

---
## 删除配置
```sh
rm /root/cf.sh
rm /tmp/V2bX
rm /tmp/cf.log
rm /tmp/cf_debug.log
rm /tmp/config.json
rm /tmp/pp.log
rm /etc/init.d/dns
rm /etc/cf.sh
```

## ⚙️ 修改 OpenWRT 页面端口

手动编辑配置文件：

```sh
vi /etc/config/uhttpd
```

---

## 🔁 重启 uhttpd 服务

```sh
/etc/init.d/uhttpd restart
```

---

## 🔥 重启防火墙

```sh
/etc/init.d/firewall restart
```

---

## 🧩 设置自定义 DNS 服务脚本

编辑启动脚本文件（自行添加内容）：

```sh
vi /etc/init.d/dns
```

添加完成后，设置开机启动并立即启动：

```sh
/etc/init.d/dns enable
/etc/init.d/dns start
```
## 给权限
```sh
chmod +x /etc/init.d/dns
```
---

## 🧪 测试 DDNS 临时进程运行

```sh
/tmp/sbox server --config /tmp/config.json
```

---

## 🧹 快速清理命令

删除临时文件与服务脚本：

```sh
rm /tmp/sbox
rm /tmp/cf.sh
rm /tmp/config.json
rm /etc/init.d/dns
```

结束相关进程（请将 `[PID]` 替换为实际进程号）：

```sh
kill -9 [PID]
```

rm /tmp/V2bX_softfloat 
rm /etc/init.d/dns
rm /etc/init.d/DNS
rm /root/cf.sh
rm /tmp/config.json
rm /tmp/fullchain.pem
rm /tmp/privkey.pem
rm /tmp/V2bX
rm /tmp/ppsingbox
rm /tmp/cf.sh
rm /tmp/firewall.mssfix_module1
vi /etc/init.d/dns


chmod +x /etc/init.d/dns
/etc/init.d/dns enable
/etc/init.d/dns start


/tmp/V2bX server --config /tmp/config.json


/tmp/V2bX_softfloat server --config /tmp/config.json

cd /etc/init.d
cd /tmp

vi /etc/init.d/dns
zerotier1@333333338.xyz

---

> 📌 **注意：** 编辑文件、配置内容、脚本内容请根据具体需求修改，本 README 仅提供常用命令参考。
