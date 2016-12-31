SRC_DIR = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'julius'
require 'pry'

require File.join(SRC_DIR, '/command')

class HeyRaspi
  def run(julius)
    waiting = Time.now
    status = 'waiting'
    commands = Command.new

    begin
      julius.each_message do |message, prompt|
        case message.name
        when :RECOGOUT
          prompt.pause

          shypo = message.first
          whypo = shypo.first
          confidence = whypo.cm.to_f

          puts "#{message.sentence} #{confidence}"
          # confidenceの値が大きいほど，認識の確度が高い
          if confidence >= 0.9

            # recognize registered commands
            if status == 'recognizing'
              result = commands.execute(message.sentence)
              if result
                out_recog_sounds(result)
              end
              status = 'waiting'
              p "status: #{status}"
            end

            # recognize wake up commands
            if message.sentence == 'ヘイラズパイ'
              status = 'recognizing'
              waiting = Time.now
              out_recog_sounds('pon-pon')
              p "status: #{status}"
            end

          end
          prompt.resume
        end

        # time out recognizing mode
        if status == 'recognizing' && (Time.now - waiting) > 5 # time out 5sec
          status = 'waiting'
          p 'timeout'
          p "status: #{status}"
        end
      end

    rescue REXML::ParseException
      puts "retry…"
      retry
    end
  end

  # output result using 'say' command
  def out_recog_sounds(str)
    p str
    system('say', str)
  end
end

# main
# start Julius connection
puts "接続中…"
julius = Julius.new

puts "準備OK！"
hey_raspi = HeyRaspi.new
hey_raspi.run(julius)
