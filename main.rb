SRC_DIR = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'julius'

class HeyRaspi
  def run(julius)
    begin
      julius.each_message do |message, prompt|
        case message.name
        when :RECOGOUT
          prompt.pause

          shypo = message.first
          whypo = shypo.first
          confidence = whypo.cm.to_f

          puts "#{message.sentence} #{confidence}"

          prompt.resume
        end
      end
    rescue REXML::ParseException
      puts "retry…"
      retry
    end
  end
end

puts "接続中…"
julius = Julius.new

puts "準備OK！"
hey_raspi = HeyRaspi.new
hey_raspi.run(julius)
