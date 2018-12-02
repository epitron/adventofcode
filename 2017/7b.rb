require 'epitools'

input = %{pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
}

input = File.read("input7.txt")

class Array
  def all_equal?
    each_cons(2).all? {|a,b| a == b }
  end

end

class Node

  attr_accessor :children, :weight, :name

  def initialize(name)
    @name     = name
    @children = []
  end

  def total_weight
    @total_weight ||= children.map(&:total_weight).sum + @weight
  end

  def total_children
    children.size + children.map(&:total_children).sum
  end

  def child_weights
    @child_weights ||= children.map(&:total_weight)
  end

  def to_s
     s = "#{name} (#{total_weight})"
     s += " -> #{children.map(&:name).join(", ")}" if children.any?
     s
   end

   def inspect
     "[#{total_weight}] <##{name}(#{weight}) c=#{children.size}>"
   end

end


class Tree

  def initialize
    @lut = {}
  end

  def find_or_create(name)
    @lut[name] ||= Node.new(name)
  end

  def build(input)
    input.each_line do |l|
      # fwft (82) -> ktlj, cntj, xhth
      a,b = l.chomp.split(" -> ")

      if a =~ /^(\w+) \((\d+)\)$/
        name, weight = $1, $2.to_i
      else
        raise "wat"
      end

      child_names = b&.split(", ") || []

      node          = find_or_create(name)
      node.weight   = weight
      node.children = child_names.map { |child_name| find_or_create(child_name) }
    end
  end

  def root
    @root ||= @lut.map { |name, node| [node.total_children, node] }.sort_by(&:first).last.last
  end

  def find_anomaly(node)
    unless node.child_weights.all_equal?
      grouped = node.children.group_by(&:total_weight).sort_by { |k,v| v.size }
      weirdo = grouped.first.last.first

      puts "#{node.name}: found an anomaly in #{weirdo.name} (#{grouped.map {|k,v| "#{k} (#{v.size})" }.join(" | ")})"
      node.children.each do |child|
        puts "  #{child}"
      end
      puts

      if weirdo.children.any?
        find_anomaly(weirdo)
      end
    end
  end

  def print(node=nil, depth=0)
    node ||= root
    dent = "  " * depth
    puts "#{dent}#{node.inspect}"
    node.children.each { |c| print(c, depth+1) }
    nil
  end

end


t = Tree.new
t.build(input)
t.find_anomaly(t.root)

t.pry