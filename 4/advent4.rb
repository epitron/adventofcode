key = "yzbqklnj"

require 'digest/md5'

n = 0
loop do
  digest = Digest::MD5.hexdigest("#{key}#{n}")
  # p n => digest

  if digest[0...6] == "000000"
    p answer: n
    exit
  end
  n += 1
end