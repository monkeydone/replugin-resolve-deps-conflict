#目的
解决在使用replugin时,因为宿主和插件使用了相同的包,在宿主中调用插件,进行转化时遇到类冲突.

#方法
正常打包调试插件包,如果插件运行正常,准备放入宿主时,解压apk,然后删除冲突包,然后重新打包apk

#使用方法
> ./rm-v4.sh -s src_plugin.apk -d dest_plugin.apk

>./rm-v4.sh -p com.xx.xxxx -m file_plugin