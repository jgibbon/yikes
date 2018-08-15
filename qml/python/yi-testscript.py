#!/usr/bin/python3

import sys, os
import subprocess
from time import sleep, perf_counter

import logging
logging.basicConfig(level=logging.DEBUG)


sys.path.append(os.path.abspath('./YiAPI'))

import Yi4kAPI
from Yi4kAPI import *

if __name__ == "__main__":
    camera= YiAPI()
#    print(camera.rtsp)
#    options=camera.cmd(getSettingOptions, 'capture_mode')
#    print(options)
#    print(camera.cmd(getSettingOptions,))
    print('normal')
#    camera.cmd(setCaptureMode, 'precise quality')
    print('raw')
    camera.cmd(setRawSetting, {'param':'precise quality', 'type':'capture_mode'})
#    camera.cmd(capturePhoto)
#    subprocess.call(['vlc', camera.rtsp, '--network-caching', '2000'])
