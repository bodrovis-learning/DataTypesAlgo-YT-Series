# frozen_string_literal: true

require_relative 'bit_vector'
require_relative 'division_hasher'

class BloomFilter
  LN2 = Math.log(2.0)

  attr_reader :n, :f, :m, :k

  def initialize(n, f, rng: Random.new)
    raise ArgumentError, 'n must be positive' unless n.is_a?(Integer) && n.positive?
    raise ArgumentError, 'f must be between 0 and 1 (exclusive)' unless f.is_a?(Numeric) && f.positive? && f < 1

    @n = n
    @f = f.to_f

    # m = - (n * ln f) / (ln 2)^2
    @m = (-Math.log(@f) * @n / (LN2**2)).to_i

    # k = (m / n) * ln 2
    @k = (@m * LN2 / @n).to_i
    @k = 1 if @k < 1
    @m = 1 if @m < 1

    @bit_vector = BitVector.new(@m)

    primes_seen = {}
    @hashers = Array.new(@k) do
      hasher = DivisionHasher.new(@m, rng: rng)
      hasher = DivisionHasher.new(@m, rng: rng) while primes_seen.key?(hasher.prime)
      primes_seen[hasher.prime] = true
      hasher
    end
  end

  def insert(value)
    @hashers.each do |h|
      @bit_vector.set_bit(h.hash_for(value))
    end
    self
  end
  alias add insert
  alias << insert

  def include?(value)
    @hashers.all? { |h| @bit_vector.bit?(h.hash_for(value)) }
  end

  private

  attr_reader :bit_vector
end
