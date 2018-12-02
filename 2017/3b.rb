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

  def up
    self + Pos[0,-1]
  end

  def down
    self + Pos[0,1]
  end

  def right
    self + Pos[1,0]
  end

  def left
    self + Pos[-1,0]
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


# def gen()
#   vecs = {
#     up:    Pos[0,-1],
#     left:  Pos[-1,0],
#     down:  Pos[0,1],
#     right: Pos[1,0],
#   }

#   Enumerator.new do |y|
#     pos = self
#     val = start_val

#     [
#       :right,
#       [:up]*(length-1),
#       [:left]*length,
#       [:down]*length,
#       [:right]*length
#     ].flatten.each do |dir|
#       pos += vecs[dir]
#       val += 1
#       y << [val, pos]
#     end
#   end
# end

class Matrix
  def center
    @center ||= (size.first-1) / 2
  end

  def at(pos)
    self[pos.x+center, pos.y+center]
  end

  def set(pos, val)
    self[pos.x+center, pos.y+center] = val
  end

  def neighbourhood(pos)
    [
      at(pos.left),
      at(pos.right),
      at(pos.up),
      at(pos.down),
      at(pos.up.left),
      at(pos.up.right),
      at(pos.down.left),
      at(pos.down.right),
    ]
  end

  def print
    row_vectors.each do |row|
      puts row.map { |x| x.nil? ? "   " : x.to_s.rjust(3) }.to_a.join(" | ")
    end
  end
end

def spiral_until(limit, size=11)
  m = Matrix.build(size) { nil }

  pos  = Pos[0,0]
  val  = 1
  side = 1

  m.set(pos, val)

  while val < limit
    l = side_length(side)

    [
      :right,
      [:up]*(l-1),
      [:left]*l,
      [:down]*l,
      [:right]*l
    ].flatten.each do |dir|
      pos = pos.send(dir)
      nh = m.neighbourhood(pos)
      p nh
      val = nh.compact.sum
      m.set(pos, val)
      p dir => pos, :val => val

      m.print

      return [m,val] if val > limit
    end

    side += 1
  end

  [m,nil]
end

m, val = spiral_until(361527)
p val

