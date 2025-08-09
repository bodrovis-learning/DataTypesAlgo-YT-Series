# frozen_string_literal: true

require_relative 'node'

class Treap
  attr_accessor :root

  def initialize(root = nil)
    @root = root
  end

  # ---- rotations ----

  # rotate_counterclockwise(a, b): a is parent, b is a.right
  def rotate_counterclockwise(a, b)
    a_right_left = b.left
    a.right = a_right_left
    a_right_left.parent = a if a_right_left

    b.parent = a.parent
    if b.parent.nil?
      @root = b
    elsif b.parent.left.equal?(a)
      b.parent.left = b
    else
      b.parent.right = b
    end

    b.left = a
    a.parent = b
  end

  # rotate_clockwise(b, a): b is parent, a is b.left
  def rotate_clockwise(b, a)
    b_left_right = a.right
    b.left = b_left_right
    b_left_right.parent = b if b_left_right

    a.parent = b.parent
    if a.parent.nil?
      @root = a
    elsif a.parent.right.equal?(b)
      a.parent.right = a
    else
      a.parent.left = a
    end

    a.right = b
    b.parent = a
  end

  # ---- helpers ----

  def left_child?(node)
    node.parent && node.equal?(node.parent.left)
  end

  def right_child?(node)
    node.parent && node.equal?(node.parent.right)
  end

  # ---- core ops ----

  def insert(value, priority: nil)
    new_node = Node.new(value, priority: priority)

    if @root.nil?
      @root = new_node
      return new_node
    end

    cur = @root
    loop do
      if value < cur.value
        if cur.left.nil?
          cur.left = new_node
          new_node.parent = cur
        end
        cur = cur.left
      elsif value > cur.value
        if cur.right.nil?
          cur.right = new_node
          new_node.parent = cur
        end
        cur = cur.right
      else
        # value already exists; do nothing (treap as set)
        return cur
      end

      # stop once we actually linked it in
      break if cur.equal?(new_node)
    end

    insert_fix(new_node)
    new_node
  end

  def insert_fix(node)
    while node.parent && node.priority < node.parent.priority
      if left_child?(node)
        rotate_clockwise(node.parent, node)
      else
        rotate_counterclockwise(node.parent, node)
      end
    end
  end

  def search(value)
    cur = @root
    while cur
      if value < cur.value
        cur = cur.left
      elsif value > cur.value
        cur = cur.right
      else
        return cur
      end
    end
    nil
  end

  # returns the removed node, or nil if not found
  def delete(value)
    node = search(value)
    return nil unless node

    if node.equal?(@root) && node.left.nil? && node.right.nil?
      @root = nil
      return node
    end

    # rotate the node down until it has at most one child (here: none)
    while node.left || node.right
      if node.right.nil? || (node.left && node.left.priority < node.right.priority)
        rotate_clockwise(node, node.left)
      else
        rotate_counterclockwise(node, node.right)
      end
    end

    # detach leaf
    if left_child?(node)
      node.parent.left = nil
    else
      node.parent.right = nil
    end

    node
  end

  # collects values per depth level; returns Array<Array<value>>
  def tree_levels(node = @root, levels = [], level = 0)
    return levels if node.nil?

    levels[level] ||= []
    levels[level] << node.value
    tree_levels(node.left, levels, level + 1)
    tree_levels(node.right, levels, level + 1)
    levels
  end
end
