require 'epitools'

def xform(input)
  prev = nil
  chunks = []
  runsize = 
  input.each_char do |c|
    if c != prev
      chunks << ""
    end
    chunks.last << c
    prev = c
  end

  chunks.map { |ch| "#{ch.size}#{ch[0]}" }.join
end

def xform_each_cons(s)
  result = []
  count  = 0

  (s.chars + [nil]).each_cons(2) do |a,b|
    count += 1

    if a != b
      result << "#{count}#{a}"
      count = 0
    end
  end

  result.join
end

def xform_regexp(s)
  s.
    scan(/(.)(\1*)/).
    map {|c, extra| "#{extra.size+1}#{c}" }.
    join
end

def test(input: "1113122113", method: :xform, count: 45)
  count.times do
    input = send(method, input)
  end
  input.size
end

# bench(
#   1,
#   xform: proc { test(method: :xform) },
#   xform_regexp: proc { test(method: :xform_regexp) },
#   xform_each_cons: proc { test(method: :xform_each_cons) },
# )

def normalized_counts(c)
  max = c.values.max.to_f
  "%0.3f %0.3f %0.3f" % [c["1"]/max, c["2"]/max, c["3"]/max]
end

last_s = 1
input = "1"
300.times do
  input = xform_each_cons(input)

  s      = input.size
  ratio  = s / last_s.to_f
  counts = Hash.new(0)
  input.each_char { |c| counts[c] += 1 }

  puts "#{normalized_counts counts} | #{s} | #{ratio}"
  last_s = s
end
