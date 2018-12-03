require 'epitools'

input = Path["input.txt"].lines.map(&:to_i)

both = input.partition {|x| x >= 0}
both.last.map!(&:abs)
# both.map!(&:sort)

# p sum: input.sum

# sum = 0
# counts = Hash.of_integers

# loop do
#   input.each_with_index do |n,i|
#     sum += n
#     # puts "%6d: %8d (%8d)" % [i,sum,n]
#     if (counts[sum] += 1) > 1
#       exit
#     end
#   end
#   p sum
# end

# pp both.first.zip(both.last)

# countpairs = Hash.new { |h,k| h[k] = {} }
# result = both.map { |ns| ns.group_by(&:itself) }
# both.each_with_index { |ns, i| ns.each { |n| countpairs[n][i] += 1 } }



p input.each_cons(2).map{|a,b| a.abs + b.abs }.map {|c| (c + 48).chr rescue nil }