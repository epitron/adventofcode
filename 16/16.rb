# Sue 1: goldfish: 9, cars: 0, samoyeds: 9

class Hash
  def contains?(other)
    other.keys.all? { |k,v| other[k] == self[k] }
  end

  def special_contains?(other)
    [:cats, :trees].all? { |k| other[k] ? other[k] > self[k] : true } and
      [:pomeranians, :goldfish].all? { |k| other[k] ? other[k] < self[k] : true } and
      (other.keys - [:cats, :trees, :pomeranians, :goldfish]).all? { |k| self[k] == other[k] }
  end
end

sues = open("input.txt").
  read.
  scan(/Sue (\d+): (.+)/).
  map do |sue, attrs|
    attrs = attrs.split(", ").
      map do |attr|
        k, v = attr.split(": ")
        [k.to_sym, v.to_i]
      end.to_h
    [sue.to_i, attrs]
  end

goal = {
  children: 3,
  cats: 7,
  samoyeds: 2,
  pomeranians: 3,
  akitas: 0,
  vizslas: 0,
  goldfish: 5,
  trees: 3,
  cars: 2,
  perfumes: 1,
}

# p sues.select { |sue, attrs| goal.contains? attrs }.to_a
p sues.select { |sue, attrs| goal.special_contains? attrs }.to_a
