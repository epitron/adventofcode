require 'pp' 

class Array

  def perms
    return to_enum(:perms) unless block_given?

    if size <= 1
      yield self
    else
      for i in 0...size
        e     = self[i]
        rest  = self[0...i] + self[i+1..-1]

        p i: i, e: e, self: self, rest: rest

        rest.perms.each do |perm|
          yield [e, *perm]
        end
      end
    end

  end

end

a = [1,2,3,4]

p1 = a.perms.sort
p2 = a.permutation(a.size).sort

pp p1size: p1.size, p2size: p2.size
pp both: p1 & p2
pp mine: p1 - p2
pp ruby: p2 - p1
