#!/usr/bin/env bash

base_path=`echo $(cd "$(dirname "$0")"; pwd)`
apk_path="build/outputs/apk/"
dest_path="/tmp/m/$RANDOM/"

function findApk() {
    echo ${base_path}/../${1}/${apk_path}${1}-debug.apk
}

function buildApk() {
  $base_path/../gradlew $1:clean $1:asDebug
  if [ $? != 0 ]; then
     echo "build fail"
     exit
  fi
}
function cpApk() {
    if [ -e $dest_path ]; then
        rm -rf $dest_path
    fi

    mkdir -pv $dest_path
    cp -pv $1 $dest_path

}


function unApk() {
   java -jar ${base_path}/apktool_2.2.3.jar d ${1} -o ${dest_path}/m2
}

function rmV4() {
    rm -rfv $dest_path/m2/smali/android/support/v4
}

function reApk() {
    java -jar ${base_path}/apktool_2.2.3.jar b $dest_path/m2 -f -o ${dest_path}/m3.apk
}

function uploadApk() {
   adb push $dest_path/m3.apk /sdcard/Android/data/com.mx.browser.star/cache/filemanager.apk
#   adb push $dest_path/m3.apk /sdcard/Android/data/com.mx.browser.star/cache/$1.apk
}

function main() {
   module_name=$1
   module_path=`findApk $module_name`
   echo $module_path

   buildApk $module_name
   cpApk $module_path
   unApk $dest_path/${module_name}-debug.apk
   rmV4
   reApk
   uploadApk $module_path
}

function handleApk() {
   src_apk=$1
   dest_apk=$2

   unApk $src_apk
   rmV4
   reApk
   ls -lh ${dest_path}/m3.apk
   echo $dest_apk

   cp  ${dest_path}/m3.apk $dest_apk


}


help="$0  -m filemanager -s /tmp/a.apk -d /tmp/b.apk"
if [ $# == 0 ]; then
    echo $help
    exit
fi

while getopts "m:hs:d:" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             m)
                module_name=$OPTARG
                ;;
             s)
               src_apk=$OPTARG
               ;;
             d)
               dest_apk=$OPTARG
               ;;
             h)
                echo $help
                exit 1
               ;;
             ?)
                echo $help
                exit 1
                ;;
        esac
done
echo $module_name
echo $src_apk
echo $dest_apk

if [ ! -z $module_name ]; then
  echo "hello world"
  main $module_name
fi

if [ ! -z $src_apk ]; then
#  echo "haha"
   if [ ! -z $dest_apk ]; then
       handleApk $src_apk $dest_apk
   else
       echo "dest_apk can not empty!"
   fi
fi


#main $module_name