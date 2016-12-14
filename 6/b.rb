require 'epitools'

input = %{eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar}.lines.map(&:strip)

input = File.read("input.txt").lines.map(&:strip)

puts input.map(&:chars).transpose.map{|col| col.count_by(&:itself).sort_by{|k,v| v }.first.first }.join