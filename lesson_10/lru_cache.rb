# frozen_string_literal: true

require_relative 'doubly_linked_list'

# Simple LRU cache backed by a hash and a doubly‐linked list
class LruCache
  def initialize(max_size = 4)
    @store    = {}
    @list     = DoublyLinkedList.new
    @max_size = max_size
  end

  # Return node on hit (and move it to head), nil on miss
  def read(key)
    node = @store[key]
    return unless node   # cache miss

    promote(node)        # cache hit
  end

  # Insert or overwrite entry, evicting LRU if full
  def write(key, value)
    evict if @store.size >= @max_size

    node = @list.insert_head({ key: key, data: value })

    @store[key] = node
  end

  alias cache write

  private

  # Move accessed node to head of list
  def promote(node)
    @list.move_to_head(node)

    node
  end

  # Remove least‐recently‐used entry
  def evict
    node = @list.pop_tail
    return unless node # nothing to evict

    @store.delete(node.data[:key])
  end
end

# Wraps LruCache to simulate fetching prices
class PriceRequester
  def initialize
    @cache = LruCache.new
  end

  # Return cached price or fetch and cache it
  def price_for(product)
    node = @cache.read(product)
    return node.price if node # cache hit

    price = fetch_price(product)
    @cache.write(product, price)
    price # cache miss
  end

  private

  # Simulate network delay and return mock price
  def fetch_price(_product)
    sleep 0.25
    1
  end
end

requester = PriceRequester.new

products = %w[apple banana cherry date apple banana elderberry fig cherry]

products.each do |product|
  start = Time.now
  price = requester.price_for(product)
  elapsed = Time.now - start

  puts "Product: #{product.ljust(10)} | Price: #{price} | Time: #{'%.3f' % elapsed}s"
end
