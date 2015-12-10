m = Array.new(1000) { |a| Array.new(1000, 0) }

transformations = {
  "toggle"   => proc { |input| input+2 },
  "turn on"  => proc { |input| input+1 },
  "turn off" => proc { |input| [0, input-1].max },
}

open("advent6.txt") do |f|
  f.each_line do |line|
    if line =~ /(toggle|turn on|turn off) (\d+),(\d+) through (\d+),(\d+)/
      command = $1
      x1, y1, x2, y2 = [$2, $3, $4, $5].map(&:to_i)
      transform = transformations[command]

      puts line

      (y1..y2).each { |y| (x1..x2).each { |x| m[y][x] = transform[m[y][x]] } }
    end
  end
end

require 'chunky_png'
puts "Converting..."
lights = m.flatten
pixels = lights.map { |e| (e << 24) | (e << 16) | (e << 8) | 255 }
puts "Writing..."
ChunkyPNG::Image.new(1000,1000,pixels).save("advent6.png")
puts "Done!"

p lights.reduce(:+)
