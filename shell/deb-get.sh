#!/bin/bash

if [[ $# -lt 2 ]]; then
  echo "用法: $0 <软件包名称1> <软件包名称2> ... <目标目录>"
  exit 1
fi

DESTINATION="${@: -1}"

if [[ ! -d "$DESTINATION" ]]; then
  echo "目标目录不存在"
  exit 1
fi

for (( i=1; i<=$#-1; i++ ))
do
    PACKAGE="${!i}"
    apt-get clean all
    # apt-get download "$PACKAGE" -o "$DESTINATION"
    apt-get -y  install --download-only "$PACKAGE"
    mv /var/cache/apt/archives/*.deb "$DESTINATION"
    apt-get clean all
done