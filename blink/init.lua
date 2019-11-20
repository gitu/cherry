-- init the ws2812 module
ws2812.init(ws2812.MODE_SINGLE)
-- create a buffer, 60 LEDs with 3 color bytes
strip_buffer = ws2812.newBuffer(16, 3)
-- init the effects module, set color to red and start blinking
ws2812_effects.init(strip_buffer)
ws2812_effects.set_brightness(100)
--ws2812_effects.set_color(0,255,0)
ws2812_effects.set_mode("rainbow_cycle")
ws2812_effects.start()
ws2812_effects.set_speed(1)


wifi.setmode(wifi.STATIONAP)

target="de:4f:22:12:0e:50"
print("mac: "..wifi.ap.getmac())
if wifi.ap.getmac() == target then
    target="de:4f:22:11:93:47"
end 
--de:4f:22:11:98:1e
--de:4f:22:11:93:47
--de:4f:22:12:0e:50
-- 

print("target: "..target)

-- Print AP list that is easier to read
function listap(t) -- (SSID : Authmode, RSSI, BSSID, Channel)
    print("\n\n"..string.format("%32s","SSID").."\tBSSID\t\t\t\t  RSSI\t\tAUTHMODE\tCHANNEL")
    print("-- "..target)
    for ssid,v in pairs(t) do
        local authmode, rssi, bssid, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
        if bssid == target then
          print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
        
          local rssin = tonumber(rssi)

          local speed = math.min(math.max(5 * (75+rssin), 0), 255)
          print(speed)
        
          ws2812_effects.set_speed(speed)
        end 
    end
end
wifi.sta.getap(listap)

print("\ncreating timer..")
mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_AUTO, function() wifi.sta.getap(listap) end)
mytimer:start()