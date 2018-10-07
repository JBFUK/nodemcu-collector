print('wifi_client ...')

wifi.setphymode(cfg.wifiMode)
wifi.setmode(wifi.STATION)

print('MAC: ', wifi.sta.getmac())
print('chip: ', node.chipid())
print('heap: ', node.heap())

if (cfg.wifiIp) then
  wifi.sta.setip({
    ip = cfg.wifiIp,
    netmask = '255.255.255.0',
    gateway = cfg.wifiGateway
  })
  net.dns.setdnsserver(cfg.dns0, 0)
  net.dns.setdnsserver(cfg.dns1, 1)
end

wifi.sta.autoconnect(1)

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function()
    print("STATION_GOT_IP")
    print("WiFi connection established, IP address: " .. wifi.sta.getip())
    appStatus.wifiConnected = true
end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(previousState)
    if(previousState == wifi.eventmon.STA_GOT_IP) then 
        print("Station lost connection with access point\n\tAttempting to reconnect...")
        appStatus.wifiConnected = false
    else
        print("STATION_CONNECTING")
    end
end)

wifi.sta.config( {ssid =cfg.wifiSsid, pwd = cfg.wifiPass, auto = true } )
