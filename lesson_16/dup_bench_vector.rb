# frozen_string_literal: true

require_relative 'bit_vector'
require 'benchmark'
require 'objspace'

def has_duplicates?(array, range)
  set = BitVector.new(range)
  array.each do |item|
    return true if set.read_bit(item)

    set.set_bit(item)
  end

  puts "Memsize of integers array: #{ObjectSpace.memsize_of(set.integers)} bytes"

  false
end

size = 1_000_000
runs = 5

arr_with_dups = (0...size).to_a
arr_with_dups[size / 2] = arr_with_dups[0]

arr_no_dups = (0...size).to_a

puts "Array size: #{size}"
puts "Runs: #{runs}"
puts

Benchmark.bm(15) do |x|
  runs.times do |i|
    x.report("with_dups run #{i + 1}") { has_duplicates?(arr_with_dups, size) }
  end

  puts

  runs.times do |i|
    x.report("no_dups   run #{i + 1}") { has_duplicates?(arr_no_dups, size) }
  end
end
