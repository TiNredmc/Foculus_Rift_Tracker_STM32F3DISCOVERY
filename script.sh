# stop remaining openocd instances
killall -9 openocd
# start new openocd and reset and init chip
openocd -f /usr/share/openocd/scripts/board/stm32f3discovery.cfg -c init -c"reset halt" -c"flash erase_sector 0 0 127" -c"flash write_image stm32f3_HID_for_real.elf"
