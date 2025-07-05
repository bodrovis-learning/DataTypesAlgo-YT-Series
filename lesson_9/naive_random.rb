# frozen_string_literal: true

require 'digest'

t = Time.now
puts t
seed = Digest::SHA2.hexdigest(t.to_s).to_i(16)
puts seed
modulus = 7919
multiplier = 1_103_515_245
increment = 12_345
random_n = seed % modulus

10.times do
  random_n = ((random_n * multiplier) + increment) % modulus
  puts random_n
  puts random_n % 20
  puts '==='
end
