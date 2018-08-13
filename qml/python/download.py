#!/usr/bin/env python3

import threading
from queue import Queue
import urllib.request
import os
# import shutil
import time
# import random

import time
import urllib
import pyotherside

URL = 'https://speed.hetzner.de/100MB.bin'#for testing
_downloaddirectory = '/tmp'
_numberofworkers = 1
_queue = Queue()


def get_name(url):
    try:
        return url[url.rindex('/') + 1:]
    except ValueError:
        print('Error: URL incorrect: %s' % url)


def get_name_free(dst_file):
    extend = 0

    if os.path.exists(dst_file):
        while True:
            extend += 1
            if not os.path.exists(dst_file + '.%s' % extend):
                dst_file += '.%s' % extend
                break

    return dst_file

def reportprogress(count, block_size, total_size):
    global start_time
    if count == 0:
        start_time = time.time()
        return
    if count % 100 == 0: #throttle output
        duration = time.time() - start_time
        progress_size = int(count * block_size)
        speed = int(progress_size / (1024 * duration))
        percent = min(int(count * block_size * 100 / total_size),100)
        pyotherside.send('downloadstate', _queue.qsize(), percent, progress_size, speed, duration)
        # print(_queue.qsize(), percent,'%', progress_size / (1024 * 1024),'MB', speed, 'kb/s', duration, 'seconds')
    

def download(url):
    dst_file = os.path.join(_downloaddirectory, get_name(url))

    os.makedirs(os.path.dirname(dst_file), exist_ok=True)
    # dst_file = get_name_free(os.path.join(_downloaddirectory, get_name(url)))
    if os.path.exists(dst_file):
        print('file exists', dst_file)
    else:
        urllib.request.urlretrieve(url, dst_file, reportprogress)


def worker():
    while True:
        # pyotherside.send('download_worker')
        if not _queue.empty():
            # print('Get queue')
            # pyotherside.send('download_getqueue')
            url = _queue.get()
            # pyotherside.send('download_queueurl', url)
            download(url)
            pyotherside.send('downloaddone', url)
            _queue.task_done()
        else:
            # pyotherside.send('downloadsempty')
            time.sleep(2)

def add(url):
    print('adding', url)
    pyotherside.send('downloadadd',  url, _downloaddirectory)
    # print('approx size:', _queue.qsize(), 'emtpy?', _queue.empty())
    _queue.put(url)


def setdownloaddir(dir):
    global _downloaddirectory
    _downloaddirectory = dir

def start():

    pyotherside.send('downloadstart')
    # _queue.join()


for w in range(_numberofworkers):
    t = threading.Thread(target=worker, name='worker-%s' % w)
    t.start()
