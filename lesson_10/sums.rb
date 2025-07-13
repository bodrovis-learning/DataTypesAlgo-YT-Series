# frozen_string_literal: true

require 'benchmark'

def row_major_sum(array)
  size = array.length
  sum  = 0
  size.times do |row|
    size.times { |col| sum += array[row][col] }
  end
  sum
end

def col_major_sum(array)
  size = array.length
  sum  = 0
  size.times do |col|
    size.times { |row| sum += array[row][col] }
  end
  sum
end

N = 10_000
matrix = Array.new(N) { Array.new(N) { rand(1000) } }

raise 'sums differ!' unless row_major_sum(matrix) == col_major_sum(matrix)

Benchmark.bm(15) do |x|
  x.report('row major:') { row_major_sum(matrix) }
  x.report('col major:') { col_major_sum(matrix) }
end
