#!/system/bin/sh
# 开机后延迟执行 update_desc.sh，确保系统已就绪
# 此脚本仅更新模块描述，不修改任何系统参数

MODDIR=${0%/*}
LOG="$MODDIR/service.log"

# 记录启动时间
echo "$(date): service.sh started" > $LOG

# 延迟 15 秒后执行 update_desc.sh（可根据需要调整）
(
    sleep 30
    echo "$(date): executing update_desc.sh" >> $LOG
    sh $MODDIR/update_desc.sh >> $LOG 2>&1
    echo "$(date): update_desc.sh finished" >> $LOG
) &