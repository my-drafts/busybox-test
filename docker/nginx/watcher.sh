#!/bin/sh

nginx_conf="/etc/nginx/nginx.conf"
nginx_config_changed=8
nginx_watcher_sleep=4

nginx_config_last () {
  last=0;
  #configs=$(ls $(cat ${nginx_conf} | grep -E "include .*[\.]conf" | awk '{ print $2 }' | sed 's/;$//'));
  configs=$( ls $( cat ${nginx_conf} | grep -E "include .*[\.]conf" | sed -E 's/^.*include[ \t]*//' | sed -E 's/;.*$//' ) );
  for file in ${configs}; do
    modified=$(date -r ${file} +'%s');
    if [ ${modified} -gt ${last} ]; then
      last=${modified};
    fi
  done
  echo ${last};
}

nginx_test () {
  if [ -z "$(nginx -tq 2>&1)" ]; then
    echo "OK";
  else
    echo "";
  fi
}

while [ true ];
do
  if [ -n $(nginx_test) ]; then
    pids=$(ps | grep -E 'nginx[\:]' | awk '{ print $1 }');
    start=$(date -r  $(ls $(cat ${nginx_conf} | grep .pid | awk '{ print $2 }' | sed 's/;$//')) +'%s');
    last=$(nginx_config_last);
    diff=$(( ${last} - ${start} ));
    #echo "${last} ${start} ${diff} $([ ${diff} -gt ${nginx_config_changed} ])";
    if [ -z "${pids}" ]; then
      nginx &
    elif [ ${diff} -gt 10 ]; then
      #echo "${pids}";
      kill -9 ${pids};
      nginx &
    fi
  fi
  sleep ${nginx_watcher_sleep}
done
echo "";

