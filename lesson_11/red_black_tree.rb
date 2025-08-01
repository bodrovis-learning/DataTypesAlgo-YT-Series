# frozen_string_literal: true

require_relative 'node'

class RedBlackTree
  attr_accessor :root

  def initialize(root = nil)
    @root = root
  end

  # Rotate left around x
  def rotate_left(x)
    y = x.right
    x.right = y.left
    x.right&.parent = x
    transplant(x, y)
    y.left = x
    x.parent = y
  end

  # Rotate right around x
  def rotate_right(x)
    y = x.left
    x.left = y.right
    x.left&.parent = x
    transplant(x, y)
    y.right = x
    x.parent = y
  end

  # Insert a new value, then fix coloring/structure
  def insert(value)
    new_node = Node.new(value, :red)
    return @root = new_node if root.nil?

    parent = nil
    current = root
    until current.nil?
      parent = current
      current = value < current.value ? current.left : current.right
      return if current&.value == value # no duplicates
    end

    if value < parent.value
      parent.left = new_node
    else
      parent.right = new_node
    end
    new_node.parent = parent

    fix_insert(new_node)
  end

  # Search for a node by value
  def search(value)
    current = root
    current = value < current.value ? current.left : current.right until current.nil? || current.value == value
    current
  end

  # Delete a node by value, returning the removed node or nil
  def delete(value)
    node = search(value)
    return nil unless node

    # If two children, swap values with successor, then delete successor
    if node.left && node.right
      succ = successor(node)
      node.value, succ.value = succ.value, node.value
      node = succ
    end

    # One or zero children
    child = node.left || node.right
    phantom = false
    if child.nil?
      child = Node.new(nil, :black)
      child.parent = node.parent
      phantom = true
    end

    if node.parent.nil?
      @root = child
    elsif node == node.parent.left
      node.parent.left = child
    else
      node.parent.right = child
    end
    child.parent = node.parent

    fix_delete(child) if node.black?

    # Remove phantom placeholder
    if phantom && child.parent
      if child == child.parent.left
        child.parent.left = nil
      else
        child.parent.right = nil
      end
    end

    node
  end

  # Preorder print of the tree
  def print_tree(node = root)
    return unless node

    puts "#{node.value} (#{node.color})"
    print_tree(node.left)
    print_tree(node.right)
  end

  private

  # Replace subtree u with v
  def transplant(u, v)
    if u.parent.nil?
      @root = v
    elsif u == u.parent.left
      u.parent.left = v
    else
      u.parent.right = v
    end
    v.parent = u.parent unless v.nil?
  end

  # Restore red-black properties after insertion
  def fix_insert(node)
    while node.parent&.red?
      gp = node.parent.parent
      break unless gp

      if node.parent == gp.left
        uncle = gp.right
        if uncle&.red?
          node.parent.flip_color
          uncle.flip_color
          gp.flip_color
          node = gp
          next
        end
        if node == node.parent.right
          node = node.parent
          rotate_left(node)
        end
        node.parent.flip_color
        gp.flip_color
        rotate_right(gp)
      else
        uncle = gp.left
        if uncle&.red?
          node.parent.flip_color
          uncle.flip_color
          gp.flip_color
          node = gp
          next
        end
        if node == node.parent.left
          node = node.parent
          rotate_right(node)
        end
        node.parent.flip_color
        gp.flip_color
        rotate_left(gp)
      end
    end
    root.color = :black
  end

  # Restore red-black properties after deletion
  def fix_delete(x)
    until x == root || x&.black?
      if x == x.parent.left
        w = x.parent.right
        if w&.red?
          w.flip_color
          x.parent.flip_color
          rotate_left(x.parent)
          w = x.parent.right
        end
        if (w.left&.black? || w.left.nil?) && (w.right&.black? || w.right.nil?)
          w.color = :red
          x = x.parent
          next
        end
        if w.right&.black?
          w.left.color = :black
          w.color = :red
          rotate_right(w)
          w = x.parent.right
        end
        w.color = x.parent.color
        x.parent.color = :black
        w.right.color = :black
        rotate_left(x.parent)
      else
        w = x.parent.left
        if w&.red?
          w.flip_color
          x.parent.flip_color
          rotate_right(x.parent)
          w = x.parent.left
        end
        if (w.left&.black? || w.left.nil?) && (w.right&.black? || w.right.nil?)
          w.color = :red
          x = x.parent
          next
        end
        if w.left&.black?
          w.right.color = :black
          w.color = :red
          rotate_left(w)
          w = x.parent.left
        end
        w.color = x.parent.color
        x.parent.color = :black
        w.left.color = :black
        rotate_right(x.parent)
      end
      x = root
    end
    x.color = :black if x
  end

  # In-order successor
  def successor(node)
    s = node.right
    s = s.left while s.left
    s
  end
end
