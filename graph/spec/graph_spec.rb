require_relative './spec_helper'
require_relative '../graph.rb'

describe Graph do
  it 'checks for neighbors' do
    a, b = Graph.new('a'), b = Graph.new('b')

    expect(a.neighbors).to eq([])
    expect(a.new_neighbor(b).neighbors).to eq([b])
  end

  it 'can a reach b' do
    a, b, c = Graph.new('a'), b = Graph.new('b'), Graph.new('c')

    a.new_neighbor(b)
    b.new_neighbor(c)
    #expect(a.can_reach?(b, [])).to be true
    expect(a.can_reach?(c, [])).to be true
  end


end
