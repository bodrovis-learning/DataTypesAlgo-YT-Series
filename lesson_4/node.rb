# frozen_string_literal: true

class Node
  attr_accessor :left_child, :right_child, :value

  def initialize(value:, left_child: nil, right_child: nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end
end
