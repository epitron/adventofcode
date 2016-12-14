def decomp(str)
  total = 0
  pos    = 0

  loop do
    if mpos = (str =~ /(\((\d+)x(\d+)\))/)

      parens, length, reps = $1, $2.to_i, $3.to_i

      total += mpos if mpos > 0

      start  = mpos + parens.size
      finish = start + length
      target = str[start...finish]

      total += decomp(target) * reps

      str = str[finish..-1]
    else
      total += str.size - pos
      break
    end
  end

  total
end

input = File.read("input.txt").chomp

p decomp(input)
