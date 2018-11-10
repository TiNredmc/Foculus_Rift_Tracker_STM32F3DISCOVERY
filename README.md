Forked By TinLethax
=
My website :tinlethax.wordpress.com
# update0:
I use 4ilo's ssd1306 library .link:https://github.com/4ilo/ssd1306-stm32HAL
But I replace HAL with "STM32F30x_StdPeriph_Driver" instead ;D 
changed the ssd1306 oled size form 128x64 to 128x32 (I use 0.91" display.But if you have a 128x64 .you can change it in sdd1306.h in Inc folder ;D.

# update1:
I added the temperature and gyroscope sensor date display out to OLED Display .But I stuck @ I dont have a hardware now (I will order it soon).So if you wanna test.just test it rn ;D.

# update2:
I changed the i2c timing mode to 400kHz.

# update3:
Changed Font from "Font_11x18" to "Font_7x10"

# update4:
The board is shipped to me.So I start testing the pre-built firmware.Too bad luck .the code is execute and stop (Led cycling not start).So I moved the OLED statement from "while(1)" to void main section.

# update5:
I changed the SN to "STM32F3DISCO" and changed the product name form "Tracker DK" to "Rift DK2".

# update6: 
The OLED is arrived .Too bad luck .The oled display with $h1tty gliched dots .It caused by the sending data method .
I have two wat to fix 
-Migrate all library to HAL 
-Make my own library (not intergrated in peripheral.h/.c because I can use it in later).

# update7:
I tired to port from the HAL library .It still bot working yet.So I will use adafruit library (mostly copy the funtional amd change tge some interface syntaxes.

# update8:
I really need to make my own library or maybe mod 4ilo's Lib.No HAL ,Just SPL ,Raw SPL . 

# update9:
I given up on this OLED.I decided to change the OLED display to This one (Also WIP):https://github.com/TiNredmc/HDSP2000
So I really nned to rip-off the old OLED libraries then replace whit my project (May be soon...)

# update10: 
I relise that HDSP 2000 are quite haed to find .And  Im working on SCDV5542 display to be woring on the stm32f3 disco using AC6 IDE instead of using eclipe + openocd ,Ad plan to move the project to new AC6's project ,for debugging feature and more reliable coding experience with the SCDV5542 library 
# The OLED MUST CONNECTED TO i2c2 not i2c1 .
The "Foculus Rift" tracker
==========================
A USB HID device, sending Accelerometer, Gyroscope and Magnetometer data over USB in an Oculus Rift compatible format.

This project comes in useful, if you are building your own DIY Head Mounted Display. It solves the problem of finding a motion tracker. The firmware runs on the STM32F3DISCOVERY board and should be compatible with all Oculus Rift games.

Development blog
------------------
Original :More details about the reverse engineering can be found on the [development blog](http://yetifrisstlama.blogspot.fr/2014/03/the-foculus-rift-part-2-reverse.html).

Current Status
------------------
Old code before I will forked to here is normally working.The latest code still not testing with the oled yet.

Organization of the code
-------------------------
<pre>
 main.c           main logic of the tracker,
                  handling and reformating the sensor data stream and packing it into 62 byte packets to be sent over USB,
                  Assign the coordinate system directions
                  keeping track of the configuration data structures which the libOVR might send and request
 peripherals.c    setup and request data from the 3 sensor chips over SPI and I2C
                  Handle the scaling and calibration factors, so the headtracker moves in the right way
                  Zero-level calibration routine for the gyroscope
                  Save calibration factors to flash
                  PWM-patterns for the 8 status LEDs
 usb_desc.c       USB - HID descriptors, which fool the PC into thinking that there is an Oculus RIft corrected
 usb_endp.c       STM USB driver endpoint1 callbacks, just sets some global flags to inform the main routine when there is new data
 usb_prop.c       Customization of the STM USB driver, so feature reports can be sent and received
                  received data is copied in the global array featureReportData[] and then processed by the main loop
 fonts.c          fonts for SSD1036 library
 ssd1306          library to send data to ssd1306 OLED display.send out from i2c number 2 port.                    
</pre>

Flashing the STM32F3DISCOVERY board
------------------------------------
For Linux (Whatever).
on Eclipse c/c++ (install steps is here http://engineering-diy.blogspot.fr/2012/11/stm32f3-discovery-eclipse-openocd.html )
1.Edit the Makefile First ,You must to change the "gcc-arm-none-eabi" dir to where you extracted .(find the "FPU_CFLAGS 	= -L/dir/to/ur/gcc/arm/none/eabi") .Also with openocd ,You must to change th dir of config file .(Located at install-ocd ."install-ocd: $(PROJ_NAME).elf
	@$(shell killall -9 openocd)
	@$(shell openocd -f /your/dir/to/the/open/ocd/stm/board/cfg -c init -c"reset halt" -c"flash erase_sector 0 0 127" -c"flash write_image $(PROJ_NAME).elf" -c"reset init" -c"reset run" -c"exit")" )

2.at project explorer in Eclipse Expand the "Foculus_Rift_Tracker_STM32F3DISCOVERY" and expand the "Build Targets" 
-2.1 If you wanna clean the project (some complied file).double click at "make clean" 
-2.2 If you wanna build the complete firmware (a.k.a compile and make the firmware).double click at "make all"
-2.3 If you wanna Flash the firmware directly to the board (NOTE THIS IS IMPORTANT:Connect the usb to the ST-Link header not usb user ,Always connect before will flash).double click at "install-ocd"

for Windows (Whatever).
Apologize .I dont use windows to working on this project ,but you can search "STM32F3 discovery + eclipse + openocd windows"on on internet.It might be help you ;D

# for someone getting error "Error: open failed"
Go th the /your/dir/to/the/open/ocd/stm/board/.cfg .and find for "stm32f3discovery.cfg"
open it with any text editor do you want.allocate for "source [find interface/stlink-v2.cfg]" or may be "source [find interface/stlink.cfg]" change it to "source [find interface/stlink-v2-1.cfg]" and save .

After flashed the firmware .Try to connect the usb to "USB USER",if the pc recognize as unknow (While in Windows).Try to restart your pc or connect through usb hub.If you run the Oculus World Demo at first time The Tracker will glitchy .Dont worry .try to run the other game like "Alone in the rift demo". after the alone bla bla bla is detected the tracker .LED on the STM32F3 will slowly cycling and you will get the realtime (I thought xD) tracking.If you wanna play with Oculus World Demo .Exi the Alone in the rift .and then get into Oculus world demo again.

I tested on linux .Using wine to run windows program such Alone in the rift and Oculus world demo .Nothing wrong .The tracking is work properly.

Calibration and change of orientation
--------------------------------------
To calibrate the Gyroscope for zero-offset (which reduces drift), place the STM board on a flat surface
and push the blue "USER" button for less than 1 second. Make sure that
the board absolutely does not move while the calibration is in progress. The data is permanently stored
in FLASH memory and retained after power down.

To change the reported coordinate system and hence the orientation of the board, push the "USER" button
for more than 1 second. Then you will be able to select one out of 8 preconfigured orientation settings,
indicated by the blinking LED. After pushing the "USER" button again for more than 1 second, the setting
is also permanently saved to FLASH memory.

One of the following orientations can be chosen at the moment:
<pre>
-------------------------------------------------------
LED label     Orientation
-------------------------------------------------------
LD3  (Red)    LEDs toward user     USB down
LD4  (Blue)   LEDs toward user     USB right
LD5  (Orange) LEDs away from user  USB down
LD6  (Green)  LEDs away from user  USB up
LD7  (Green)  LEDs up              USB toward user
LD8  (Orange) LEDs up              USB away from user
LD9  (Blue)   LEDs up              USB to users right
LD10 (Red)    LEDs up              USB to user right
-------------------------------------------------------
</pre>

Changelog
--------------------------------
<pre>
 09.03.2014:  Fixed bug in handleConfigPacketEvent() by adding break; statements (data rate was always 1 ms before)
 10.03.2014:  Changed wMaxPacketSize from 62 to 64
 19.03.2014:  Changed I2C Bus speed to 400 kHz, which allows to read all 3 sensors in 0.65 ms  (before it was > 2 ms)
 20.03.2014:  Now evaluating the "new data ready" pins of all 3 sensors (improves timing a lot, reduces jitter)
              Enabled FIFO in Streaming mode of Accelerometer and Gyro (no samples will be lost!)
              Fixed Glitches in Magnetometer output by setting it to 75 Hz measurement rate (was 220 Hz before)
 23.03.2014:  Fixed a problem with the USB interrupt and atomic access, not allowing the tracker to change sensor scale
              Changed sensor scaling to floating point numbers and scaled to values as expected from the SDK
 29.03.2014:  Added gyroscope "set to zero" calibration routine (Press the user button on the STM board and keep it very still)
              Added temperature readout from gyro
              Added some nice LED animations for IDLE mode, Tracker running mode and Calibration mode
 01.04.2014:  Gyro offset calibration is now saved to Flash at address 0x08006000 and hence retained after power off
 08.05.2014:  Fixed bug in readSensorAcc(): an array was accessed outside its boundaries.
              also included the .hex file and switched on compiler optimizations
 11.05.2014:  Experimental: Setting of board orientation ...
              Push the user button for > 1 s to choose between 8 preconfigured orientation settings
              Push the user button again for > 1 s to save the setting to FLASH memory
 27.04.2018   Added th OLED library .interface @ i2c number2 .OLED display .e-compass temperature and gyroscope data
 29.04.2018   Changed the OLED i2c timing (400kHz)
 02.05.2018   Changed Font from "Font_11x18" to "Font_7x10".I hope the fonts still readable xD.
 03.05.2018   Moved the OLED statement from "while(1)" to void main section.
 04.05.2018   Removed the "Init..."(OLED statement).
 06.05.2018   Added more installation guide and some of descriptions
 07.05.2018   I changed the SN to "STM32F3DISCO" and changed the product name form "Tracker DK" to "Rift DK2".
