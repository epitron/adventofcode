require 'json'

def sum(thing)

  case thing
  when Numeric
    thing
  when Hash
    thing.values.include?("red") ? 0 : sum(thing.values) 
  when Array
    thing.map { |e| sum(e) }.reduce(:+)
  else
    0
  end

end

data = JSON.load(open("input.txt"))
p sum(data)