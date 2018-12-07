require 'epitools'

def time2min(time)
  h, m = time.split(":").map(&:to_i)
  m + (h*60)
end

# file = "example.txt"
file = "input.txt"

evs = Path[file].nicelines.sort
g = evs.each
a = Matrix.zeros

loop do
  ev = g.next
  if ev =~ /^\[(.+)\] (.+)$/

end

# pp evs.grep(/begins/).sort_by{|ev| ev.split[1] }
