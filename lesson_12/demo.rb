# frozen_string_literal: true

require_relative 'node'
require_relative 'treap'

# ---------- helpers for pretty output ----------

def levels_with_priorities(root)
  return [] if root.nil?

  q = [[root, 0]]
  levels = []

  until q.empty?
    node, lvl = q.shift
    levels[lvl] ||= []
    levels[lvl] << "#{node.value}(p=#{format('%.3f', node.priority)})"
    q << [node.left,  lvl + 1] if node.left
    q << [node.right, lvl + 1] if node.right
  end

  levels
end

def print_treap(treap, title = nil)
  puts "\n=== #{title} ===" if title
  lvls = levels_with_priorities(treap.root)
  if lvls.empty?
    puts '(empty)'
    return
  end
  lvls.each_with_index do |arr, i|
    puts "Level #{i}:  " + arr.join('   ')
  end
end

def inorder_values(node, acc = [])
  return acc if node.nil?

  inorder_values(node.left, acc)
  acc << node.value
  inorder_values(node.right, acc)
  acc
end

def check_invariants(node)
  return true if node.nil?

  ok_bst  = (node.left.nil?  || (inorder_values(node.left).max < node.value)) &&
            (node.right.nil? || (inorder_values(node.right).min > node.value))
  ok_heap = (node.left.nil?  || node.priority <= node.left.priority) &&
            (node.right.nil? || node.priority <= node.right.priority)
  ok_bst && ok_heap && check_invariants(node.left) && check_invariants(node.right)
end

def assert_ok(treap, where)
  ok = check_invariants(treap.root)
  puts "[check @ #{where}] treap #{ok ? 'OK ✅' : 'BROKEN ❌'}"
end

# ---------- demo ----------

srand 1337 # deterministic priorities for repeatable runs

treap = Treap.new
print_treap(treap, 'Start (empty)')
assert_ok(treap, 'start')

# 1) basic inserts
values = [50, 30, 70, 20, 40, 60, 80]
values.each { |v| treap.insert(v) }
print_treap(treap, "After inserting #{values.inspect}")
puts "In-order (should be sorted): #{inorder_values(treap.root).inspect}"
assert_ok(treap, 'after first inserts')

# 2) a couple more inserts
more = [65, 35, 75, 10, 90]
more.each { |v| treap.insert(v) }
print_treap(treap, "After inserting #{more.inspect}")
puts "In-order: #{inorder_values(treap.root).inspect}"
assert_ok(treap, 'after more inserts')

# 3) searches
[40, 999].each do |x|
  found = treap.search(x)
  puts "Search #{x}: #{found ? "found (p=#{format('%.3f', found.priority)})" : 'not found'}"
end

# 4) deletions (show tree after each)
to_delete = [30, 50, 70]
to_delete.each do |x|
  removed = treap.delete(x)
  puts "\nDelete #{x}: #{removed ? "removed (p=#{format('%.3f', removed.priority)})" : 'not present'}"
  print_treap(treap, "After deleting #{x}")
  puts "In-order: #{inorder_values(treap.root).inspect}"
  assert_ok(treap, "after deleting #{x}")
end

# 5) nuke rest for fun
[inorder_values(treap.root)].flatten.each do |x|
  treap.delete(x)
end
print_treap(treap, 'After deleting everything')
assert_ok(treap, 'end')
