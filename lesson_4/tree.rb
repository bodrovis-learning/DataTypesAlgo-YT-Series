# frozen_string_literal: true

require_relative 'node'
require_relative 'book'

class Tree
  attr_reader :root

  def initialize(root_value)
    @root = Node.new(value: root_value)
  end

  def insert(value, node = @root)
    return if value == node.value

    if value < node.value
      if node.left_child
        insert(value, node.left_child)
      else
        node.left_child = Node.new(value: value)
      end
    elsif node.right_child
      insert(value, node.right_child)
    else
      node.right_child = Node.new(value: value)
    end
  end

  def search(value, node = @root)
    return unless node

    return node if node.value == value

    return search(value, node.left_child) if value < node.value

    search(value, node.right_child)
  end

  def delete(value, node = @root)
    return unless node

    if value < node.value
      node.left_child = delete(value, node.left_child)
      node
    elsif value > node.value
      node.right_child = delete(value, node.right_child)
      node
    elsif node.left_child.nil?
      node.right_child
    else
      node.right_child = lift(node.right_child, node)
      node
    end
  end

  def iterate(node = @root, &block)
    return unless node

    iterate(node.left_child, &block)

    yield(node)

    iterate(node.right_child, &block)
  end

  private

  def lift(node, node_to_delete)
    if node.left_child
      node.left_child = lift(node.left_child, node_to_delete)
      node
    else
      node_to_delete.value = node.value
      node.right_child
    end
  end
end

# tree = Tree.new(42)

# tree.insert(30)
# tree.insert(43)
# tree.insert(100)

# puts tree.root.inspect

# puts tree.search(100).inspect

b1 = Book.new('War and Peace')
b2 = Book.new('Alice in Wonderland')
b3 = Book.new('One Hundred Years of Solitude')
b4 = Book.new('The Martian Chronicles')
b5 = Book.new('The Sea-Wolf')
b6 = Book.new('The Adventures of Tom Sawyer')

tree = Tree.new(b1)

tree.insert(b2)
tree.insert(b2)
tree.insert(b3)
tree.insert(b4)
tree.insert(b5)
tree.insert(b6)

tree.iterate do |n|
  puts n.value.inspect
  puts "\n"
end

tree.delete(b4)

puts '==='

tree.iterate do |n|
  puts n.value.inspect
  puts "\n"
end
