require 'epitools'

BLANK    = ' '
EXPLORED = '▒'
SOLID    = '█'

def draw(nodes, target, w=100, h=45)
  home

  nodes = Set.new nodes

  h.times do |y|
    line = w.times.map do |x|
      pos = [x,y]
      if pos == target
        SOLID.light_red
      else
        nodes.include?(pos) ? EXPLORED : (valid?(pos) ? BLANK : SOLID)
      end
    end.join
    puts line
  end
end

def clear
  print "\e[H\e[J"
end

def home
  print "\e[H"
end

class Array
  def move(offset)
    [self[0] + offset[0], self[1] + offset[1]]
  end
end

def valid?(move)
  x,y = move
  return false unless x >= 0 and y >= 0
  num = x*x + 3*x + 2*x*y + y + y*y + 1350
  num.to_s(2).each_char.count { |c| c == "1" }.even?
end

offsets = [
           [0,-1],
  [-1, 0],         [1, 0],
           [0, 1],
]

pos      = [1,1]
target   = [31,39]
frontier = [pos]
visited  = Set[] + frontier
count    = 0

clear
loop do
  frontier = frontier.flat_map do |previous_move|
      offsets.map { |offset| previous_move.move(offset) }
  end.uniq.select { |next_move| !visited.include?(next_move) and valid?(next_move) }

  count += 1

  if frontier.any? { |move| move == target }
    puts "Finished in #{count} moves!"
    break
  end

  visited += frontier

  draw(visited, target)
  p count: count, visited: visited.size, frontier: frontier.size
  sleep 0.02

  # break if count == 50 # (for part B)
end
