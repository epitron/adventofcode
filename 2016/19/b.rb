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
    target = (pos + (elves.size/2)) % elves.size

    elves[pos].steals! elves[target]

    elves.delete_at(target)
    pos -= 1 if target < pos

    pos = (pos+1) % elves.size
    steps += 1
    # p (steps / num.to_f) if steps % 277 == 0

    # p elves
  end

  elves.first.n
end

def calc_winner(num=5)
  pos = 1
  pow = 3
  diff = 1

  (1...num).each do |n|
    pos += diff

    if pos >= pow/3
      diff = 2
    end

    if n % pow == 0
      pos = 1
      diff = 1
      pow *= 3
    end

  end
  pos
end

# pp (1..30).map { |n| {n: n, winner: winner(n), calc: calc_winner(n)} }.each_cons(2).map { |a,b| a.merge(diff: b[:winner] - a[:winner]) }
p calc_winner(3014387)

# 4: 3-1s, 3-2s
# 10: 9-1s, 9-2s
# 28: 27-1s, 27-2s
# 82: 81-1s, 81-2s


