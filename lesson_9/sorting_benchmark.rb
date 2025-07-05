# frozen_string_literal: true

require 'benchmark'
require_relative 'sorters/quicksort'
require_relative 'sorters/mergesort'

sizes = [1_000, 5_000, 10_000]#, 50_000]
iterations = 5

data = {}

sizes.each do |n|
  data[n] = Array.new(n) { rand(n) }
end

puts 'Ruby Benchmark: Quicksort vs Mergesort'
# puts "Iterations per test: #{iterations}\n"

# sizes.each do |n|
#   array = data[n]
#   puts "Array size: #{n}"
#   Benchmark.bm(12) do |x|
#     x.report('Quicksort') do
#       iterations.times { QuickSortable.new(array).quicksort }
#     end
#     x.report('Mergesort ') do
#       iterations.times { MergeSortable.new(array).mergesort }
#     end
#     x.report('Built-in ') do
#       iterations.times { array.sort }
#     end
#   end
#   puts
# end

puts "\nSorted arrays in reverse"

sizes.each do |n|
  array = (1..n).to_a.reverse
  puts "Array size: #{n}"
  Benchmark.bm(12) do |x|
    x.report('Quicksort') do
      iterations.times { QuickSortable.new(array).quicksort }
    end
    x.report('Mergesort ') do
      iterations.times { MergeSortable.new(array).mergesort }
    end
  end
  puts
end
