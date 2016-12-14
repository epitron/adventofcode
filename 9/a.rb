require 'epitools'

tests = {
  "A(2x2)BCD(2x2)EFG" => "ABCBCDEFEFG",
  "(6x1)(1x3)A"       => "(1x3)A",
  "X(8x2)(3x3)ABCY"   => "X(3x3)ABC(3x3)ABCY",
  "(3x3)XYZ" => "XYZXYZXYZ",
}

def decomp(str)
  result = []

  loop do
    if pos = (str =~ /(\((\d+)x(\d+)\))(.+)/)
      parens, length, reps, rest = $1, $2.to_i, $3.to_i, $4

      result << str[0...pos] if pos > 0

      start  = pos + parens.size
      finish = start + length
      target = str[start...finish]

      reps.times { result << target }

      str = str[finish..-1]
    else
      result << str
      break
    end
  end

  result.join
end


p tests.map { |a,b| decomp(a) == b }

input = File.read("input.txt").chomp

data = decomp(input)
p data.size
