require 'set'

distances = {}

open("input.txt").each_line do |line|
  if line =~ /(\w+) to (\w+) = (\d+)/
    distances[ [$1, $2] ] = $3.to_i
    distances[ [$2, $1] ] = $3.to_i
  end
end

cities = distances.keys.flatten.uniq

p distances

checked = Set.new


tours = cities.permutation(cities.size).map do |route|
  next if checked.include?(route)
  checked << route.reverse
  total = 0
  route.each_cons(2) { |pair| total += distances[pair] }
  p (result = [total, route])
  result
end.compact

puts "WINNER:"
p tours.max_by{|l, route| l }
