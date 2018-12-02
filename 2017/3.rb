require 'epitools'

class Pos < Struct.new(:x,:y)

  def +(pos)
    result = dup
    case pos
    when Array
      result.x += pos[0]
      result.y += pos[1]
    when Pos
      result.x += pos.x
      result.y += pos.y
    else
      raise "wat"
    end

    result
  end

  def manhattan
    x.abs + y.abs
  end

  def circuit(start_val, length)
    vecs = {
      up:    Pos[0,-1],
      left:  Pos[-1,0],
      down:  Pos[0,1],
      right: Pos[1,0],
    }

    Enumerator.new do |y|
      pos = self
      val = start_val

      [
        :right,
        [:up]*(length-1),
        [:left]*length,
        [:down]*length,
        [:right]*length
      ].flatten.each do |dir|
        pos += vecs[dir]
        val += 1
        y << [val, pos]
      end
    end
  end

  def [](*args)
    Pos.new *args
  end

  def inspect
    "(#{x},#{y})"
  end

end


def corner_pos c
  Pos[c-1, c-1]
end

def corner_val c
  (2*c-1)**2
end

def side_length(c)
  (2*c)
end

def closest_corner(num)
  (num.sqrt.to_i + 1) / 2
end

def solve(num)
  c   = closest_corner(num)
  pos = corner_pos(c)
  val = corner_val(c)
  l   = side_length(c)

  if val == num
    pos
  else
    # p pos.circuit(val, l).to_a
    result = pos.circuit(val, l).find { |n, pos| n == num }
    pos = result.last
  end

  [pos, pos.manhattan]
end

p solve(361527)