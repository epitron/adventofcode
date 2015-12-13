diffs = {}
open("input.txt").each_line do |line|
  if line =~ /(\w+) would (lose|gain) (\d+).+next to (\w+)/
    person, change, amount, neighbour = $1, $2, $3.to_i, $4
    amount = -amount if change == "lose"
    diffs[[person, neighbour]] = amount
  end
end

people = diffs.keys.flatten.uniq

people.each do |psn|
  diffs[["me", psn]] = 0
  diffs[[psn, "me"]] = 0
end

people = diffs.keys.flatten.uniq

p people
p diffs

scores = people.permutation(people.size).map do |seats|
  # p seats
  happiness = 0
  (seats + [seats.first]).each_cons(2) do |a,b|
    happiness += diffs[[a,b]] 
    happiness += diffs[[b,a]] 
  end

  happiness
end

p scores.max