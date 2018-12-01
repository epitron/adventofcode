require 'epitools'

door     = "abbhdwsy"
password = [nil]*8
counter  = 0

loop do
  hash = "#{door}#{counter}".md5
  if hash[0...5] == "00000"
    puts "Found: #{hash}"

    pos = hash[5]

    if pos >= "0" and pos <= "7"
      pos = pos.to_i
      password[pos] = hash[6] unless password[pos]
    end

    puts "password so far: #{password}"

    break unless password.any?(&:nil?)
  end

  counter += 1

  puts counter if counter % 123723 == 0
end

puts "password: #{password.join}"