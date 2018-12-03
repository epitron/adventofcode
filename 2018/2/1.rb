counts = [0,0]

open("input.txt").each_line do |line|
  line.chomp!
  grouped = line.chars.group_by(&:itself)
  counts[0] += 1 if grouped.values.any?{|g| g.size == 2}
  counts[1] += 1 if grouped.values.any?{|g| g.size == 3}
end
p counts[0] * counts[1]
