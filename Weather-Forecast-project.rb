
    require "net/http"

    require "json"

    class WeatherPrediction

      yourIPv4Address = Net::HTTP.get(URI("http://whatismyip.akamai.com/"))

     

      location = Net::HTTP.get(URI("https://geocode.xyz/"+yourIPv4Address+"?json=1&174539398002493946020x100647"))

     

      jsonLocation = JSON.parse(location)

     

      @@weather = Net::HTTP.get(URI("https://api.open-meteo.com/v1/forecast?latitude="+(jsonLocation["latt"]).to_s+"&longitude="+(jsonLocation["longt"]).to_s+"&daily=temperature_2m_max,temperature_2m_min,weathercode&temperature_unit=fahrenheit&timezone="+(jsonLocation["timezone"]).to_s+"&past_days=0"))

     

      def initialize ()

         jsonWeather = JSON.parse(@@weather)


         @dates = jsonWeather["daily"]["time"]


         @high=jsonWeather["daily"]["temperature_2m_max"]

         @low=jsonWeather["daily"]["temperature_2m_min"]


         @condition=[]


         @code=jsonWeather["daily"]["weathercode"]


         @months = "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
      end

     

      def month_day

        7.times.each do |i|

          monthIndex=((@dates[i][5]+@dates[i][6]).to_i)-1

          month=@months[monthIndex]

          @dates[i]=month+", "+@dates[i][8,9]

        end

      end

     

      def setCondition

      
       7.times.each do |i|
               case @code[i]

          when 0

            @condition[i]="Clear Skys"

          when 1

            @condition[i]="Mainly Clear"

          when 2

            @condition[i]="Partly Cloudly"

          when 3

            @condition[i]="Overcast"

          when 51

            @condition[i]="Light Drizzle"

          when 53

               @condition[i]="Moderate Drizzle"

          when 55

            @condition[i]="Dense Drizzel"

          when 56

            @condition[i]="Frezzing Light Drizzel"

          when 57

            @condition[i]="Frezzing Dense Drizzel"

          when 61

            @condition[i]="Light Rain"

          when 63

            @condition[i]="Moderate Rain"

          when 65

            @condition[i]="Heavy Rain"

          when 71

            @condition[i]="Light Snow"

          when 73

            @condition[i]="Moderate Snow"

          when 75

            @condition[i]="Heavy Snow"

          when 77

            @condition[i]="Snow Grains"

          when 80

            @condition[i]="Slight Rain Showers"

          when 81

            @condition[i]="Moderate Rain Showers"

          when 82

            @condition[i]="Violent Rain Showers"

          when 85

            @condition[i]="Slight Snow Showers"

          when 86

            @condition[i]="Heavy Snow Showers"

          when 95

            @condition[i]="Thunderstorm"

          when 96

            @condition[i]="Thunderstorm with Slight Hail"

          when 99

            @condition[i]="Thunderstorm with Heavy Hail"

          else

            @condition[i]="Weather Code: "+(@code[i]).to_s

          end

        end

      end

     

      def graph

               highList=""

          lowList=""

        7.times.each do |i|

          if(i<6)

            highList+=(@high[i]).to_s+","

            lowList+=(@low[i]).to_s+","

          else

            highList+=(@high[i]).to_s

            lowList+=(@low[i]).to_s

          end

        end

        puts "Forecast as a bar graph: https://image-charts.com/chart?chs=800x500&cht=bvg&chd=t:"+highList+"|"+lowList+"&chco=FF0000,0000FF&chxt=y&chdl=High|Low"

      end

     

      def print

        puts "The temperature forecast for your area is"

        puts ""

        7.times.each do |i|

          puts (@dates[i]).to_s+": Max "+(@high[i]).to_s+", Min "+(@low[i]).to_s+" Weather Condition: "+@condition[i]

        end

       

      end

    end

     

    forecast = WeatherPrediction.new

    forecast.month_day

    forecast.setCondition

    puts forecast.print

    puts ""

    puts forecast.graph

