# frozen_string_literal: true

class Node
  attr_accessor :value, :priority, :left, :right, :parent

  def initialize(value, priority: nil)
    @value    = value
    @priority = priority || rand
    @left     = nil
    @right    = nil
    @parent   = nil
  end
end
