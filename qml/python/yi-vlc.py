#!/usr/bin/python3

import sys, os
import subprocess
from time import sleep, perf_counter

sys.path.append(os.path.abspath('./Yi4kAPI'))

import Yi4kAPI
from Yi4kAPI import *

if __name__ == "__main__":
	camera= YiAPI()
	print(camera.rtsp)
	subprocess.call(['vlc', camera.rtsp, '--network-caching', '2000'])