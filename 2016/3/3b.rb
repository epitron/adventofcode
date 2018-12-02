rows = open("input.txt").each_line.map do |line|
  ts = line.split.map(&:to_i)
end

counter = 0
cols = rows.transpose
cols.each do |col|
  col.each_slice(3) do |ts|
    ts = ts.sort
    possible = ts[0..1].reduce(:+) > ts[2]
    counter += 1 if possible
    p [ts, possible]
  end
end

p counter