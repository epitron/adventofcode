class Circuit
  TRANSFORMS = {
    "LSHIFT"         => "<<",
    "RSHIFT"         => ">>",
    "NOT"            => "~",
    "AND"            => "&",
    "OR"             => "|",
    /\b(if|do|in)\b/ => "\\1_",
  }

  def add(line)
    TRANSFORMS.each do |from, to|
      line.gsub!(from, to)
    end

    expr, name = line.strip.split(" -> ")

    method = "def #{name}; (@#{name} ||= #{expr}); end"

    # puts method
    instance_eval method
  end

  def get(meth)
    clone.send(meth)
  end

  def show(input, output)
    bottom5 = output & 0b11111
    middle4 = (output & 0b111100000) >> 5
    top = output >> 9
    puts "b = #{input.to_s.ljust(7)} | %0.32b (%7d) | %6d %6d %6d" % [output, output, top, middle4, bottom5]
  end

  def test
    65535.times do |n|
      add("#{n} -> b")
      show n, get(:a)
    end
  end

  def feedback
    hist = Hash.new(0)

    input = get(:b)
    100000.times do |n|
      add("#{input} -> b")
      output = get(:a)
      # show input, output
      hist[output] += 1
      input = output
      puts "#{n}" if n % 1000 == 0
    end
    hist
  end

end

base = Circuit.new
open("advent7.txt").each_line { |line| base.add(line) }

# base.test
require 'pry'
base.feedback.pry
