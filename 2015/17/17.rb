require 'epitools'

containers = open("input.txt").read.split.map(&:to_i).sort

results = containers.powerset.select { |cs| cs.reduce(:+) == 150 }

p results.count

smallest = results.min_by(&:size)
p results.select { |cs| cs.size == 4 }
