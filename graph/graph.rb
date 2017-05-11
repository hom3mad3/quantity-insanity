require 'pry'

# a node whi ch understands its neighbours
class Graph
  attr_reader :name
  attr_accessor :neighbours

  def initialize(name)
    @name = name
    @neighbours = []
  end

  def new_neighbour(node)
    neighbours.push(node)
    self
  end

  def can_reach?(destination, visited_nodes)
    return true if self == destination
    return false if visited_nodes.include?(self)
    visited_nodes.push(self)
    neighbours.any? {|node| node.can_reach?(destination, visited_nodes) }
  end
end

a, b, c = Graph.new('a'), b = Graph.new('b'), Graph.new('c')

a.new_neighbour(b)
b.new_neighbour(c)

a.can_reach?(c, [])
