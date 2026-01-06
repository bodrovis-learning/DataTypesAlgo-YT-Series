# frozen_string_literal: true

require_relative 'btree'

def assert_equal(x, y)
  if x == y
    puts '.'
  else
    puts 'FAIL'
  end
end

# Search
puts 'Search'
b = BTree.new('node1.csv')
assert_equal(b.search(2)[0], true)
assert_equal(b.search(10)[0], true)
assert_equal(b.search(16)[0], true)
assert_equal(b.search(50)[0], true)
assert_equal(b.search(55)[0], true)
assert_equal(b.search(98)[0], true)
assert_equal(b.search(1)[0], false)
assert_equal(b.search(45)[0], false)
assert_equal(b.search(100)[0], false)
assert_equal(b.search(27)[0], false)

# Insert
b = BTree.new
b.insert(100)
b.insert(50)
b.insert(25)
b.insert(75)
assert_equal(b.search(25)[0], true)
assert_equal(b.search(50)[0], true)
assert_equal(b.search(75)[0], true)
assert_equal(b.search(100)[0], true)

b.insert(60)
b.insert(10)
b.insert(55)

assert_equal(b.search(25)[1], '25.csv')
assert_equal(b.search(50)[1], '25.csv')
assert_equal(b.search(75)[1], '75.csv')
assert_equal(b.search(100)[1], '75.csv')
assert_equal(b.search(60)[1], '60.csv')
assert_equal(b.search(10)[1], '25.csv')
assert_equal(b.search(55)[1], '25.csv')

b.insert(5)
assert_equal(b.search(5)[0], true)
assert_equal(b.search(10)[1], '5.csv')

b.insert(110)
b.insert(120)
b.insert(130)
assert_equal(b.search(75)[1], '75.csv')

b.insert(140)
b.insert(150)
b.insert(160)

b.insert(170)
b.insert(180)
b.insert(190)

assert_equal(b.search(110)[1], '110.csv')
assert_equal(b.search(60)[1], '25.csv')
assert_equal(b.search(170)[1], '140.csv')
assert_equal(b.search(100)[1], '75.csv')
assert_equal(b.search(130)[1], '120.csv')
assert_equal(b.search(160)[1], '150.csv')
assert_equal(b.search(190)[1], '180.csv')
