words = open("advent5.txt").each_line.map(&:strip)

doubles = /([a-z]{2}).*\1/
repeat = /([a-z])[a-z]\1/

nice = words.select { |s| s =~ doubles and s =~ repeat }
p nice.size
