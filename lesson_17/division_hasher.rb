# frozen_string_literal: true

class DivisionHasher
  PRIME_MIN = 1000
  PRIME_MAX = 10_000
  FERMAT_ROUNDS = 100
  STRING_BASE = 53

  attr_reader :array_length, :prime

  def initialize(array_length, rng: Random.new)
    raise ArgumentError, 'array_length must be positive' unless array_length.is_a?(Integer) && array_length.positive?

    @array_length = array_length
    @rng = rng
    @prime = random_prime(PRIME_MIN, PRIME_MAX)
  end

  # Hashes an Integer or String into [0, array_length)
  # NOTE: named hash_for to avoid colliding with Ruby's Object#hash convention
  def hash_for(key)
    numeric =
      case key
      when String
        key.each_byte.reduce(1) { |acc, byte| (acc * STRING_BASE) + byte }
      when Integer
        key
      else
        raise TypeError, "key must be a String or Integer, got #{key.class}"
      end

    ((numeric % @prime) % @array_length)
  end

  # Fermat primality test (probabilistic)
  def prime?(n)
    return false if n < 2
    return true  if n == 2
    return false if n.nobits?(1)

    FERMAT_ROUNDS.times do
      a = @rng.rand(1...n) # 1 <= a < n
      return false unless mod_pow(a, n - 1, n) == 1
    end

    true
  end

  private

  def random_prime(min, max)
    loop do
      p = @rng.rand(min..max)
      return p if prime?(p)
    end
  end

  def mod_pow(base, exp, mod)
    # Ruby 2.5+ usually supports Integer#pow with modulo on newer versions.
    if base.respond_to?(:pow)
      base.pow(exp, mod)
    else
      # Fallback: fast modular exponentiation
      result = 1
      b = base % mod
      e = exp

      while e.positive?
        result = (result * b) % mod if e.allbits?(1)
        b = (b * b) % mod
        e >>= 1
      end

      result
    end
  end
end
