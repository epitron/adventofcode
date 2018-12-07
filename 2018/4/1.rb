require 'epitools'

class Event < Struct.new(:time, :type, :guard)

  TYPES = %i[begin wake sleep]

  def self.from_line(line)
    guard = nil
    # [1518-11-01 00:00] Guard #10 begins shift
    # [1518-11-01 00:05] falls asleep
    # [1518-11-01 00:25] wakes up
    if line =~ /^\[(.+)\] (.+)$/
      time, msg = $1, $2
      case msg
      when /Guard #(\d+) begins shift/
        guard = $1.to_i
        type = :begin
      when /asleep/
        type = :sleep
      when /wakes up/
        type = :wake
      else
        raise "Couldn't recognize #{msg.inspect}"
      end
      new(time, type, guard)
    else
      raise "Couldn't parse #{line.inspect}"
    end
  end
end

evs = Path["example.txt"].nicelines.map { |line| Event.from_line(line) }
evs.sort_by!(&:time)

# Set guards
current_guard = nil
evs.each do |ev|
  if ev.guard
    current_guard = ev.guard
  elsif current_guard
    ev.guard = current_guard
  else
    raise "whoops"
  end
end

pp evs

