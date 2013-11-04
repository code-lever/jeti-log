def format(gps)
  minute = (gps[:value] & 0xFFFF) / 1000.0
  degrees = (gps[:value] >> 16) & 0xFF
  degrees += (minute / 60.0)
  degrees * (((gps[:decimals] >> 1) & 1) == 1 ? -1 : 1)
end

lat = { type: 9, decimals: 0, value: 2698067 }
lon = { type: 9, decimals: 3, value: 6301754 }

puts lat.inspect
puts format(lat)

puts lon.inspect
puts format(lon)
