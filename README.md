# ue4_background
使用sh start.sh 启动服务器 sh start.sh 1启动节点1 sh start.sh 2启动节点2，节点开启的端口写在config文件里<br>
目前的功能都在节点一，其开启的端口为8001，8002，可任选一连接，同个端口可连接多个客户端<br>
若要开启二节点，需先开一节点，因agentmgr服务在节点一<br>
消息指令的格式为cmd,msg/n。 比如登录，其消息为login,用户id,密码/n。<br>
获取前十日车流数据这种不需要参数的指令，就直接发送msg/n，比如发送get_ten_recent_access_records/n，即可收到回传的proto<br>
