def straight_triple?(input)
  input.each_char.each_cons(3).any? { |a,b,c| a.succ == b && b.succ == c }
end

input = "cqjxxyzz"

count = 0

loop do
  input.succ!
  count += 1

  if !input[/[iol]/] and input[/(.)\1.*(.)\2/] and straight_triple?(input)
    puts "winner: #{input}"
    break
  end

  puts input if count % 100000 == 0
end