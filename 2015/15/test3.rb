good = 0
bad = 0

(0..100).each do |x|
  (0..100).each do |y|
    (0..100).each do |z|
      w = 100 - x - y - z
      if w >= 0
        good += 1
      else
        bad += 1
      end
    end
  end
end

p [good, bad]