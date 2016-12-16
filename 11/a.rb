###############################################################################################################
require 'epitools'
###############################################################################################################

class Thing < Struct.new(:num)
  def self.[](*args)
    new(*args)
  end

  def inspect; "#{self.class.name}#{num}"; end
  alias_method :to_s, :inspect

  def safe?(other)
    (self.class == other.class) or (num == other.num)
  end

  def unsafe?(other)
    not safe?(other)
  end
end

# Generator
class G < Thing; end

# Chip
class C < Thing; end

###############################################################################################################

class State < Struct.new(:floors, :elevator)

  ADJACENT_FLOORS = {
    0 => [1],
    1 => [0, 2],
    2 => [1, 3],
    3 => [2]
  }

  def current_floor
    floors[elevator]
  end

  def all_combinations_of_items_on_this_floor
    current_floor.combination(1) + current_floor.combination(2).select { |a,b| a.safe? b }
  end

  def adjacent_floors
    ADJACENT_FLOORS[elevator]
  end

  # Return a new State where the items have moved
  def move(items, floor_num)
    new_floors = floors.map(&:dup)

    old_floor = new_floors[elevator]
    new_floor = new_floors[floor_num]

    # move items to new floor
    items.each { |item| old_floor.delete(item); new_floor.add(item) }

    State.new(new_floors, floor_num)
  end

  def safe_item_combination?(items)
    # find solitary chips, check for generators that aren't in the same group
    chips, gens = items.partition { |i| i.is_a? C }

    chips.all? do |chip|
      hooked_up = false
      fried     = false

      gens.each do |gen|
        (gen.num == chip.num) ? hooked_up = true : fried = true
      end

      hooked_up or not fried
    end
  end


  # def items_safe_on_floor?(items, floor_num)
  #   items.all? do |item|
  #     floors[floor_num].all? do |floor_item|
  #       item.safe? floor_item
  #     end
  #   end
  # end

  # # Valid moves:
  # # - 1 or 2 of anything to any floor
  # # - always stops on each floor to recharge
  # # - Floor can only have a generator of the same type as the chip, or no generator
  # def next_states
  #   adjacent_floor_nums.map do |floor_num|
  #     all_combinations_of_items_on_this_floor.flat_map do |items|
  #       # if items_safe_on_floor?(items, floor_num)
  #       if safe_item_combination?(floors[floor_num] + items)
  #         move(items, floor_num)
  #       end
  #     end.compact
  #   end
  # end


  #
  # Depth-first solver
  #
  def solve(previous_moves=Set[], best=120)
    length = previous_moves.size

    if length >= best
      # puts "Giving up: #{length}"
      return best
    end

    if victory?
      puts "========= Solution: #{length} ============="
      return length
    end

    ADJACENT_FLOORS[elevator].each do |floor_num|
      all_combinations_of_items_on_this_floor.flat_map do |items|
        if safe_item_combination?(floors[floor_num] + items)
          next_move = move(items, floor_num)
          next if previous_moves.include? next_move
          l = next_move.solve(previous_moves + [self], best)
          best = l if l < best
        end
      end
    end

    best
  end

  def victory?
    floors[0..2].all?(&:empty?)
  end

  def to_s
    floors.map.with_index { |f, i| "#{i}: #{elevator == i ? "[E]" : "   "} #{f.to_a.join(" ")} " }.reverse.join("\n")
  end

  def inspect
    "{ " + floors.map.with_index { |f, i| "|#{i}| #{elevator == i ? " E " : ""}#{f.to_a.join(" ")}" }.reverse.join(" ") + " }"
  end

end


###############################
# Real data
#
# The first floor contains a 1 generator and a 1-compatible microchip.
# The second floor contains a 2 generator, a 3 generator, a 4 generator, and a 5 generator.
# The third floor contains a 2-compatible microchip, a 3-compatible microchip, a 4-compatible microchip, and a 5-compatible microchip.
# The fourth floor contains nothing relevant.

starting_floors = [
  Set[ G[1], C[1],             ],
  Set[ G[2], G[3], G[4], G[5], ],
  Set[ C[2], C[3], C[4], C[5], ],
  Set[                         ],
]

###############################
# Test data
#
# The first floor contains a 1-compatible microchip and a 2-compatible microchip.
# The second floor contains a 1 generator.
# The third floor contains a 2 generator.
# The fourth floor contains nothing relevant.

# starting_floors = [
#   Set[ C[1], C[2], ], # Elevator
#   Set[ G[1]        ],
#   Set[ G[2],       ],
#   Set[             ],
# ]

starting_state = State.new(starting_floors, 0)

# frontier = [starting_state]
# visited  = Set.new(frontier)
# count = 0
# loop do
#   puts "#{count}: #{frontier.size}"
#   # puts "#{count}: #{frontier.size} => #{frontier.inspect}"

#   frontier = frontier.map(&:next_states).flatten.delete_if { |s| visited.include? s }
#   visited += frontier

#   if frontier.empty?
#     puts "OMG we're out of moves."
#     break
#   end

#   frontier.each do |state|
#     if state.victory?
#       puts "WE WIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#       p state
#       puts "depth: #{count+1}"
#       exit
#     end
#   end

#   count += 1
# end

if best = ARGV.first
  best = best.to_i
else
  best = 120
end

starting_state.solve(Set[], best)
