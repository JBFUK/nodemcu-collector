cfg = {
  nodeCpuFreq = node.CPU80MHZ, -- node.CPU160MHZ
  wifiSsid = 'SSID',
  wifiPass = 'PASSWORD',
  wifiMode = wifi.PHYMODE_B,
  telnetPort = 23,
  
  transmissionBlock = 10, -- Measurements to send
  transmissionInterval = 60000, -- miliseconds
  readRoundInterval = 10000, -- miliseconds
  toFileWhenHeap = 8000, -- lower than in bytes
  dataFileName = 'data_storage.csv',
  production = false,
  
  readerId = {
    nodeHeap = 1,
    wifiSignal = 2,
    nodeEvent = 3, -- DO NOT put this on var readerSlots
  --  externalTemp = 4, -- This reader gets externalHum also; uncomment for DHT sensor
  --  externalHum = 5, -- DO NOT put this on var readerSlots; uncomment for DHT sensor
  },
  
  influxDB = {},
  influxTags = {},
  
  sntpServerName = '0.pool.ntp.org',
  sntpServerIp = '200.160.7.193',
  sntpRefresh = 24 -- hours
}

influxMeasurement[cfg.readerId.nodeHeap] = 'node_heap'
influxMeasurement[cfg.readerId.wifiSignal] = 'wifi_signal'
influxMeasurement[cfg.readerId.nodeEvent] = 'node_event'
-- influxMeasurement[cfg.readerId.externalTemp] = 'external_temp'; uncomment for DHT sensor
-- influxMeasurement[cfg.readerId.externalHum] = 'external_hum'; uncomment for DHT sensor

-- After read a value it is enqueued only when greater than related captureDelta
captureDelta[cfg.readerId.nodeHeap] = 1
captureDelta[cfg.readerId.wifiSignal] = 0.01
-- captureDelta[cfg.readerId.externalTemp] = 0.1; uncomment for DHT sensor
-- captureDelta[cfg.readerId.externalHum] = 0.4; uncomment for DHT sensor
