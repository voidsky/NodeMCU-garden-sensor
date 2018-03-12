-- On case if cannot connect to wifi 
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T) 
	print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
T.BSSID.."\n\treason: "..T.reason.."\n")
end)
 
json_server_addr = 'http://yoururl'
json_guid = "e48c1d94-4749-4140-8759-0a35e856d959"

wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid="yourssd"
station_cfg.pwd="yourpwd"
wifi.sta.config(station_cfg)
wifi.sta.connect()

ip_cfg = {}
ip_cfg.ip = "192.168.1.111"
ip_cfg.netmask = "255.255.255.0"
ip_cfg.gateway = "192.168.1.1"
wifi.sta.setip(ip_cfg)

-- log some data
print("ESP8266 mode is: " .. wifi.getmode())
print("The module MAC address is: " .. wifi.ap.getmac())
print("Config done, IP is "..wifi.sta.getip())

PIN = 4 --  data pin, GPIO2

-- create timer 
mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_AUTO, function()
	-- read sensor data 
	status, t, h, temp_dec, humi_dec = dht.readxx(PIN)
	light = adc.read(0)
	
	-- post sensort data
	json_data = '{"guid":"'..json_guid..
		'","temperature":"'..t..
		'", "humidity":"'..h..
		'", "light":"'..light..'"}'
	print(json_data) 

	http.post(json_server_addr,
	  'Content-Type: application/json\r\n',
	  json_data,
	  function(code, data)
		if (code < 0) then
		  print("HTTP request failed")
		else
		  print(code, data)
		end
	  end)	
	
end)
mytimer:start()

function receiver(conn,request)

		print(request)
		
        if (string.find(request,"/favicon")) then 
            return
        end 

		-- read sensor data
        status, t, h, temp_dec, humi_dec = dht.readxx(PIN)
		light = adc.read(0)
	
        status_string_text = "OK"        
        if status == dht.OK then
            print("DHT Temperature:"..t..";".."Humidity:"..h) 
        elseif status == dht.ERROR_CHECKSUM then
            status_string_text = 'DHT Checksum error.'
        elseif status == dht.ERROR_TIMEOUT then
            status_string_text = 'DHT timed out.'
        end
         		 
		local buffer = ""
        buffer = buffer.. '<html>'
		buffer = buffer.. '<title>On Deck</title></head>'
		buffer = buffer.. '<body bgcolor=\"#ffffff\">'
		buffer = buffer.. '<center>'
		buffer = buffer.. '</br>'..status_string_text..'</br>'
		buffer = buffer.. '<table bgcolor=\"#0000ff\" width=\"90%\" border=\"0\">'
        buffer = buffer.. '<tr>'
        buffer = buffer.. '  <td><font size=\"2\" face=\"arial, helvetica\" color=\"#ffffff\"><center>Temperature</center></font></td>'
        buffer = buffer.. '</tr>'
        buffer = buffer.. '<tr>'
        buffer = buffer.. '  <td><font size=\"7\" face=\"arial, helvetica\" color=\"#ffffff\"><center>'..t..'&deg;C</center></font></td>'
        buffer = buffer.. '</tr>'
            
		buffer = buffer.. '<tr>'
		buffer = buffer.. '  <td><font size=\"2\" face=\"arial, helvetica\" color=\"#ffffff\"><center>Humidity</center></font></td>'
		buffer = buffer.. '</tr>'
		buffer = buffer.. '<tr>'
		buffer = buffer.. '  <td><font size=\"5\" face=\"arial, helvetica\" color=\"#ffffff\"><center>'..h..'%</center></font></td>'
		buffer = buffer.. '</tr>'
		
		buffer = buffer.. '<tr>'
		buffer = buffer.. '  <td><font size=\"2\" face=\"arial, helvetica\" color=\"#ffffff\"><center>Light</center></font></td>'
		buffer = buffer.. '</tr>'
		
		buffer = buffer.. '<tr>'
		buffer = buffer.. '  <td><font size=\"5\" face=\"arial, helvetica\" color=\"#ffffff\"><center>'..light..'</center></font></td>'
		buffer = buffer.. '</tr>'
		
		
		buffer = buffer.. '</table>'
		buffer = buffer.. '</center>'
		buffer = buffer.. '</body></html>'
		
		conn:send(buffer)
end

srv=net.createServer(net.TCP, 4)
if srv then
  srv:listen(80, function(conn)
    conn:on("receive", receiver)
  end)
end

