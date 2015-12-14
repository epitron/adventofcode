##########################################################################
# CLASSY

class Reindeer < Struct.new(:name, :speed, :endurance, :rest)

  attr_accessor :pos, :t, :state, :next_rest, :next_flight, :score

  def initialize(*args)
    super(*args)
    reset!
  end

  def reset!
    @pos = @t = @score = 0
    @state = :flying
    @next_rest = @t + endurance
  end

  def in_the_lead!
    @score += 1
  end

  def tick!
    @t += 1

    case state
    when :resting
      if @t == @next_flight
        @state, @next_rest = :flying, @t + endurance
      end
    when :flying
      @pos += speed

      if @t == @next_rest
        @state, @next_flight = :resting, @t + rest
      end
    end
  end

  def to_s
    "#{name.rjust(10)} (#{state.to_s.ljust(7)}): pos: #{pos.to_s.rjust(5)} km, t: #{t}, score: #{score}"
  end
end

##########################################################################
# Terminal control codes

def clear
  print "\e[H\e[J"
end

def home
  print "\e[H"
end

def puts_and_clear(line)
  puts "#{line}\e[0K"
end

##########################################################################
# Load 'em up!

rs = []

open("input.txt").each_line do |line|
  if line.strip =~ %r{^(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds}
    rs << Reindeer.new($1, $2.to_i, $3.to_i, $4.to_i)
  end
end

##########################################################################
# Run the race

clear
2503.times do |t|
  # time keeps on slippinggg.... into the fuuutuuurreeee
  rs.each(&:tick!)

  # find the leaders!
  rs.sort_by! { |r| -r.pos }
  leaders = rs.select { |r| r.pos == rs.first.pos }
  leaders.each(&:in_the_lead!)

  # show the leaders!
  home
  rs.each_with_index { |r,i| puts_and_clear "#{i+1}. #{r}" }

  # zzzzzz
  sleep 0.03
end

puts "winner: #{rs.max_by(&:score)}"


