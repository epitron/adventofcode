require 'tsort'
require 'epitools'

input = %{pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (82) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
}


input = File.read("input7.txt")

class Node < Struct.new(:name, :weight, :child_names, :children)
  def self.parse(input)
    input.each_line.map do |l|
      a,b = l.chomp.split(" -> ")

      if a =~ /^(\w+) \((\d+)\)$/
        name, weight = $1, $2.to_i
      else
        raise "wat"
      end

      child_names = b&.split(", ") || []

      [name, Node.new(name, weight, child_names, [])]
    end.to_h
  end

  def self.build_tree(input)
    nodes = parse(input)

    nodes.each do |name, node|
      node.child_names.each do |child_name|
        node.children << nodes[child_name]
      end
    end

    nodes
  end

  def self.tsort(input)
    input.each_line.map do |l|
      a,b = l.chomp.split(" -> ")

      if a =~ /^(\w+) \((\d+)\)$/
        name, weight = $1, $2.to_i
      else
        raise "wat"
      end

      child_names = b&.split(", ") || []


    end.to_h
  end

  def inspect
    "<#{name} (#{weight})#{children.any? ? " -> " + children.join(", ") : ""}>"
  end
end

class G
  include TSort

  def parse(input)
    input.each_line.map do |l|
      a,b = l.chomp.split(" -> ")

      if a =~ /^(\w+) \((\d+)\)$/
        name, weight = $1, $2.to_i
      else
        raise "wat"
      end

      child_names = b&.split(", ") || []

      [name, child_names]
    end.to_h
  end

  def initialize(input)
    @g = parse(input)
  end
  def tsort_each_child(n, &b) @g[n].each(&b) end
  def tsort_each_node(&b) @g.each_key(&b) end
end



p g = G.new(input)
p g.tsort
