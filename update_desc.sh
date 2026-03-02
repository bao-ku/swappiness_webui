#!/system/bin/sh
MODDIR=${0%/*}
CURRENT=$(cat /proc/sys/vm/swappiness)
STATIC_DESC="通过控制Swappiness权重调整内存压缩算法的激进程度，数字越大越偏向压缩内存"
sed -i "s/^description=.*/description=$STATIC_DESC [当前:$CURRENT]/" $MODDIR/module.prop