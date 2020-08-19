# live-streaming-server
Ingest RTMP - Encode into HLS - Live Streaming

## TODO
- Reduce segment length for reduced latency?
- Auto scaling server - cost savings - handle dynamic load

## Send test stream
ffmpeg -stream_loop -1 -re -i ~/Downloads/test-video.mp4 -c copy -f flv "rtmp://localhost:1935/stream/test2"

## Test Stream with Social Sharing
```
ffmpeg -stream_loop -1 -re -i ~/Downloads/test-video.mp4 -c copy -f flv "rtmp://localhost:1935/stream/test104?twitch=<your twitch key>&youtube=<your youtube key>&facebook=<your facebook key>&facebook_s_bl=<your facebook bl>&facebook_s_sc=<your facebook s_sc>&facebook_s_sw=<your facebook sw>&facebook_s_vt=<your facebook vt>&facebook_a=<your facebook a>"
```

# Try this:
h264_nvenc uses the NVidia hardware assisted H.264 video encoder


# Installation

* create stacks

```
cd live-streaming-server/stacks && sh stack-up.sh assets

sh stack-up.sh vpc

sh stack-up.sh security

sh stack-up.sh ecs

sh stack-up.sh redis

```
* create server
```
cd live-streaming-server/server/stacks && sh stack-up.sh ecr
sh stack-up.sh service

```

* create proxy
```
cd live-streaming-server/proxy/stacks && sh stack-up.sh ecr
sh stack-up.sh service

```

* create origin
```
cd live-streaming-server/origin/stacks && sh stack-up.sh ecr
sh stack-up.sh service

```

* create proxy-dns.stack

```
cd live-streaming-server/stacks && sh stack-up.sh proxy-dns

```