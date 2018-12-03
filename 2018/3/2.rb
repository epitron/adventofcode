require 'epitools'

input = Path["input.txt"].nicelines

def noverlaps(size, input)
  a        = size.times.map { [0] * size }
  overlaps = Set.new
  all      = Set.new

  input.each do |line|
    if line =~ /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/
      n,sx,sy,w,h = [$1,$2,$3,$4,$5].map(&:to_i)

      all.add(n)

      (sy...sy+h).each do |y|
        (sx...sx+w).each do |x|
          if a[y][x] == 0
            a[y][x] = n
          else
            overlaps.add(n)
            overlaps.add(a[y][x])
            a[y][x] = 'x'
          end
        end
      end

    else
      puts "bad input: #{line}"
    end
  end

  all - overlaps
end

noverlapped = noverlaps(1000, input)
p noverlapped
