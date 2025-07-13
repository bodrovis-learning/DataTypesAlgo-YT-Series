# frozen_string_literal: true

require_relative 'node'

# Simple doubly-linked list with head/tail operations
class DoublyLinkedList
  attr_accessor :first_node, :last_node

  def initialize(first_node = nil, last_node = nil)
    @first_node = first_node
    @last_node  = last_node
  end

  # Add to tail
  def append(data)
    node = Node.new(data)

    if @first_node
      @last_node.next_node = node
      node.previous_node = @last_node
    else
      @first_node = node
    end

    @last_node = node

    node
  end

  # Add to head
  def insert_head(data)
    node = Node.new(data)

    if @first_node
      @first_node.previous_node = node
      node.next_node = @first_node
    else
      @last_node = node
    end

    @first_node = node

    node
  end

  # Remove head
  def pop_head
    return unless @first_node

    node = @first_node

    if node.next_node
      @first_node = node.next_node
      @first_node.previous_node = nil
    else
      @first_node = @last_node = nil
    end

    node
  end

  # Remove tail
  def pop_tail
    return unless @last_node

    node = @last_node

    if node.previous_node
      @last_node = node.previous_node
      @last_node.next_node = nil
    else
      @first_node = @last_node = nil
    end

    node
  end

  # Move a node to head (for LRU, etc.)
  def move_to_head(node)
    return if node.equal?(@first_node)

    # detach
    if node.next_node
      node.previous_node.next_node = node.next_node
      node.next_node.previous_node = node.previous_node
    else
      @last_node = node.previous_node
      @last_node.next_node = nil
    end

    # attach at head
    node.next_node = @first_node
    @first_node.previous_node = node
    node.previous_node = nil
    @first_node = node
  end

  # Remove by index (0-based)
  def pop_index(index)
    return pop_head if index.zero?

    node = @first_node
    index.times { node = node.next_node }

    return pop_tail if node.equal?(@last_node)

    node.previous_node.next_node = node.next_node
    node.next_node.previous_node = node.previous_node

    node
  end
end
