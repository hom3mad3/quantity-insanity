require 'pry'

# a node whi ch understands its neighbors
class Graph
  attr_reader :name
  attr_accessor :neighbors

  def initialize(name)
    @name = name
    @neighbors = []
  end

  def new_neighbor(node)
    neighbors.push(node)
    self
  end

  def can_reach?(destination, visited_nodes)
    return true if self == destination
    return false if visited_nodes.include?(self)
    visited_nodes.push(self)
    neighbors.any? {|node| node.can_reach?(destination, visited_nodes) }
  end
end

a, b, c = Graph.new('a'), b = Graph.new('b'), Graph.new('c')

a.new_neighbor(b)
b.new_neighbor(c)

a.can_reach?(c, [])
