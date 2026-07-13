#!/bin/sh
# Ombre Brain + Gateway 合体启动:同一容器,同一卷,数据同源
# 任一进程退出则整个容器退出,交给平台重启,避免半死状态

python gateway.py &
GATEWAY_PID=$!

python server.py &
BRAIN_PID=$!

# 等任意一个先退出
wait -n $BRAIN_PID $GATEWAY_PID 2>/dev/null || wait $BRAIN_PID

# 收尾:把另一个也带走
kill $BRAIN_PID $GATEWAY_PID 2>/dev/null
exit 1
