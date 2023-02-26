require "net/http"

require "json"


class WeatherPrediction
  yourIPv4Address = Net::HTTP.get(URI("http://whatismyip.akamai.com/"))

  location = Net::HTTP.get(URI("https://geocode.xyz/"+yourIPv4Address+"?json=1&174539398002493946020x100647"))

  jsonLocation = JSON.parse(location)

  weather = Net::HTTP.get(URI("https://api.open-meteo.com/v1/forecast?latitude="+(jsonLocation["latt"]).to_s+"&longitude="+(jsonLocation["longt"]).to_s+"&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&timezone="+(jsonLocation["timezone"]).to_s+"&past_days=0"))
  
  jsonWeather = JSON.parse(weather)
  
  @@dates = jsonWeather["daily"]["time"]
  
  @@high=jsonWeather["daily"]["temperature_2m_max"]
  
  @@low=jsonWeather["daily"]["temperature_2m_min"]
  
  @@months = "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
  
  def month_day
    7.times.each do |i|
      monthIndex=((@@dates[i][5]+@@dates[i][6]).to_i)-1
      month=@@months[monthIndex]
      @@dates[i]=month+", "+@@dates[i][8,9]
    end
  end
  
  def graph
    	highList=""
      lowList=""
    7.times.each do |i|
      if(i<6)
        highList+=(@@high[i]).to_s+","
        lowList+=(@@low[i]).to_s+","
      else
        highList+=(@@high[i]).to_s
        lowList+=(@@low[i]).to_s
      end
    end
    puts "Forecast as a bar graph: https://image-charts.com/chart?chs=800x500&cht=bvg&chd=t:"+highList+"|"+lowList+"&chco=FF0000,0000FF&chxt=y&chdl=High|Low"
  end
  
  def print
    puts "The temperature forecast for your area is"
    puts ""
    7.times.each do |i|
      puts (@@dates[i]).to_s+": Max "+(@@high[i]).to_s+", Min "+(@@low[i]).to_s
    end
    
  end
end

forecast = WeatherPrediction.new
forecast.month_day
forecast.print
puts ""
forecast.graph

