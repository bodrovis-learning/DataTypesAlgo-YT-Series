# frozen_string_literal: true

require_relative 'bloom_filter'

def find_duplicates(array)
  bf = BloomFilter.new(array.length, 0.01)
  array.any? do |x|
    bf.include?(x) || (bf << x
                       false)
  end
end

data1 = [1, 2, 3, 4, 5]
data2 = %w[cat dog bird cat]
data3 = %w[a b c d e f g]

puts find_duplicates(data1)
# => false

puts find_duplicates(data2)
# => true

puts find_duplicates(data3)
# => false
