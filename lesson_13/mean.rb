# frozen_string_literal: true

array = (0..1_000_000).to_a.shuffle

sum = 0
random_sample_size = 200

random_sample_size.times do
  random_index = rand(0..1_000_000)
  sum += array[random_index]
end

mean = sum / random_sample_size
puts mean
