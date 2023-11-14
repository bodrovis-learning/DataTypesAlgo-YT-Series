# frozen_string_literal: true

class Queue
  def initialize(elements = [])
    @elements = elements
  end

  def read
    @elements[0]
  end

  def enqueue(els)
    @elements.push(*els)
  end

  def dequeue
    @elements.shift
  end

  def empty?
    @elements.empty?
  end
end
