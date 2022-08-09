# How would you implement recording for SFU that includes the whole UI? How do you scale it?

## Solution 1:

Try to build everything from scratch (this repo): 

Idea is to capture and record audio and video from chrome running in docker:

````
*---------------------------------------------------------------------------*
|                                  DOCKER                                   |
|                                                                           |
|  *--------------------*                                                   |
|  |  Chrome (puupeter) | ->  pulseaudio + X Frame buffer -> FFMPEG capture | -> Some fast disk storage -> S3
|  |  with clinet page  |                                                   | 
|  *--------------------*                                                   |
|                                                                           |
*---------------------------------------------------------------------------*
````

### Try it:

1. Go to https://meet.jit.si/PageRecTest and press "Join mmeeting", 
2. Run ````./start.sh````
3. When you see records in logs like:
````
recorder_1  | frame=  172 fps= 12 q=31.0 size=     996kB time=00:00:07.04 bitrate=1157.7kbits/s speed=0.479x    
recorder_1  | frame=  178 fps= 12 q=31.0 size=    1000kB time=00:00:07.30 bitrate=1121.0kbits/s speed=0.48x    
recorder_1  | frame=  184 fps= 12 q=31.0 size=    1048kB time=00:00:07.54 bitrate=1138.4kbits/s speed=0.48x    
````
4. Watch record in ````./records/rec.mpg````

Of course we need to imporve client to work with recoring client different way than ususal, S3 storing, converting to MP4, managing server, failover detection e.t.c.

### Problems:
1. Audio and video synchronization is sensitive to CPU load
2. Scaling!!!

#### Scaling:
1. Using prewarmed AWS Servers
2. Find some another cloud provider with fast starting nodes ability

## Solution 2:

Agora is already providing that service: https://docs.agora.io/en/cloud-recording/cloud_recording_webpage_mode?platform=RESTful

API is ugly, non idempotent and without online problems detection.

## Solution 3:
This solution highly depends on UI functionality

We can record all streams separatly and have one more "record" with UI actions like:
1. When exactly streams appeared on UI and were stopped.
2. Everything that can be stored as events on a timeline with ability to "Playback", like chat.

And we need to make "player" to show all this together according to timeline

# How would you ensure low-latency for participants across regions?

## Simpliest solution:
To deploy just geo-distributed turns connected with SFU servers by high speed low-latency channels.

## Cascaded SFU
Should I describe here how it works? jitsi and janus both implements this strategy and there are a lot of documnentation about it.

The main idea is that packet-loss detection is made on nearest SFU - and it is much better than using geo-distributed turns.

# What monitoring would you implement to ensure you have a high quality audio/video for all participants?
To use something like https://www.callstats.io/arch/ - or build own from scratch
That solutions are based on ````getStats```` () calls of WebRTC API.

IMHO most annoing problems are not from low video quality and high latency, they are from situations when user forget to allow camera or mic access, or they are broken, or user is behind some very unfrendly firewall - we need to detect this and show user, that we are not responisble for this.

# What alerts would you implement to show if a region is degrading?
It depends on the monitoring software, and how we can connect geo data to WebRTC logs from previous question.