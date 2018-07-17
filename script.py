import os, re, sys, time, socket
srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
srv.connect(("192.168.42.1", 7878))
get_token = '{"msg_id":257,"token":0}'
srv.send(get_token)
msg_with_token = srv.recv(512)
token = re.findall('"param":(.+?),',msg_with_token)[0]
get_battery = '{"msg_id":13,"token":%s}' %token
get_settings = '{"msg_id":3,"token":%s}' %token
sdcard_space ='{"msg_id":5,"type":"free","token":%s}' %token
clear_token = '{"msg_id":258,"token":%s}' %token
start_stream = '{"msg_id":259,"token":%s}' %token
stop_stream = '{"msg_id":260,"token":%s}' %token
start_recording = '{"msg_id":513,token":%s}' %token
stop_recording = '{"msg_id":514,token":%s}' %token
get_recording_time = '{"msg_id":515,token":%s}' %token
take_picture = '{"msg_id":769,token":%s}' %token


srv.send(take_picture)
srv.recv(512) #max needs increae 

