#!/usr/bin/python3
import logging
import sys, os
import subprocess
from time import sleep, perf_counter

# logging.basicConfig(level=logging.DEBUG)

sys.path.append(os.path.abspath('./Yi4kAPI'))

import Yi4kAPI
from Yi4kAPI import *

def notificationCB(result):
    print('notificationCB', result);
    # pyotherside.send("notification", result)


camera= YiAPI()

# wrap camera.cmd to use pyotherside methods later
def cmd(commandName, arg=None):
    result= camera.cmd(getattr(Yi4kAPI, commandName), arg)
    print('wrapped response', commandName, result)
    # pyotherside.send("callback", result)
    # pyotherside.send("callback%s" % str(commandName), result)
    return result

# set up callbacks
for event in ['start_video_record', 'video_record_complete', 'start_photo_capture', 'photo_taken', 'vf_start', 'vf_stop', 'enter_album', 'exit_album', 'battery', 'battery_status', 'adapter', 'adapter_status', 'sdcard_format_done', 'setting_changed']:
    camera.setCB('event_'+event, notificationCB)



##### playground


## capture photo
# res= cmd('capturePhoto')
# print('capturePhoto direct response: %s' % str(res))

## get file names on camera
files= cmd('getFileList')
for file in files:
    # print(file)
    for key in file: # sub directory
        subfiles=cmd('getFileList', key)
        for subfile in subfiles:
            print(subfile)



## commands:
# startRecording
# stopRecording
# capturePhoto
# getFileList
# deleteFile
# startViewFinder
# stopViewFinder
# getSettings
# setDateTime
# setSystemMode
# getVideoResolution
# setVideoResolution
# getPhotoResolution
# setPhotoResolution
# getPhotoWhiteBalance
# setPhotoWhiteBalance
# getVideoWhiteBalance
# setVideoWhiteBalance
# getPhotoISO
# setPhotoISO
# getVideoISO
# setVideoISO
# getPhotoExposureValue
# setPhotoExposureValue
# getVideoExposureValue
# setVideoExposureValue
# getPhotoShutterTime
# setPhotoShutterTime
# getVideoSharpness
# setVideoSharpness
# getPhotoSharpness
# setPhotoSharpness
# getVideoFieldOfView
# setVideoFieldOfView
# getRecordMode
# setRecordMode
# getCaptureMode
# setCaptureMode
# getMeteringMode
# setMeteringMode
# getVideoQuality
# setVideoQuality
# getVideoColorMode
# setVideoColorMode
# getPhotoColorMode
# setPhotoColorMode
# getElectronicImageStabilizationState
# setElectronicImageStabilizationState
# getAdjustLensDistortionState
# setAdjustLensDistortionState
# getVideoMuteState
# setVideoMuteState
# getVideoTimestamp
# setVideoTimestamp
# getPhotoTimestamp
# setPhotoTimestamp
# getLEDMode
# setLEDMode
# getVideoStandard
# setVideoStandard
# getTimeLapseVideoInterval
# setTimeLapseVideoInterval
# getTimeLapsePhotoInterval
# setTimeLapsePhotoInterval
# getTimeLapseVideoDuration
# setTimeLapseVideoDuration
# getScreenAutoLock
# setScreenAutoLock
# getAutoPowerOff
# setAutoPowerOff
# getVideoRotateMode
# setVideoRotateMode
# getBuzzerVolume
# setBuzzerVolume
# getLoopDuration
# setLoopDuration