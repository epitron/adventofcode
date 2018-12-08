require 'epitools'

if ARGV.include?("-t")
  file = "test.txt"
else
  file = "input.txt"
end

data = Path[file].read.strip.split.map(&:to_i)

def parse!(data)
  cc = data.shift
  mc = data.shift

  children = cc.times.map { parse!(data) }
  meta     = (mc > 0) ? data.shift(mc) : []

  {meta: meta, children: children}
end

def sum(t)
  t[:meta].sum + t[:children].map { |c| sum(c) }.sum
end

def wsum(t)
  if t[:children].any?
    t[:meta].map do |m|
      if c = t[:children][m-1]
        wsum(c)
      else
        0
      end
    end
  else
    t[:meta].sum
  end
end

t = parse!(data)

p sum(t)
p wsum(t).flatten.sum
