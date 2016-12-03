counter = 0
open("input.txt").each_line do |line|
  ts = line.split.map(&:to_i).sort
  possible = ts[0..1].reduce(:+) > ts[2]
  counter += 1 if possible
  p [ts, possible]
end

p counter