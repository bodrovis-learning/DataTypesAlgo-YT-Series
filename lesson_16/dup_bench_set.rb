# frozen_string_literal: true

require 'benchmark'
require 'objspace'

def has_duplicates?(array)
  seen = {}
  array.each do |item|
    return true if seen[item]

    seen[item] = true
  end

  hash_size = ObjectSpace.memsize_of(seen)
  puts "Hash memsize: #{hash_size} bytes"

  false
end

size = 1_000_000
runs = 5

arr_with_dups = (0...size).to_a
arr_with_dups[size / 2] = arr_with_dups[0] # force one duplicate

arr_no_dups = (0...size).to_a

puts "Array size: #{size}"
puts "Runs: #{runs}"
puts

Benchmark.bm(15) do |x|
  runs.times do |i|
    x.report("with_dups run #{i + 1}") { has_duplicates?(arr_with_dups) }
  end

  puts

  runs.times do |i|
    x.report("no_dups   run #{i + 1}") { has_duplicates?(arr_no_dups) }
  end
end
