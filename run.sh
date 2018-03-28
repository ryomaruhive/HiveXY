#!/bin/bash
cd /root/

# Start the server
nohup server/tamaserver &

# For each rom file, start the emulator
cd emu
for f in ../roms/*; do
  nohup ./tamaemu -e $f &
done

# Start the apache server
apachectl start

# Keep the server running
tail -f /dev/null
