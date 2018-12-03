require 'epitools'

lines = Path["input.txt"].nicelines.to_a
width = lines.first.size

counts = width.times.map { Hash.of_integers }

lines.each do |line|
  line.chars.each.with_index do |char, i|
    counts[i][char] += 1
  end
end

signal = counts.map do |hash|
  hash.sort_by(&:last).last.first
end

p counts
p signal.join