require 'epitools'

data = Path["input.txt"].lines.to_a

sum = 0
sums = Hash.of_integers
data.map(&:to_i).cycle.each {|n|
  sum += n;
  #p [n, sum]
  sums[sum] += 1;
  if sums[sum] > 1;
    p sum;
    exit;
  end
}