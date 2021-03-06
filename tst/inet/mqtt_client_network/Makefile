#
# @section License
#
# The MIT License (MIT)
#
# Copyright (c) 2014-2017, Erik Moqvist
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# This file is part of the Simba project.
#

NAME = mqtt_client_network_suite
TYPE = suite
BOARD ?= linux

TIMEOUT ?= 30

SSID ?= Qvist2
PASSWORD ?= maxierik

ifeq ($(BOARD), nano32)
RUN_PY = run_esp32.py
else
RUN_PY = run_esp.py
endif

CDEFS += \
	CONFIG_MODULE_INIT_LOG=1 \
	CONFIG_ESP_WIFI=1 \
	CONFIG_START_NETWORK=1 \
	CONFIG_START_NETWORK_INTERFACE_WIFI_SSID=$(SSID) \
	CONFIG_START_NETWORK_INTERFACE_WIFI_PASSWORD=$(PASSWORD)

DRIVERS_SRC = \
	network/esp_wifi.c \
	network/esp_wifi/station.c \
	network/esp_wifi/softap.c
INET_SRC = \
	socket.c \
	inet.c \
	mqtt_client.c \
	ping.c \
	network_interface.c \
	network_interface/wifi.c \
	network_interface/driver/esp.c


include $(SIMBA_ROOT)/make/app.mk
