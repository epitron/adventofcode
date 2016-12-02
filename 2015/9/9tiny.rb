ds = open("input.txt").
      map { |line| c, d = line.strip.split(" = "); cs = c.split(" to "); [[cs, d.to_i], [cs.reverse, d.to_i]] }.
      flatten(1).
      to_h

cities = ds.keys.flatten.uniq

tours = cities.permutation(cities.size).
  map { |perm| perm.each_cons(2).map{|pair| ds[pair] }.reduce(:+) }

p min: tours.min, max: tours.max
