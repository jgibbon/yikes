# yikes
[yikes](https://github.com/jgibbon/yikes/) is a bare-bones Sailfish OS application to interface with Yi Action Cameras.
It is primarily targeted towards the *Yi 4k Action Camera*, but with at least some features working on other models.
For example, recording Video or Photos with the *Yi Discovery* work, as does downloading media from the camera.
Other models may or may not work and are generally untested.

## Limitations
 - The Yi Action Camera API is not publicly documented, so all features may stop working completely in edge cases
 - Only the "most basic" use case is supported, at all. For example, you will only be able to connect with the camera 
 in "hot spot mode" with the standard IP address.
 - Most camera models are totally untested. You may get in touch with the authors of this application to sponsor other models which might help us to debug them. *No promises on actual progress, though.* ;)
 - The "Live" mode of newer firmware versions is and will remain unsupported.

## Features
 - Basic connection to the camera (4K + Discovery)
 - Viewfinder stream (4K only)
 - Start recording video or photos (4K + Discovery)
 - Select sub modes like "Slow Motion" or "Time Lapse" (4K, Discovery is work-in-progress)
 - Media preview & download (4K + Discovery)
 - List (4K + Discovery) and edit (4k, Discovery only for some settings) in-camera settings.
 
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
