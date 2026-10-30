# frozen_string_literal: true

# Educational B+ tree storing unique integers.
# All values live in leaves; internal nodes only guide the search.
class BPlusTree
  class Node
    attr_accessor :keys, :children, :next_leaf

    def initialize(leaf:)
      @leaf = leaf
      @keys = []
      @children = []
      @next_leaf = nil
    end

    def leaf?
      @leaf
    end
  end

  def initialize(max_keys: 3)
    raise ArgumentError, 'max_keys must be at least 2' unless max_keys.is_a?(Integer) && max_keys >= 2

    @max_keys = max_keys
    @root = Node.new(leaf: true)
  end

  # Returns true if inserted, false if the value was already present.
  def insert(value)
    raise ArgumentError, 'value must be an Integer' unless value.is_a?(Integer)

    result = insert_into(@root, value)
    return false if result == :duplicate

    if result
      separator, right_node = result
      new_root = Node.new(leaf: false)
      new_root.keys << separator
      new_root.children = [@root, right_node]
      @root = new_root
    end

    true
  end

  def include?(value)
    leaf = find_leaf(value)
    index = leaf.keys.bsearch_index { |key| key >= value }
    !index.nil? && leaf.keys[index] == value
  end

  # Reads through linked leaves without repeatedly traversing the root.
  def range(from, to)
    return [] if from > to

    found = []
    leaf = find_leaf(from)

    while leaf
      leaf.each_key do |value|
        next if value < from
        return found if value > to

        found << value
      end
      leaf = leaf.next_leaf
    end

    found
  end

  def values
    leaf = @root
    leaf = leaf.children.first until leaf.leaf?

    found = []
    while leaf
      found.concat(leaf.keys)
      leaf = leaf.next_leaf
    end
    found
  end

  def print_levels
    level = [@root]
    until level.empty?
      puts level.map { |node| "[#{node.keys.join(', ')}]" }.join('  ')
      level = level.reject(&:leaf?).flat_map(&:children)
    end
  end

  def print_leaf_chain
    leaf = @root
    leaf = leaf.children.first until leaf.leaf?

    parts = []
    while leaf
      parts << "[#{leaf.keys.join(', ')}]"
      leaf = leaf.next_leaf
    end
    puts parts.join(' -> ')
  end

  private

  def find_leaf(value)
    node = @root
    until node.leaf?
      # Equality with a separator goes to the RIGHT child.
      index = node.keys.bsearch_index { |separator| value < separator } || node.keys.length
      node = node.children[index]
    end
    node
  end

  def insert_into(node, value)
    if node.leaf?
      index = node.keys.bsearch_index { |key| key >= value } || node.keys.length
      return :duplicate if node.keys[index] == value

      node.keys.insert(index, value)
      return nil if node.keys.length <= @max_keys

      # Split a leaf: COPY the smallest key of the right half upward.
      right = Node.new(leaf: true)
      right.keys = node.keys.slice!((node.keys.length / 2)..)
      right.next_leaf = node.next_leaf
      node.next_leaf = right
      return [right.keys.first, right]
    end

    index = node.keys.bsearch_index { |separator| value < separator } || node.keys.length
    result = insert_into(node.children[index], value)
    return result if result.nil? || result == :duplicate

    separator, right_child = result
    node.keys.insert(index, separator)
    node.children.insert(index + 1, right_child)
    return nil if node.keys.length <= @max_keys

    # Split an internal node: MOVE the middle separator upward.
    middle = node.keys.length / 2
    promoted = node.keys[middle]
    right = Node.new(leaf: false)
    right.keys = node.keys.slice!((middle + 1)..)
    node.keys.pop # remove the promoted separator from the left node
    right.children = node.children.slice!((middle + 1)..)
    [promoted, right]
  end
end

if $PROGRAM_NAME == __FILE__
  tree = BPlusTree.new(max_keys: 3)
  [5, 10, 15, 20, 25, 30, 35, 40, 45, 50].each do |value|
    tree.insert(value)
  end

  puts 'B+ tree (levels):'
  tree.print_levels

  puts "\nLinked leaves:"
  tree.print_leaf_chain

  puts "\nSearch 25: #{tree.include?(25)}"
  puts "Search 22: #{tree.include?(22)}"
  puts "Range 20..45: #{tree.range(20, 45).inspect}"
  puts "Insert duplicate 25: #{tree.insert(25)}"
end
