require 'epitools'

class Elf < Struct.new(:n, :presents)
  def steals!(other)
    self.presents += other.presents
  end

  def inspect
    "{Elf#{n}: #{presents}}"
  end
end

def winner(num=5)
  elves = (1..num).map {|n| Elf.new(n, 1) }

  pos = 0
  steps = 0

  while elves.size > 1
    target = (pos+1) % elves.size

    elves[pos].steals! elves[target]

    elves.delete_at(target)
    pos -= 1 if target < pos

    pos = (pos+1) % elves.size
    steps += 1
    # p (steps / num.to_f) if steps % 277 == 0
  end

  elves.first.n
end

def calc_winner(num=5)
  pos = 1
  pow = 2
  (1...num).each do |n|
    pos += 2
    if pos >= pow
      pos = 1
      pow *= 2
    end
  end
  pos
end

# pp (1..32).map { |n| {n: n, winner: winner(n), calc: calc_winner(n)} }
p calc_winner(3014387)