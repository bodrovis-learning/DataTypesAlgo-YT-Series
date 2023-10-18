# frozen_string_literal: true

class Stack
  def initialize(elements = [])
    @elements = elements
  end

  def read
    @elements[-1]
  end

  def push(els)
    @elements.push(*els)
  end

  def pop
    @elements.pop
  end

  def empty?
    @elements.empty?
  end
end
