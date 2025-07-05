# frozen_string_literal: true

queues = Array.new(10) { [] }

1000.times do |job|
  q = queues[rand(0..9)]
  q << job
end

queues.each do |q|
  puts q.length
end
