Forked By TinLethax
=

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
The real is shipped to me.So I start testing the pre-built firmware.Too bad luck .the code is execute and stop (Led cycling id not start).So I moved the OLED statement from "while(1)" to void main section.

# The OLED MUST CONNECTED TO i2c2 not i2c1 .
The "Foculus Rift" tracker
==========================
A USB HID device, sending Accelerometer, Gyroscope and Magnetometer data over USB in an Oculus Rift compatible format.

This project comes in useful, if you are building your own DIY Head Mounted Display. It solves the problem of finding a motion tracker. The firmware runs on the STM32F3DISCOVERY board and should be compatible with all Oculus Rift games.

Development blog
------------------
More details about the reverse engineering can be found on the [development blog](http://yetifrisstlama.blogspot.fr/2014/03/the-foculus-rift-part-2-reverse.html).

Current Status
------------------
Old code before I will forked to here is normally working.But mine dunknown because I haven't test it.

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
*For Ubuntu 13:*

1. Install open-ocd, follow the steps [here](http://engineering-diy.blogspot.fr/2012/11/stm32f3-discovery-eclipse-openocd.html) (only the ones related to open-ocd)

2. Connect the STM32F3DISCOERY board to the PC on its USB ST-LINK connector

3. In a terminal, run this:
```bash
sudo openocd -f /usr/local/share/openocd/scripts/board/stm32f3discovery.cfg -c init -c"reset halt" -c"flash erase_sector 0 0 127" -c"flash write_image stm32f3_HID_for_real.elf"
```

The firmware, which is contained in the stm32f3_HID_for_real.elf binary file, should be flashed. If everything goes well, you can connect the board on the USB USER connector and it should be recognized as: "Oculus VR, Inc. Tracker DK". That's it, mount the board on your HMD and start up the Oculus World Demo.


Calibration and change of orientation
--------------------------------------
To calibrate the Gyroscope for zero-offset (which reduces drift), place the STM board on a flat surface
and push the blue "USER" button for less than 1 second. Make sure that
the board absolutely does not move while the calibration is in progress. The data is permanently stored
in FLASH memory and retained after power down.

To change the reported coordinate system and hence the orientation of the board, push the "USER" button
for > 1 second. Then you will be able to select one out of 8 preconfigured orientation settings,
indicated by the blinking LED. After pushing the "USER" button again for > 1 second, the setting
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
 03.05.2018   Moved the OLED statement from "while(1)" to void loop section.
