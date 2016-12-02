good = 0
bad = 0

(0..100).each do |x|
  (0..100).each do |y|
    (0..100).each do |z|
      if x+y+z == 100
        good += 1
      else
        bad += 1
      end
    end
  end
end

p [good, bad]