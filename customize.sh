#!/system/bin/sh
set_perm $MODPATH/service.sh      0 0 0755
set_perm $MODPATH/update_desc.sh  0 0 0755
set_perm $MODPATH/zram_resize.sh  0 0 0755
set_perm_recursive $MODPATH/webroot 0 0 0755 0644
ui_print "✅ zRam调度模块安装成功（仅临时修改模式）"
ui_print "✅ 作者QQ:2752960739"
ui_print "请在 KernelSU 管理器中点击模块卡片进入 WebUI 进行配置。"