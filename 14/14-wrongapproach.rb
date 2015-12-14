class Reindeer < Struct.new(:name, :speed, :endurance, :rest)

  attr_accessor :pos, :t

  def fly!(n)
    puts " - Flying #{speed}km/s for #{n} seconds..."
    @pos += n * speed
    @t += n
    show_pos
  end

  def rest!(n)
    puts " - Resting #{n} seconds..."
    @t += n
    show_pos
  end

  def show_pos
    puts " - #{pos} km"
  end


  def simulate!(s)
    @pos = 0
    @t = 0

    puts "* Running #{name} for #{s} seconds..."

    loop do
      if @t + endurance > s
        fly!(-@t + s)
        break
      else
        fly!(endurance)
      end

      if @t + rest > s
        rest!(-@t + s)
        break
      else
        rest!(rest)
      end
    end

    puts " - DONE! Distance travelled: #{pos} km"

    pos
  end

end

rs = []

open("input.txt").each_line do |line|
  if line.strip =~ %r{^(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.$}
    rs << Reindeer.new($1, $2.to_i, $3.to_i, $4.to_i)
  end
end

p rs.map { |r| [r.simulate!(2503), r] }.max


