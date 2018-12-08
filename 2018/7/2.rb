require 'epitools'

class Worker < Struct.new(:char, :time)

  def initialize
    self.time = nil
  end

  def work!(char)
    self.char = char
    # self.time = (char.upcase.ord - ?A.ord) + 61
    self.time = (char.upcase.ord - ?A.ord) + 1
  end

  def tick!
    if time and time == 0
      # raise "NO MORE TIME"
      char
    elsif char
      self.time -= 1
      nil
    end
  end

  def working?
    time && time > 0
  end

  def free?
    not working?
  end

  def reset!
    self.char = nil
    self.time = nil
  end

  def to_s
    "#{char || "."}(#{time})"
  end

end


class Workers

  attr_accessor :ws, :time, :completed

  def initialize(n)
    @ws = n.times.map { Worker.new }
    @time = 0
    @completed = []
  end

  def tick!
    finished = @ws.map(&:tick!).compact
    @time += 1
    finished
  end

  def queue!(char)
    if w = @ws.find { |w| w.free? }
      w.work!(char)
      true
    else
      false
    end
  end

  def free
    @ws.find { |w| w.free? }
  end
  alias_method :any?, :free

  def print!
    puts "#{@time} #{ws.map(&:to_s).join(" ")} #{completed.inspect}"
  end

  def run(h)
    sorted    = h.sort
    completed = []

    print!

    loop do
      sorted.each do |e|
        targ, deps = e
        if deps.empty? or deps.all? { |dep| completed.include? dep }
          if queue!(targ)
            sorted.delete_if {|t, d| targ == t }
          end
        end
      end

      finished_chars = tick!
      completed += finished_chars

      print!

      break if sorted.empty? and ws.done?
    end

    completed.join
  end

end


def parse(file)
  input = Path[file].nicelines.map { |line| line.split.values_at(1,7) }
  h = {}
  input.each do |dep, targ|
    h[dep] ||= []
    h[targ] ||= []
    h[targ] << dep
  end

  h
end

file, workers = ["input.txt", 5]
file, workers = ["test.txt", 2]
h = parse(file)

p Workers.new(workers).run(h)
