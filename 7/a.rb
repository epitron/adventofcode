require 'epitools'

tests = {
  "abba[mnop]qrst"       => true,  # supports TLS (abba outside square brackets).
  "abcd[bddb]xyyx"       => false, # does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
  "aaaa[qwer]tyui"       => false, # does not support TLS (aaaa is invalid; the interior characters must be different).
  "ioxxoj[asdfgh]zxcvbn" => true   # supports TLS (oxxo is outside square brackets, even though it's within a larger string).
}

input = open("input.txt").read.lines.map(&:strip)

class Array

  def aba?
    self[0] != self[1] and self[0] == self[2]
  end

end


class String

  def nets
    split(/(\[[^\]]+\])/).partition { |a| a[0] == "[" }
  end

  def abba?
    !!( self =~ /(\w)(?!\1)(\w)\2\1/ )
  end

  def tls?
    hypernets, supernets = nets
    supernets.any?(&:abba?) and not hypernets.any?(&:abba?)
  end

  def ssl?
    hypernets, supernets = nets
    matches = supernets.map { |net| net.each_char.each_cons(3).select(&:aba?) }.flatten(1)
    matches.any? { |a,b,_| hypernets.join =~ /#{b}#{a}#{b}/ }
  end

end

p tests.map { |str, exp| str.tls? == exp }

p TLS: input.count(&:tls?)
p SSL: input.count(&:ssl?)

# pp input.first.nets
