require 'epitools'

file = "test.txt"
file = "input.txt"

input = Path[file].nicelines.map { |line| line.split.values_at(1,7) }

h = {}

input.each do |dep, targ|
  h[dep] ||= []
  h[targ] ||= []
  h[targ] << dep
end

pp h

def compute(h)
  sorted = h.sort

  # completed = Set.new
  # order = []
  completed = []

  loop do
    sorted.each do |e|
      targ, deps = e
      # p [e, completed]
      if deps.empty? or deps.all? { |dep| completed.include? dep }
        completed << targ
        # order << targ
        sorted.delete(e)
        break
      end
    end

    break if sorted.empty?
  end

  completed
end

p compute(h).join