# nodemcu-collector
Collect measurements from sensors connected to NodeMCU and transmit them to InfluxDB.

This project is intended as starting point for projects where you have to collect data from a set of sensors connected to ESP8266 and any othe IoT platform that support NodeMCU firmware.

## Requirements
* A [ESP8266 module](https://en.wikipedia.org/wiki/ESP8266) or similar 
* Knowledge about [NodeMCU platform](http://nodemcu.readthedocs.io/en/master/) and [Lua programming language](http://www.lua.org/manual/5.1/index.html)
* A NodeMCU firmware compiled with these modules at least: bit,dht,file,gpio,i2c,net,node,rtctime,sntp,tmr,uart,wifi . You can compile it easly using http://nodemcu-build.com/
* [ESplorer](https://github.com/4refr0nt/ESPlorer) for edit and upload code to the module
* An accessible instance of [InfluxDB server](https://influxdata.com/time-series-platform/influxdb/)

## Assumptions
* You want collect data from sensors without interaction
* You need the most fiability as possible. It means support wifi or influxdb shutdowns with minor data loss.
* You supply energy to module using a mini UPS device.  

## Installation
* Clone or [Download](https://github.com/JBFUK/nodemcu-collector/archive/master.zip) this repository 
* Edit `config.lua` and `config_local.lua` according to your environment
* Upload all these files to NodeMCU module and reset it
* Inspect output of serial console of module, you should see a succesful wifi connection info.
* Start sending basic measurements to InfluxDB, type on console: `require('main')`
* Check data captured on InfluxDB. You will get these measurements: `node_heap`, `wifi_signal`, `node_event`

## Add a Sensor
As an example let's add a DHT temperature and humidiy sensor.

* Modify config.lua
** Uncomment externalTemp and externalHum lines under readerId array
** Uncomment influxMeasurement[cfg.readerId.externalTemp] and influxMeasurement[cfg.readerId.externalHum]; these define the data field names in your DB
** Uncomment captureDelta[cfg.readerId.externalTemp] and captureDelta[cfg.readerId.externalHum]; if your reading does not change by this amount in comparison to the last, it will not be submitted to the DB.
* Modify main.lua
** Uncomment require('reader_temp_hum'); this includes the script file which contains the function to query the DHT sensor
* Modify pins.lua
** Ensure the dht pin definition matches up with your hardware (or move your DHT data lead to pin 3)
* Modify read_round.lua
** Uncomment lines under "-- External temp and humidity"; this will check the last returned value from the sensor and queue it for submission
* Modify reader_slots.lua
** Uncomment cfg.readerId.externalTemp

That's it, upload the modified files to your NodeMCU, `require('main')` to execure the main loop and you shoudl start to see DHT sensor values read.  To add other types of sensor use the DHT code as a template, modifying to account for the dirrerent way in which your sensor works.

## Production Use
To use in anger, ensuring that the collector begins polling sensors and submitting data automatically on power-up, you must set 'cfg.production = true' and 'production = true,' in config_local.lua and config.lua files.