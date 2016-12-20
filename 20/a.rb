require 'epitools'

ranges = File.read("input.txt").each_line.map { |l| Range.new *l.split("-").map(&:to_i) }

# ranges = [ 1..5, 2..6, 7..10, 7..20, 25..50 ]

def optimize(ranges)
  ranges = ranges.sort_by(&:first)

  result = [ranges.first]

  ranges[1..-1].each do |elem|
    a, b = result[-1], elem

    if a.actual_last >= b.first-1
      if a.actual_last >= b.actual_last
        # drop b!
      else
        result[-1] = a | b
      end
    else
      result << b
    end
  end

  result
end

optimized = optimize(ranges)
p first: ranges.first.actual_last+1

max = 4294967295
optimized << (max+1..max+2)

diffs = optimized.each_cons(2).map do |a,b|
  b.first - (a.actual_last + 1)
end

p available: diffs.sum

