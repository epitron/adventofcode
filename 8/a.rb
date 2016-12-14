class Screen
  BLANK = '▒'
  SOLID = '█'

  def initialize(rows=6, cols=50)
    @screen = rows.times.map { [BLANK]*cols }
  end

  # Rotate right
  def rotate_row(y, amt)
    @screen[y].rotate!(-amt)
  end

  # Rotate down
  def rotate_column(x, amt)
    @screen = @screen.transpose
    rotate_row(x, amt)
    @screen = @screen.transpose
  end

  def rect(w,h)
    h.times do |y|
      w.times do |x|
        @screen[y][x] = SOLID
      end
    end
  end

  def to_s
    @screen.map(&:join).join("\n") + "\n\n"
  end

  def pixel_count
    @screen.flatten.count { |c| c == SOLID }
  end

  def parse(line)
    case line
    when /rotate row y=(\d+) by (\d+)/
      rotate_row($1.to_i, $2.to_i)
    when /rotate column x=(\d+) by (\d+)/
      rotate_column($1.to_i, $2.to_i)
    when /rect (\d+)+x(\d+)/
      rect($1.to_i, $2.to_i)
    else
      raise "dunno!"
    end
  end
end

#######################################################################################

lines = open("input.txt").each_line.map(&:strip)
s = Screen.new

lines.each do |line|
  puts line
  s.parse(line)
  puts s
end

p s.pixel_count
