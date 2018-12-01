require 'parallel'
require 'epitools'

door     = "abbhdwsy"
# door     = "abc"

results        = []
processes      = Parallel.physical_processor_count
last_unit      = 0
work_unit_size = 100_000

loop do

  work_units = []
  processes.times do
    work_units << (last_unit...(last_unit+work_unit_size))
    last_unit += work_unit_size
  end

  puts "Testing #{work_units.first.first}...#{work_units.last.last} (results so far: #{results.size})"

  hashes = Parallel.map(work_units) do |unit|
    unit.map do |n|
      hash = "#{door}#{n}".md5
      if hash[0...5] == "00000"
        [n, hash[5]]
      else
        nil
      end
    end.compact
  end

  results += hashes.flatten(1)

  # results += hashes.select {|hash| }
  break if results.size >= 8
end

password = results.sort.take(8).map(&:last).join

puts "password: #{password}"
