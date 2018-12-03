require 'epitools'

input = Path["input.txt"].nicelines
test = %{#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2}.nicelines

def pa(a)
  a.each do |row|
    puts row.map{|cell| cell.to_s.rjust(5) }.join
  end
end

def render(size, input)
  a = size.times.map { [''] * size }

  input.each do |line|
    if line =~ /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/
      n,sx,sy,w,h = [$1,$2,$3,$4,$5].map(&:to_i)

      (sy...sy+h).each do |y|
        (sx...sx+w).each do |x|
          if a[y][x] == ''
            a[y][x] = n
          else
            a[y][x] = 'x'
          end
        end
      end
    else
      puts "bad input: #{line}"
    end
  end

  a
end

def count(fabric)
  fabric.map {|row| row.count {|e| e == "x"} }.sum
end

# fabric = render(9, test)
fabric = render(1000, input)
pa fabric
p count(fabric)