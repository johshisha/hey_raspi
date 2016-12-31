require File.join(SRC_DIR, '/weather')

class Command
  def initialize(args = {})
    @weather = Weather.new # handle weather
  end

  def execute(msg)
    case msg
    # --weather commands--
    when '今日の天気'
      msg + 'は' + @weather.get_weather(0)
    when '明日の天気'
      msg + 'は' + @weather.get_weather(1)
    end
  end
end
