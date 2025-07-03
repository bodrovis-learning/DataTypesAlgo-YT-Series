# frozen_string_literal: true

class Heap
  attr_reader :data

  def initialize(root = nil)
    @data = []

    @data.push(root) if root
  end

  def root
    @data[0]
  end

  def last
    @data[-1]
  end

  def insert(value)
    @data.push(value)

    trickle_up
  end

  def delete
    @data[0] = @data.pop

    trickle_down
  end

  private

  def trickle_up(current_index = @data.length - 1)
    p_index = parent_index(current_index)

    return unless current_index.positive? && @data[current_index] > @data[p_index]

    swap(p_index, current_index)

    trickle_up(p_index)
  end

  def trickle_down(current_index = 0)
    indexes = {
      c_index: current_index,
      lc_index: left_child_index(current_index),
      rc_index: right_child_index(current_index)
    }

    return unless greater_child?(indexes)

    child_index = larger_child_index(indexes)

    swap(current_index, child_index)

    trickle_down(child_index)
  end

  def larger_child_index(indexes)
    indexes => { lc_index:, rc_index: }

    return lc_index if !in_bounds?(rc_index) || @data[rc_index] < @data[lc_index]

    rc_index
  end

  def greater_child?(indexes)
    indexes => { lc_index:, rc_index:, c_index: }

    (in_bounds?(lc_index) && @data[lc_index] > @data[c_index]) ||
      (in_bounds?(rc_index) && @data[rc_index] > @data[c_index])
  end

  def in_bounds?(index)
    index >= 0 && index < @data.length
  end

  def swap(index1, index2)
    @data[index1], @data[index2] = @data[index2], @data[index1]
  end

  def parent_index(index)
    (index - 1) / 2
  end

  def left_child_index(index)
    (index * 2) + 1
  end

  def right_child_index(index)
    (index * 2) + 2
  end
end

heap = Heap.new(42)

heap.insert(21)
heap.insert(22)
heap.insert(100)
heap.insert(4)
heap.insert(41)
heap.insert(105)
puts heap.data.inspect

heap.delete

puts heap.data.inspect

heap.delete

puts heap.data.inspect
