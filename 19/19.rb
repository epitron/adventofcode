require 'set'

class Hash
  def self.of_arrays; new {|h,k| h[k] = [] }; end
end

class String

  def indexes(sub)
    return to_enum(:indexes, sub) unless block_given?

    pos = 0

    loop do
      if match = index(sub, pos)
        yield match
        pos += sub.size

        break if pos+sub.size >= size
      else
        break
      end
    end
  end

end


def calibrate(rules, mol)
  results = Set.new

  rules.each do |from, tos|
    tos.each do |to|
      mol.indexes(from) do |i|
        result = mol.dup
        result[i...i+from.size] = to
        results << result
      end
    end
  end

  results
end


# rules = {
#   "H" => ["HO", "OH"],
#   "O" => ["HH"]
# }

rules = Hash.new {|h,k| h[k] = [] }
open("rules.txt").
  read.
  scan(/^(\w+) => (\w+)/).
  each { |k, v| rules[k] << v }

# mol = "HOH"
mol = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"

inv = Hash.of_arrays
rules.each { |k,vs| vs.each { |v| inv[v] << k }}

sorted_inv = inv.sort_by{|k,v| -k.size }

# p calibrate(rules, mol).size

smallmol = mol.dup

moves = 0
while smallmol != "e"
  sorted_inv.each do |from, tos|
    tos.each do |to|
      while smallmol[from]
        p [from, to]
        smallmol[from] = to 
        moves += 1
      end
    end
  end
end

p moves

