require 'epitools'

class Entity < Struct.new(:name, :hp, :damage, :armor, :items)

  def initialize(*args)
    super

    items.each do |item|
      self.damage += item.damage
      self.armor  += item.armor
    end
  end

  def item_cost
    items.reduce(0) { |total, item| total + item.cost }
  end

  def attack!(other)
    amount    = [self.damage - other.armor, 1].max
    other.hp -= amount

    # puts "#{name} (#{hp} hp) === #{amount} dmg ===> #{other.name} (#{other.hp} hp)"
  end

  def dead?
    hp <= 0
  end
end

class Item < Struct.new(:name, :cost, :damage, :armor)
  def initialize(name, *stats)
    super(name, *stats.map(&:to_i))
  end
end



all_items = []

%{
  # Weapons:    Cost  Damage  Armor
  Dagger        8     4       0
  Shortsword   10     5       0
  Warhammer    25     6       0
  Longsword    40     7       0
  Greataxe     74     8       0

  # Armor:      Cost  Damage  Armor
  Leather      13     0       1
  Chainmail    31     0       2
  Splintmail   53     0       3
  Bandedmail   75     0       4
  Platemail   102     0       5

  # Rings:      Cost  Damage  Armor
  Damage+1    25     1       0
  Damage+2    50     2       0
  Damage+3   100     3       0
  Defense+1   20     0       1
  Defense+2   40     0       2
  Defense+3   80     0       3
}.each_line do |line|

  line.strip!

  next if line =~ /^#/ or line.empty?
  
  all_items << Item.new(*line.split)
end

weapons = all_items[0..4]
armors  = all_items[5..10] + [nil]
rings   = all_items[11..-1]


def fight(a, b)
  [a, b].cycle.each_cons(2) do |attacker, defender|
    attacker.attack!(defender)
    if defender.dead?
      puts "#{attacker.name} wins!"
      return attacker
    end
  end
end


wins = []
losses = []

weapons.each do |weapon|
  armors.each do |armor|
    (0..2).each do |ring_count|
      rings.combination(ring_count).each do |rs|
        items = [weapon, armor, *rs].compact
        me    = Entity.new("Me",   100, 0, 0, items)
        cost  = items.sum_by(&:cost) || 0

        boss  = Entity.new("Boss", 109, 8, 2, [])

        winner = fight(me, boss)

        if winner == me
          wins << me
        else
          losses << me
        end

        pp me.item_cost, me
        pp boss
        puts
        puts
      end
    end
  end
end

# result = wins.min_by(&:first)
result = losses.max_by(&:item_cost)

puts "========== Result: =============================="
pp result.item_cost, result

