require 'pp'

# class Array

#   def ps
#     return to_enum(:ps) unless block_given?

#     each { |e| yield [e] }

#     each.with_index do |e, i|
#       (self[0...i] + self[i+1..-1]).ps.each do |subset|
#         yield [e, *subset]
#       end
#     end
#   end

# end


# pp [1,2,3,4].ps.to_a

a = [1,2,3,4,5]

memo = {}

(1..a.size-1).each do |n|
  a.combination(n) do |combo|
    key = combo.sort

    (2..key.size).each do |prefix_size|
      prefix = key[0...prefix_size]
      if val = memo[key]
        p val
        break
      else
        memo[key] ||= :cached
      end
    end
  end
end