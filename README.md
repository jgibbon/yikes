# yikes
 [![yikes-logo](icons/86x86/yikes.png) yikes](https://github.com/jgibbon/yikes/) is an unofficial, bare-bones Sailfish OS application to interface with Yi Action Cameras.
It is primarily targeted towards the *Yi 4k Action Camera*, but with at least some features working on other models.
For example, recording Video or Photos with the *Yi Discovery* work, as does downloading media from the camera.
Other models may or may not work and are generally untested.

yikes is not an official product from or in any way related to Yi Technology.

[![video mode screen shot](https://i.imgur.com/iOF1TFKm.png)](https://i.imgur.com/iOF1TFK.png) 
[![photo mode screen shot](https://i.imgur.com/1TqqsIZm.png)](https://i.imgur.com/1TqqsIZ.png)

## Limitations
 - The Yi Action Camera API is not publicly documented, so all features may stop working completely in edge cases
 - Only the "most basic" use case is supported, at all. For example, you will only be able to connect with the camera 
 in "hot spot mode" with the standard IP address.
 - Most camera models are totally untested. You may get in touch with the authors of this application to sponsor other models which might help us to debug them. *No promises on actual progress, though.* ;)
 - The "Live" mode of newer firmware versions is and will remain unsupported.

## Features

Model | Modelname | Basic connection | Viewfinder stream | taking Photos | recording Videos | Media preview | read Settings | write Settings 
----- | --------- | ---------------- | ----------------- | ------------- | ---------------- | ------------- | ------------- | --------------
Xiaomi Yi Action Camera| <img src="https://oss.yitechnology.com/images/actioncamera2/firmware/image_action_camera.png" alt="drawing" width="100"/> | **Needs testing** | **Needs testing** | **Needs testing** |**Needs testing** | **Needs testing** | **Needs testing** | **Needs testing** | 
YI 4K Action Camera| <img src="https://oss.yitechnology.com/images/actioncamera2/firmware/image_action_camera_4k.png" alt="drawing" width="100"/> | **YES** | **YES** | **YES** | **YES** | **YES** | **YES** | **YES**
YI 4K+ Action Camera| <img src="https://oss.yitechnology.com/images/actioncamera2/firmware/image_action_camera_4kplus.png" alt="drawing" width="100"/> | **Needs testing** | **Needs testing** | **Needs testing** |**Needs testing** | **Needs testing** | **Needs testing** | **Needs testing** | 
YI Lite Action Camera| <img src="https://oss.yitechnology.com/images/actioncamera2/firmware/image_yilite_firmware-1.png" alt="drawing" width="100"/> | **Needs testing** | **Needs testing** | **Needs testing** |**Needs testing** | **Needs testing** | **Needs testing** | **Needs testing** | 
YI Discovery Action Camera| <img src="https://oss.yitechnology.com/images/discovery/J22icon.png" alt="drawing" width="100"/> | **YES** | **NO** | **YES** | **YES** | **YES** | **Needs testing** | **YES**

## Installation
### from source
You may clone this repository, open it in the Sailfish OS SDK and deploy it to your device. Keep in mind that you have to pull the python API, as well:
```
git clone --recurse-submodules https://github.com/jgibbon/yikes.git
```
### packaged
yikes is not ready for general use, yet. For now you can find builds that may or may not be current on [Nokius' OBS repository](http://repo.merproject.org/obs/home:/Nokius:/sfos-playground/sailfish_latest_armv7hl/noarch/). Other release channels may follow.

## Acknowledgements
This is a QML/Python application, using the fabulous [PyOtherside](https://github.com/thp/pyotherside) for Python/Qt bindings.
 
It would not be possible to without existing work at [Yi4kAPI](https://github.com/NikolayRag/Yi4kAPI), which we forked and misused a bit for this.
