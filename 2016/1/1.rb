require 'set'

TESTS = {
  # "R2, L3" => 5,
  # "R2, R2, R2" => 2,
  # "R5, L5, R5, R3" => 12,
  "R8, R4, R4, R8" => 4,
  "L3, R1, L4, L1, L2, R4, L3, L3, R2, R3, L5, R1, R3, L4, L1, L2, R2, R1, L4, L4, R2, L5, R3, R2, R1, L1, L2, R2, R2, L1, L1, R2, R1, L3, L5, R4, L3, R3, R3, L5, L190, L4, R4, R51, L4, R5, R5, R2, L1, L3, R1, R4, L3, R1, R3, L5, L4, R2, R5, R2, L1, L5, L1, L1, R78, L3, R2, L3, R5, L2, R2, R4, L1, L4, R1, R185, R3, L4, L1, L1, L3, R4, L4, L1, R5, L5, L1, R5, L1, R2, L5, L2, R4, R3, L2, R3, R1, L3, L5, L4, R3, L2, L4, L5, L4, R1, L1, R5, L2, R4, R2, R3, L1, L1, L4, L3, R4, L3, L5, R2, L5, L1, L1, R2, R3, L5, L3, L2, L1, L4, R4, R4, L2, R3, R1, L2, R1, L2, L2, R3, R3, L1, R4, L5, L3, R4, R4, R1, L2, L5, L3, R1, R4, L2, R5, R4, R2, L5, L3, R4, R1, L1, R5, L3, R1, R5, L2, R1, L5, L2, R2, L2, L3, R3, R3, R1" => :dunno
}

TURNS = {
  "R" => 1,
  "L" => -1,
}

DIRS = {
  0 => [0, 1], # N
  1 => [1, 0], # E
  2 => [0, -1], # S
  3 => [-1, 0], # W
}


class Array
  def move(vec)
    [ self[0] + vec[0],
      self[1] + vec[1] ]
  end
end


def dist(seq)
  dir     = 0
  pos     = [0, 0]
  steps   = seq.split(", ").map {|d| [d[0], d[1..-1].to_i] }
  history = Set.new

  history << pos

  steps.each do |turn, amt|
    dir = (dir + TURNS[turn]) % 4
    vec = DIRS[dir]

    amt.times do
      pos = pos.move(vec)
      break if history.include? pos
      history << pos
    end
  end

  pos.map(&:abs).inject(:+)
end


TESTS.each do |input, expected|
  result = dist(input)

  p result: result, expected: expected
end
