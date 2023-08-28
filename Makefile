datasdir := $(HOME)/.make/
pio := $(HOME)/.platformio/penv/bin/pio
ttydown := /dev/ttyUSB0
webdev := http://192.168.2.200/update

all : $(datasdir) $(datasdir)PlatformIO/esp8266
	$(pio) run

update : $(datasdir) $(datasdir)PlatformIO/esp8266
	$(pio) run
	curl -F 'firmware=@./.pio/build/esp32dev/firmware.bin' -v $(webdev)
install : $(datasdir) $(datasdir)PlatformIO/esp8266
	$(pio) run --target upload --upload-port $(ttydown)
clean : $(datasdir) $(datasdir)PlatformIO/esp8266
	$(pio) run --target clean
$(datasdir) :
	mkdir $(datasdir)
$(datasdir)udev : 
	echo OK >$(datasdir)udev
	curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules -o 99-platformio-udev.rules
	sudo mv 99-platformio-udev.rules /etc/udev/rules.d/99-platformio-udev.rules
	sudo service udev restartsudo service udev restart
	echo OK >$(datasdir)udev

$(datasdir)PlatformIO.info : $(datasdir)
	curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py -o get-platformio.py
	python3 get-platformio.py
	mkdir $(datasdir)PlatformIO
	echo OK >$(datasdir)PlatformIO.info

$(datasdir)PlatformIO/esp8266 : $(datasdir)udev $(datasdir)PlatformIO.info
	$(pio) platform install espressif8266
	echo OK >$(datasdir)PlatformIO/esp8266