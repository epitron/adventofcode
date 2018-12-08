#
# A quick way to compare different-case and same-letter simultaneously
#
def reacts?(a, b)
  (a.ord - b.ord).abs == 32 # ?a.ord - ?A.ord == 32
end

#
# A very fast reducer, but if any characters don't match, it skips right past them,
# which means that it won't do anything for a string like 'xxXX'.
#
def quick_reduce(seq)
  seq.gsub(/([a-z])\1/i) { |m| reacts?(*m.chars) ? "" : m }
end

#
# A character-at-a-time reducer
#
def slow_reduce(seq)
  reduced = ""
  pos = 0

  loop do
    break if pos >= seq.size

    a, b = seq[pos], seq[pos+1]

    if b and reacts?(a, b)
      pos += 2
    else
      reduced << seq[pos]
      pos += 1
    end
  end

  reduced
end

def reduced_size(seq)
  start_time = Time.now

  loop do
    # p seq.size
    prev_size = seq.size

    seq = quick_reduce(seq)

    if seq.size == prev_size # no reduction
      seq = slow_reduce(seq)
      break if seq.size == prev_size
    end
  end

  puts "resulting size: #{seq.size} (runtime: #{Time.now - start_time}s)"

  seq.size
end



seq          = File.read("input.txt").chomp
unique_chars = seq.downcase.chars.uniq

sizes = unique_chars.map do |char|
  [reduced_size(seq.gsub(/#{char}/i, "")), char]
end

pp sizes.sort.reverse
