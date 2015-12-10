class Array
  def move!(vec)
    vec.each_with_index { |n, i| self[i] += n }
  end
end

lt        = "<^v>".each_char.zip([[-1,0],[0,1],[0,-1],[1,0]]).to_h
santa     = [0,0]
robosanta = [0,0]

r = open("input.txt").each_char.map.with_index do |c,i|
  vec     = lt[c]
  current = (i % 2 == 0) ? santa : robosanta

  current.move!(vec)

  current.dup
end.uniq.size

p r