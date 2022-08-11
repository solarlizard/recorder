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

1. Go to https://meet.jit.si/PageRecTest and press "Join meeting"
2. Run ````./start.sh````
3. When you see records in logs like:
````
recorder_1  | frame=  172 fps= 12 q=31.0 size=     996kB time=00:00:07.04 bitrate=1157.7kbits/s speed=0.479x    
recorder_1  | frame=  178 fps= 12 q=31.0 size=    1000kB time=00:00:07.30 bitrate=1121.0kbits/s speed=0.48x    
recorder_1  | frame=  184 fps= 12 q=31.0 size=    1048kB time=00:00:07.54 bitrate=1138.4kbits/s speed=0.48x    
````
4. Watch record in ````./records/rec.mpg````
