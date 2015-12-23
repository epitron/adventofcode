require 'prime'


goal = 29000000

def factors(n)
  n.prime_division.map { |n,count| [n]*count }.flatten   
end

def powerset(set)
  (1..set.size).flat_map do |n|
    set.combination(n).to_a
  end
end


def brute_style(n)
  ps = 0
  (1..n.sqrt).each do |x|
    if n % x == 0
      ps += x * 10
      ps += (n/x) * 10
    end
  end
  ps
end


def factor_style(n)
  10 + (powerset(n.factors).map { |s| s.reduce(:*) * 10 }.uniq.sum || 0)
end

#
# # Too slow!
#
# (100000..20000000).each do |n|
#   if (a = factor_style(n)) >= goal
#     p [n, a]
#     exit
#   end

#   p [n,a] if n % 1000 == 0
# end



# # Part 1

# def array_style(goal)
#   houses = Array.new(goal/10, 0)

#   (1...houses.size).each do |elf|
#     # p elf
#     elfscore = elf * 10
#     elf.step(by: elf, to: houses.size-1) do |n|
#       houses[n] += elfscore
#     end
#   end

#   houses.each_with_index.find { |e,i| e >= goal }
# end


# Part 2

def array_style(goal)
  houses = Array.new(goal/10, 0)

  house_count = houses.size

  (1...houses.size).each do |elf|
    # p elf
    house    = elf
    elfscore = elf * 11
    (1..50).each do |n|
      house = n * elf
      break if house >= house_count
      houses[house] += elfscore
    end
  end

  houses.each_with_index.find { |e,i| e >= goal }
end

p array_style(goal)

