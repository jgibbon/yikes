# yikes
[yikes](https://github.com/jgibbon/yikes/) is a bare-bones Sailfish OS application to interface with Yi Action Cameras.
It is primarily targeted towards the Yi 4k Action Camera, but with at least some features working on other models.
For example, recording Video or Photos with the Yi Discovery work, as does downloading Media from the Camera.
Other models may or may not work and are generally untested.

## Limitations

 - The Yi Action Camera API is not publicly documented, so all features may stop working completely in edge cases
 - Only the "most basic" use case is supported, at all. For example, you will only be able to connect with the camera 
 in "hot spot mode" with the standard IP Adress.
 - Most camera models are totally untested. You may get in touch with the authors of this application to sponsor other models to help us debug them. 
 No promises on actual progress, though. ;)
 - The "Live" mode of newer firmware versions is and will remain unsupported.
 
 ## Features
 - Basic connection to the camera (4K + Discovery)
 - Viewfinder stream (4K only)
 - Start recording Video or Photos (4K + Discovery)
 - Media preview & download (4K + Discovery)
 - Select sub modes like "Slow Motion" or "Time Lapse" (4K, Discovery is work-in-progress)
 - List (4K + Discovery) and edit (4k, Discovery only for some settings) in-camera settings.
 
 ## Acknowledgements
 This is a QML/Python application, using the fabulous [PyOtherside](https://github.com/thp/pyotherside) for Python/Qt bindings.
 
 It would not be possible to without existing work at [Yi4kAPI](https://github.com/NikolayRag/Yi4kAPI), which we forked and misused a bit for this.
