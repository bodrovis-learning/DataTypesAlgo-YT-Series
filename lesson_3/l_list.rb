# frozen_string_literal: true

require_relative 'node'

class LinkedList
  attr_reader :head

  def initialize(head_el)
    @head = Node.new(head_el)
  end

  def insert(value, index = 0)
    new_node = Node.new(value)

    if index.zero?
      new_node.next_node = @head

      @head = new_node
    else
      current_node = find(index - 1)

      new_node.next_node = current_node.next_node
      current_node.next_node = new_node
    end

    index
  end

  def delete(index = 0)
    if index.zero?
      @head = @head.next_node
    else
      previous_node = find(index - 1)

      next_node = previous_node.next_node.next_node

      previous_node.next_node = next_node
    end

    index
  end

  def index_of(value)
    iterate do |current_node, current_index|
      return current_index if current_node.data == value
    end
  end

  def read(index = 0)
    find(index)&.data
  end

  def each
    iterate { |el| yield(el.data) }
  end

  private

  def iterate
    return unless block_given?

    current_node = @head

    loop.with_index do |_, i|
      raise StopIteration unless current_node

      yield(current_node, i)

      current_node = current_node.next_node
    end
  end

  def find(index)
    iterate do |current_node, current_index|
      return current_node if current_index == index
    end
  end
end

list = LinkedList.new('first')
list.insert('second')
list.insert('third')
# first
# second --> first
# third --> second --> first
# 0           1           2
puts list.read(2).inspect

puts list.index_of('sdf').inspect
puts list.index_of('first').inspect

list.each do |el|
  puts el.inspect
end

puts '===='

list.delete(1)

list.each do |el|
  puts el.inspect
end