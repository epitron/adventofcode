require 'epitools'

door     = "abbhdwsy"
# door     = "abc"
password = ""
counter  = 0

loop do
  hash = "#{door}#{counter}".md5
  if hash[0...5] == "00000"
    p hash
    password << hash[5]
    puts "password so far: #{password}"

    break if password.size >= 8
  end

  counter += 1

  puts counter if counter % 123723 == 0
end

puts "Done!"