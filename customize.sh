#!/system/bin/sh
echo "100" > $MODPATH/config.conf
set_perm $MODPATH/service.sh    0 0 0755
set_perm $MODPATH/update_desc.sh 0 0 0755
set_perm_recursive $MODPATH/webroot 0 0 0755 0644
ui_print "✅ 宝子zRam调度模块安装成功"
ui_print "✅ 作者QQ:2752960739"
ui_print "请在 KernelSU 管理器中点击模块卡片进入 WebUI 进行配置。"