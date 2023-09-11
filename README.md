# docker-ffmpeg-mesa
Super simple Dockerfile for FFMPEG with Mesa (AMD) VAAPI Support.

Since RHEL doesnt ship with ffmpeg and no docker container i found had Mesa support i made this.
Its based on the latest alpine and its bundled ffmpeg.
Currently thats alpine 3.18.3 and ffmpeg 6.0

## Requirements
Your host machine needs to have a compatible driver installed.

You can check if the driver is installed by running:
```
lspci -nnk
```

and check for your VGA entry/entries.
For example:
```
VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Raphael [1002:164e] (rev c3)
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device [1462:7d67]
        Kernel driver in use: amdgpu
        Kernel modules: amdgpu
```

As you can see it states that the driver in use is "amdgpu".

Also make sure that the **/dev/dri/renderD128** device exists

You can also check which codecs your Hardware supports by running **vainfo**

For example for Raphael Hardware it looks like this:

```
vainfo: VA-API version: 1.11 (libva 2.11.0)
vainfo: Driver version: Mesa Gallium driver 23.2.0-devel for AMD Radeon Graphics (raphael_mendocino, LLVM 16.0.6, DRM 3.54, 5.14.0-284.25.1.el9_2.x86_64)
vainfo: Supported profile and entrypoints
      VAProfileH264ConstrainedBaseline: VAEntrypointVLD
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSlice
      VAProfileH264Main               : VAEntrypointVLD
      VAProfileH264Main               : VAEntrypointEncSlice
      VAProfileH264High               : VAEntrypointVLD
      VAProfileH264High               : VAEntrypointEncSlice
      VAProfileHEVCMain               : VAEntrypointVLD
      VAProfileHEVCMain               : VAEntrypointEncSlice
      VAProfileHEVCMain10             : VAEntrypointVLD
      VAProfileHEVCMain10             : VAEntrypointEncSlice
      VAProfileJPEGBaseline           : VAEntrypointVLD
      VAProfileVP9Profile0            : VAEntrypointVLD
      VAProfileVP9Profile2            : VAEntrypointVLD
      VAProfileAV1Profile0            : VAEntrypointVLD
      VAProfileNone                   : VAEntrypointVideoProc

```
Super simple explanation:
**VAEntrypointEncSlice** means your hardware can encode this Profile.
**VAEntrypointVLD** means it can decode.

## Build
Building this dockerfile is as simple as cloning this repository and building it with either docker or buildah:

```
git clone https://github.com/iTimo01/docker-ffmpeg-mesa.git
cd docker-ffmpeg-mesa


buildah -t ffmpeg build Dockerfile

or

docker -t ffmpeg build
```

## Run

To run ffmpeg its the same as with: [linuxserver/docker-ffmpeg](https://github.com/linuxserver/docker-ffmpeg#hardware-accelerated-vaapi-click-for-more-info)

For example your run command could be:
```
docker run --rm -it \
--device=/dev/dri:/dev/dri \
-v /mnt/storage/Media/:/config \
localhost/ffmpeg \
-vaapi_device /dev/dri/renderD128 \
-i /config/input.mp4 \
-vf 'format=nv12,hwupload' \
-c:v h264_vaapi \
-b:v 4M \
-c:a copy \
/config/output.mkv
```
