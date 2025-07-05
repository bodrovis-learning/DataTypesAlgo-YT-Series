# frozen_string_literal: true

queues = Array.new(10) { [] }

1000.times do |job|
  queue_1 = queues[rand(0..9)]
  queue_2 = queues[rand(0..9)]

  if queue_1.length < queue_2.length
    queue_1 << job
  else
    queue_2 << job
  end
end

queues.each do |queue|
  puts queue.length
end
