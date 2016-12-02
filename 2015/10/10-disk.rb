require 'pathname'

def xform_file(infile, outfile)
  count     = 0
  counts    = Hash.new(0)
  last      = nil

  open(outfile, "wb") do |outp|
  
    open(infile, "rb") do |inp|
      inp.each_char do |c|
        if c != last and last
          outp.write "#{count}#{last}"
          counts[last] += count
          count = 0
        end
        last = c
        count += 1
      end
    end

    if count > 0
      outp.write "#{count}#{last}" 
      counts[last] += count
    end

  end

  counts
end

def normalized_counts(c)
  total = c.values.reduce(:+)
  c.sort.map { |k,v| Rational(v, total) }
end

last_s = 1
open("seesay-0.txt", "wb") {|f| f.write("1") }

unless (iterations = ARGV.first.to_i) > 0
  iterations = 300
end

def filename(n)
  "seesay-#{n}.txt"
end

iterations.times do |n|
  # input = xform_each_cons(input)
  infile  = filename(n)
  outfile = filename(n+1)

  if (n..n+2).all? { |i| File.exist?(filename(i)) }
    puts "Skipping #{n}..."
    next
  end

  counts  = xform_file(infile, outfile)

  s     = counts.values.reduce(:+)
  s2    = File.size(outfile)
  ratio = Rational(s, last_s)

  puts "#{n+1} | #{normalized_counts counts} | #{s} (#{s2}) | #{ratio} = #{ratio.to_f}"
  last_s = s
end
