#!/system/bin/sh
# zram大小调整脚本（修正最小值为1GB）
MODDIR=${0%/*}
LOG="$MODDIR/zram_resize.log"

# 确保日志文件可写
touch "$LOG" 2>/dev/null || LOG="/dev/null"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG"
}

log "===== 脚本启动 ====="
log "原始参数: '$1'"

# 清理参数：只保留数字
CLEAN_ARG=$(echo "$1" | tr -cd '0-9')
log "清理后参数: '$CLEAN_ARG'"

if [ -z "$CLEAN_ARG" ]; then
    echo "❌ 错误：未提供大小参数"
    log "❌ 未提供参数"
    exit 1
fi

NEW_SIZE="$CLEAN_ARG"
# 1GB = 1073741824 字节，16GB = 17179869184 字节
MIN_SIZE=1073741824   # 1GB
MAX_SIZE=17179869184  # 16GB

# 使用 expr 进行大数比较（不会受 shell 整数限制）
if expr "$NEW_SIZE" \< "$MIN_SIZE" >/dev/null 2>&1; then
    echo "❌ 错误：大小不能小于 1GB（$MIN_SIZE 字节）"
    log "❌ 小于最小值: $NEW_SIZE < $MIN_SIZE"
    exit 1
fi

if expr "$NEW_SIZE" \> "$MAX_SIZE" >/dev/null 2>&1; then
    echo "❌ 错误：大小不能大于 16GB（$MAX_SIZE 字节）"
    log "❌ 大于最大值: $NEW_SIZE > $MAX_SIZE"
    exit 1
fi

log "参数验证通过，大小: $NEW_SIZE 字节"

ZRAM_DEV="/dev/block/zram0"
SYSFS="/sys/block/zram0"

# 检查设备
if [ ! -e "$SYSFS" ]; then
    echo "❌ 未找到 zram 设备"
    log "❌ 设备不存在"
    exit 1
fi

# 如果当前被用作 swap，尝试关闭
if grep -q "$ZRAM_DEV" /proc/swaps; then
    log "正在关闭 swap..."
    swapoff "$ZRAM_DEV" >> "$LOG" 2>&1
    if [ $? -ne 0 ]; then
        echo "❌ 无法关闭 swap，可能正在使用中"
        log "❌ swapoff 失败"
        exit 1
    fi
fi

# 重置 zram（先写 0 再写 1）
log "重置 zram 设备..."
echo 0 > "$SYSFS/disksize" 2>> "$LOG"
echo 1 > "$SYSFS/reset" 2>> "$LOG"
sleep 0.2

# 设置新大小
log "写入新大小: $NEW_SIZE"
echo "$NEW_SIZE" > "$SYSFS/disksize" 2>> "$LOG"
if [ $? -ne 0 ]; then
    echo "❌ 写入 disksize 失败"
    log "❌ 写入失败"
    exit 1
fi

# 创建 swap 文件系统
mkswap "$ZRAM_DEV" >> "$LOG" 2>&1
if [ $? -ne 0 ]; then
    echo "❌ mkswap 失败"
    log "❌ mkswap 失败"
    exit 1
fi

# 启用 swap
swapon "$ZRAM_DEV" >> "$LOG" 2>&1
if [ $? -ne 0 ]; then
    echo "❌ swapon 失败"
    log "❌ swapon 失败"
    exit 1
fi

# 使用 awk 进行大数除法（显示为 GB）
NEW_SIZE_GB=$(awk "BEGIN {printf \"%.1f\", $NEW_SIZE/1073741824}")
echo "✅ zram 大小已调整为 $NEW_SIZE_GB GB ($NEW_SIZE 字节)"
log "✅ 调整成功，新大小: $NEW_SIZE_GB GB"
log "===== 脚本结束 ====="
exit 0