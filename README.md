# Tamatrix
Run your very own Matrix for Tamagotchis, where they are cared for by a benevolent artificial intelligence.

## How to Run
The project is setup as a Docker container. After you've installed [Docker](https://www.docker.com/), simply run:

```bash
# Build the image
docker build .

# List all of your images, and make note of the id of the image you just built
docker images

# Start a container with the image you built
docker run -td -p 3000:80 <image-id>
```

Now you can go to ```localhost:3000``` in your browser and see your Matrix running!

## The ROMs
The Docker setup will start a Tamagotchi emulator for each ROM in the ```roms/``` directory. There's 5 starters provided
there. If you would like to have more Tamagotchis running, simply add more ROMs to this folder. I plan on streamlining
this process, but for now look at the original README for this project below, and follow the emulator usage instructions
to create new ROMs.

## Attaching to the Container
To keep the container running, the Dockerfile runs ```tail -f /dev/null``` at the end of the setup. This means a typical
```docker attach <container-id>``` won't work. Instead, if you'd like to connect to the container while it's running,
simply run:

```bash
docker exec -it <container-id> bash
```

## Dokku
This project works great with [dokku](https://github.com/dokku/dokku)! Simply push this repo to your dokku server and
it'll just work.

However, I do *highly* recommend you run the following dokku command before deploying to disable logs:

```bash
dokku docker-options:add <app-name> deploy "--log-driver=none"
```

Otherwise, you may find that logs are quickly filling up your server!

## CPU Usage
On my [$10 DigitalOcean box](http://tamatrix.dokku.mordorm.com), each instance of the emulator takes up ~10.1% of the CPU.
That's why I've limited the number of pets to 5.

However, it's worth noting that they take up very little RAM and disk space. From the looks of DigitalOcean's site, both
the $5 and $10 instances both get 1 CPU, so if you're *just* running Tamatrix and want some cheap hosting, you could
probably run 9 of them on the $5 instance without issue.

## Other Viewers
Because each Tamatrix server exposes a simple API, it's easy to build other viewers. Here's a list:

* Android: [Link](https://github.com/greysonp/tamatrix-android-viewer)

# Background
This is effectively a fork of the codebase created by [Spritesmods](http://spritesmods.com/). The original repository is
hosted on a personal git server and can be retrieved with the following:

```git clone http://git.spritesserver.nl/tamatrix.git```

The details of the original project can be found [here](https://spritesmods.com/?art=tamasingularity).

The original README follows:

---

This contains all the software I've used/written for the Tamagotchi Matrix and viewer.

The directory structure:  
/emu/ - The Tamagotchi emulator.  
/server/ - The TamaServer, which connects the Tamagotchis and allows them to communicate.  
/web/ - Sources for the web viewer as seen on http://tamahive.spritesserver.nl/  
/viewer/ -Tamagotchi viewer  
/viewer/esp12 - ESP12 part of Tamagotchi viewer  
/viewer/remtama - Tama-Go figurine code to allow modifying display from buttons  

Some notes:

***The Tamagotchi Emulator***

Run 'make' to make this. It shouldn't require anything special except gcc. Run the tamaemu binary to start
it up. You can control the Tamagotchi yourself by pressing the 1, 2 or 3 key followed by an enter. Control-C
will drop you into a debugging prompt, press control-C again to quit the emulator.

When you first start up the emulator, it may be wise to do it with the -n parameter. This disables the AI. The
very first thing that happens on an empty EEPROM is the Tamagotchi asking to set the time and date, and the
AI doesn't know how to do that. The trick is to start tamaemu with the -n parameter, then use the 1, 2 and 3
keys (followed by an enter!) to set the date and name your Tamagotchi. There's no need to set the true time
and date, by the way, gameplay doesn't seem to be dependent on that. After you've done this and the Tamagotchi
has hatched, you can re-start tamaemu without the -n option and the AI should be able to do its thing.

***The Tamagotchi server***

Just run 'make' and start it up. The Tamagotchis running on the same server will automatically connect to it.

***The Tamagotchi webviewer***

You'll need a PHP-enabled webserver (I used Apache) to run this. The webserver should be on the same machine
as the Tamaserver runs; they use non-networkable shared memory segments to communicate.

***The Tamagotchi viewer***

This consists of two subdirectories: one for the ESP12 module which communicates over WiFi to the Tamaserver
and one for the SPI flash chip which should be connected to the Tama-Go port of the Tamagotchi. To
assemble the latter, check out Natalies Egg-shell repo
(git checkout https://github.com/natashenka/Egg-Shell.git), copy the remtama directory into the
tASMgotchi directory, cd into the remtama dir and run 'make'. Use an Egg-Shell board or any flashrom-supported
programmer to flash the resulting remtama.bin. (Check the Makefile for an example.)

For the esp12 part, you need a working ESP8266 SDK and toolchain. If you have, just run 'make' in the ESP8266
directory, and use 'make flash' to flash the code into an ESP12. The connections needed to control the
Tamagotchi are:
Button 0 - GPIO0
Button 1 - GPIO13
Button 2 - GPIO12
Make sure the other GPIOs have pullups/pulldowns as required to allow the ESP12 to boot from SPI flash. I
suggest also wiring the reset input to the reset button of the Tamagotchi, to make resetting both easier.

With the thing assembled, to pick an access point to connect to, hold button1 of the Tamagotchi for >5 seconds.
The ESP12 should now go into access point mode. Connect to it and point a webbrowser at http://192.168.4.1 to
select an access point.
