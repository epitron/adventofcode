require 'epitools'

def stretch(str)
  2017.times { str = str.md5 }
  str
end

salt   = "ahsbgdzn"
# salt   = "abc"
keys   = []
window = (0..1000).map {|n| stretch("#{salt}#{n}") }

index = 0
while keys.size < 64
  key = window.shift

  if key =~ /(.)\1\1/
    char = $1
    if window.any? { |hash| hash =~ /#{char}{5}/ }
      result = [index, key]
      p found: result
      keys << result
    end
  end

  index += 1
  window << stretch("#{salt}#{index+1000}")
end
