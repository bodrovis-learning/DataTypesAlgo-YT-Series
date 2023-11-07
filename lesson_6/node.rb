# frozen_string_literal: true

class Node
  attr_accessor :children

  def initialize
    @children = {}
  end
end
