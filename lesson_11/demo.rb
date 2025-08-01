# frozen_string_literal: true

require_relative 'node'
require_relative 'red_black_tree'

# Simple assertion helper for testing
# Prints '.' on success or a descriptive FAIL message

def assert_equal(actual, expected)
  if actual == expected
    print '.'
  else
    puts "\nFAIL: got #{actual.inspect}, expected #{expected.inspect}"
  end
end

# ------------------------------------------------------------
# Rotate Left demo: single rotation around root
# Setup:   5             10
#             \   ->    /
#             10       5

puts "\nRotate Left"
a = Node.new(5, :black)
b = Node.new(10, :red)
a.right = b
b.parent = a

tree = RedBlackTree.new(a)
tree.rotate_left(a)

# After rotation, b should be new root, a its left child
assert_equal(tree.root, b)
assert_equal(b.left, a)
assert_equal(a.parent, b)

# ------------------------------------------------------------
# Rotate Right demo: mirror of above
# Setup:   10           5
#           /   ->      \
#          5            10

puts "\nRotate Right"
b = Node.new(10, :black)
a = Node.new(5, :red)
b.left = a
a.parent = b

tree = RedBlackTree.new(b)
tree.rotate_right(b)

assert_equal(tree.root, a)
assert_equal(a.right, b)
assert_equal(b.parent, a)

# ------------------------------------------------------------
# Insert demo: basic insert without requiring fixes
# Inserts [10, 5, 15, 8]
tree = RedBlackTree.new
puts "\nInsert with fixup [10, 5, 15, 8]"
[10, 5, 15, 8].each { |v| tree.insert(v) }

# Tree should be balanced with 10 at root, children 5 and 15
assert_equal(tree.root.value, 10)
assert_equal(tree.root.left.value, 5)
assert_equal(tree.root.right.value, 15)
# 8 should be right child of 5
assert_equal(tree.root.left.right.value, 8)

# Print structure for visual learners
puts 'Tree structure after inserts:'
tree.print_tree

# ------------------------------------------------------------
# Insert causing fix-up: red-red violation
# We deliberately insert in order [20, 10, 30, 5, 1]
# This triggers recoloring and rotations
tree = RedBlackTree.new
puts "\nInsert sequence [20,10,30,5,1] to demonstrate fix_insert"
[20, 10, 30, 5, 1].each { |v| tree.insert(v) }
puts 'Tree after fix-ups:'
tree.print_tree
puts '  (root must be black and no two reds in a row)'

# ------------------------------------------------------------
# Search demo: finding existing and non-existing values
puts "\nSearch"
assert_equal(tree.search(5)&.value, 5)
assert_equal(tree.search(999), nil)

# ------------------------------------------------------------
# Delete demo: leaf, node with one child, and two children
puts "\nDelete scenarios"
tree = RedBlackTree.new
[50, 30, 70, 20, 40, 60, 80].each { |v| tree.insert(v) }
puts 'Original full tree:'
tree.print_tree

# 1) Delete a leaf (20)
deleted = tree.delete(20)
puts "\nDeleted leaf node with value 20: #{deleted.value}"
assert_equal(tree.search(20), nil)

# 2) Delete node with one child (30 has child 40)
deleted = tree.delete(30)
puts "\nDeleted node 30 (one child): #{deleted.value}"
assert_equal(tree.search(30), nil)

# 3) Delete node with two children (50 has left & right)
deleted = tree.delete(50)
puts "\nDeleted root node (two children): #{deleted.value}"
assert_equal(tree.search(50), nil)

puts "\nFinal tree after deletions:"
tree.print_tree

puts "\nDemo complete!"
