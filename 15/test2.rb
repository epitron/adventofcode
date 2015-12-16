good = 0
bad = 0

(0..100).each do |x|
  (0..100).each do |y|
    z = 100 - x - y
    if z >= 0
      good += 1
    else
      bad += 1
    end
  end
end

p [good, bad]