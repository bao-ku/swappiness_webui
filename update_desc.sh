#!/system/bin/sh
MODDIR=${0%/*}
LOG="$MODDIR/update_desc.log"

echo "$(date): === 开始更新描述 ===" >> $LOG

# 获取当前 swappiness
CURRENT_SWAPP=$(cat /proc/sys/vm/swappiness 2>/dev/null || echo "?")
echo "$(date): swappiness = $CURRENT_SWAPP" >> $LOG

# 获取当前 zram 大小（字节），去除换行符
ZRAM_BYTES_RAW=$(cat /sys/block/zram0/disksize 2>/dev/null)
ZRAM_BYTES=$(echo -n "$ZRAM_BYTES_RAW" | tr -d '\n')
echo "$(date): zram bytes raw = '$ZRAM_BYTES_RAW'" >> $LOG
echo "$(date): zram bytes cleaned = '$ZRAM_BYTES'" >> $LOG

# 判断是否为有效的正数字符串（非空且不等于 "0"）
if [ -n "$ZRAM_BYTES" ] && [ "$ZRAM_BYTES" != "0" ]; then
    ZRAM_GB=$(awk "BEGIN {printf \"%.1f\", $ZRAM_BYTES/1073741824}" 2>>$LOG)
    ZRAM_DISP="${ZRAM_GB} GB"
    echo "$(date): zram = $ZRAM_DISP ($ZRAM_BYTES bytes)" >> $LOG
else
    ZRAM_DISP="未启用"
    echo "$(date): zram 未启用或读取失败" >> $LOG
fi

# 静态描述前缀
STATIC_DESC="通过控制Swappiness权重调整内存压缩算法的激进程度，数字越大越偏向压缩内存"

# 构造新描述
NEW_DESC="$STATIC_DESC [swappiness:$CURRENT_SWAPP] [zram:$ZRAM_DISP]"
echo "$(date): 新描述 = $NEW_DESC" >> $LOG

# 更新 module.prop
sed -i "s/^description=.*/description=$NEW_DESC/" $MODDIR/module.prop
if [ $? -eq 0 ]; then
    echo "$(date): module.prop 更新成功" >> $LOG
else
    echo "$(date): module.prop 更新失败" >> $LOG
fi
echo "$(date): === 更新结束 ===" >> $LOG