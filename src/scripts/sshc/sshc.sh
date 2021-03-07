# 作者: 石晓旭
# 日期: 2021年03月05日
# 描述: 连接服务，在UBUNTU(20.04)系统，不提供在先安装了。
# 配置： user   ip  port    password    describe
#       root    192.168.1.2 22  123456  test1
#       root    192.168.1.3 22  123456  test2
#       root    192.168.1.4 22  123456  test3
#!/bin/bash

CONFIG=/etc/sshc/sshc.conf

if [[ -f $CONFIG ]]; then
    hostNum=$(cat $CONFIG | wc -l)
else
    echo "No sshc.conf , please create it and add server infos."
    exit
fi

while [ True ]; do
    echo -e "+++++++++++++++++++++ Servers +++++++++++++++++++++"
    awk -F' ' '{printf("%3d %s -> %s@%s:%d\n", NR,$5,$1,$2,$3)}' $CONFIG
    echo -e "++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -e "Enter ServerID at first column."
    echo -e "Enter q or Q to quit."
    read ServerID
    if [[ "$ServerID" == 'q' ]] || [[ "$ServerID" == 'Q' ]]; then
        exit
    elif [[ $ServerID -lt 1 ]] || [[ $ServerID -gt $hostNum ]]; then
        echo "Wrong ServerID is selected, Only $hostNum hosts are listed, please check."
        continue
    else
        break
    fi
done

user=""
host=""
port=""
passwd=""
eval $(awk -v ServerID=$ServerID -F' ' '{if (NR==ServerID) {printf("user=%s;host=%s;port=%d;passwd=%s;",$1,$2,$3,$4);}}' $CONFIG)
#echo $user, $host, $passwd
echo "login in $user@$host:$port"
expect -c "
    set timeout 30
    spawn ssh -p $port $user@$host
    expect {
        \"*yes/no\" { send \"yes\r\"; exp_continue }
        \"*?assword:\" { send \"$passwd\r\" }
    }
    interact
"
