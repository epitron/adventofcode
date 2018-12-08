require 'epitools'

if ARGV.include?("-t")
  file = "test.txt"
else
  file = "input.txt"
end

input = Path[file].nicelines
