require 'epitools'

class Bot

  attr_accessor :num, :chips, :commands

  @@bots    = []
  @@outputs = []

  def self.bots; @@bots; end
  def self.outputs; @@outputs; end

  def self.[](n)
    @@bots[n] ||= new(n)
    @@bots[n]
  end

  def initialize(num)
    @num = num
    @chips = []
    @commands = []
  end

  def self.process_input(lines)
    lines.each do |line|
      case line
      when /value (\d+) goes to bot (\d+)/
        Bot[$2.to_i].chips << $1.to_i
      when /bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/
        Bot[$1.to_i].commands << [
          [$2.to_sym, $3.to_i],
          [$4.to_sym, $5.to_i]
        ]
      else
        raise "Unrecognized command: #{line}"
      end
    end
  end

  def do_next_command!
    raise "no commands" if commands.empty?
    command = commands.pop

    # raise "bot #{num} was responsible!" if chips.sort == [17,61]

    command.zip(chips.sort).each do |(type, tnum), chip|
      puts "bot #{num} giving #{chip} to #{type} #{tnum}"

      case type
      when :bot
        Bot[tnum].chips << chip
      when :output
        @@outputs[tnum] ||= []
        @@outputs[tnum] << chip
      else
        raise "unknown type"
      end
    end

    chips.clear
  end

  def self.step
    if bot = bots.find {|b| b&.two? }
      bot.do_next_command!
      true
    else
      false
    end
  end

  def two?
    raise "too many chips" if chips.size > 2
    chips.size == 2
  end

  def to_s
    "#<Bot #{num}, chips=#{chips}, cmds=#{commands.inspect}>"
  end
  alias_method :inspect, :to_s

end

input = File.read("input.txt").each_line.map(&:strip)
# input = File.read("test.txt").each_line.map(&:strip)

Bot.process_input(input)

loop do
  puts Bot.bots
  puts "outputs: #{Bot.outputs}"
  puts
  if Bot.step
    puts
    puts "--------------------------------------------------------------------"
    puts
  else
    puts "Done!"
    break
  end
end

