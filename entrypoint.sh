#!/bin/sh
pulseaudio -D --exit-idle-time=-1 --system --disallow-exit --disallow-module-loading

xvfb-run -s "-screen 0 1024x768x24 -ac -nolisten tcp -dpi 96 +extension RANDR" node -r ts-node/register index.ts
