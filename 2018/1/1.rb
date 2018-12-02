require 'epitools'

input = Path["input.txt"].lines.map(&:to_i)

sum = 0
counts = Hash.of_integers

input.cycle.each do |n|
  sum += n
  if (counts[sum] += 1) > 1
    p sum
    break
  end
end