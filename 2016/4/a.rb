require 'epitools'

class Room < Struct.new(:ciphertext, :num, :checksum)

  def initialize(line)
    if line =~ /((?:\w+-?)+)-(\d+)\[(\w+)\]/
      super($1, $2.to_i, $3)
    else
      raise "Invalid line format: #{line.inspect}"
    end
  end

  def valid?
    checksum == ciphertext.scan(/\w/).count_by(&:itself).sort_by { |char, count| [-count, char] }.take(5).map(&:first).join
  end

  def decrypted_name
    ciphertext.each_char.map do |char|
      case char
      when "-"
        "-"
      else
        ((((char.ord - 97) + num) % 26) + 97).chr
      end
    end.join
  end

  def inspect
    "<Room #{num}: #{decrypted_name}>"
  end

end

rooms = open("input.txt").each_line.map { |line| Room.new(line) }

# pp rooms

# rooms = %{aaaaa-bbb-z-y-x-123[abxyz]
# a-b-c-d-e-f-g-h-987[abcde]
# not-a-real-room-404[oarel]
# totally-real-room-200[decoy]}.lines.map { |line| Room.new(line) }

valid_rooms = rooms.select(&:valid?)
p total: valid_rooms.map(&:num).sum

p valid_rooms.select { |r| r.decrypted_name =~ /north/ }
