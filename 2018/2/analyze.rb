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
end.join

# p counts
p signal

noise = lines.map do |line|
  line.chars.zip(signal.chars).map do |noise, sig|
    -noise.ord + sig.ord
  end
end

noise.each do |row|
  puts row.map{ | n| "%4d" % n }.join
end

