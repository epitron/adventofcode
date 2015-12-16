require 'pp'

class Array
  def *(c); map { |e| e * c }; end
  def +(other); zip(other).map { |es| es.reduce(:+) }; end
end

num = /([-\d]+)/

ingredients = open("input.txt").
  read.
  # Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5
  scan(/capacity #{num}, durability #{num}, flavor #{num}, texture #{num}, calories #{num}/).
  map {|attrs| attrs.map(&:to_i) }

p ingredients

def solve(ingredients)
  return to_enum(:solve, ingredients) unless block_given?

  (0..100).each do |w|
    (0..100-w).each do |x|
      (0..100-(w+x)).each do |y|
        z = 100-w-x-y
        if z >= 0
          vec = [w,x,y,z]
          result = ingredients.
            zip(vec).
            map {|attrs, coeff| attrs * coeff }.
            reduce(:+)

          next if result.last != 500 or result.any? { |x| x < 0 }

          yield [result[0..-2].reduce(:*), vec]
        end
      end
    end
  end
end

p solve(ingredients).max_by(&:first)
