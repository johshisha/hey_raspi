require 'json'
require 'open-uri'
require 'time'
require 'pry'
require 'yaml'

# get weather using OpenWeatherMap API
class Weather
  def initialize(args = {secret: '.secret.yaml'})
    secret = YAML.load_file(args[:secret])
    @API_KEY = secret['API_KEY']
    @BASE_URL = secret['BASE_URL']
    @CITY_ID = secret['CITY_ID']
  end

  # judge weather whether rainy or not
  def judge_weather(weathers)
    len = weathers.length
    now_hour = (8 - len) * 3

    indexes = weathers.find_index { |n| n == 'Rain' }
    if indexes
      rainy = now_hour + indexes*3
      "#{rainy}時ごろに雨が降ります"
    else
      "晴れ，または曇りです"
    end
  end

  def get_time(day_after)
    now = Time.now
    if day_after == 0
      time = now - (3 * 60 * 60) # subscribe 3 hours
      month = time.month
      day = time.day
      hour = time.hour
    else
      time = now + (day_after * 24 * 60 * 60) # add (day_after) days
      month = time.month
      day = time.day
      hour = 0
    end
    [month, day, hour]
  end

  # get 1day weather from args time
  def get_1day_weather(month, day, hour)
    response = open(@BASE_URL + "?id=#{@CITY_ID}&APPID=#{@API_KEY}")
    result = JSON.parse(response.read)

    weathers = []
    result['list'].each do |l|
      t = Time.parse(l['dt_txt'])
      if t.day == day && t.hour >= hour # get weathers from previous priod
        # p l['weather'][0]['main']  # there are three types of weather('Clear', 'Clouds', 'Rain')
        weathers.push(l['weather'][0]['main'])
      end
    end
    weathers
  end

  # get weather #{day_after} days after from today
  def get_weather(day_after = 0)
    if day_after.class != Fixnum
      p 'invalid argument'
      return 'invalid argument'
    end

    month, day, hour = get_time(day_after)
    weathers = get_1day_weather(month, day, hour)
    judge_weather(weathers)
  end

  def get_city_info
    response = open(@BASE_URL + "?id=#{@CITY_ID}&APPID=#{@API_KEY}")
    result = JSON.parse(response.read)
    result['city']
  end
end

if __FILE__ == $0
  weather = Weather.new
  city = weather.get_city_info
  p city
end
