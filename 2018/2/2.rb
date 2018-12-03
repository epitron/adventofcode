require 'epitools'

input = open("input.txt").read
# input = %{abcde
# fghij
# klmno
# pqrst
# fguij
# axcye
# wvxyz}

lines = input.each_line.map(&:chomp)

r = lines.combination(2).map do |as,bs|
  same = as.chars.zip(bs.chars).select{|a,b| a == b }
  if same.size+1 == as.size
    p winner: same.map(&:first).join
  end
end

# pp r