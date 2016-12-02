total = 0
chars = 0

open("input.txt").each_line do |line|
  line.strip!

  # total += line.size
  # chars += line.inspect.size
  total += eval(line).size
  chars += line.size
end

p chars - total 