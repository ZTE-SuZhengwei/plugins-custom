# -*- encoding: utf-8 -*-
#
# service status monitoring script
#
# Author: suzhengwei 10169307
#


import getopt
import sys
import os
import re

#定义返回值
STATE_OK = 0
STATE_WARNING = 1
STATE_CRITICAL = 2
STATE_UNKNOWN = 3

#读取输入参数
try:
    opts, args = getopt.getopt(sys.argv[1:], "s:h",["service=","help"])
except getopt.GetoptError:
    print "Usage:check_service_status.py -s servicename"

for key, value in opts:
    if key in ("-s", "--service"):
        service_name = value
    if key in ("-h", "--help"):
        print "Usage:check_service_status.py -s servicename"
        sys.exit(0)

#获取服务状态
service_active_cmd = "systemctl is-active " + service_name
service_active_result = re.match(r"\w+", os.popen(service_active_cmd).readline())
service_active_status = service_active_result.group(0)

#根据服务状态退出并打印信息
print "%s: %s"%(service_name, service_active_status)
if service_active_status == "active":
    sys.exit(0)
if service_active_status == "inactive":
    sys.exit(1)
if service_active_status == "unknown":
    sys.exit(3)