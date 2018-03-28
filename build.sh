#!/bin/bash
cd /root/

# Copy the web files over the web directory
cp -R web/* /var/www/html/

# Build all of the necessary projects
cd emu
make
cd ../server
make
cd ..
