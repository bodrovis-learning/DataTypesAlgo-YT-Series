# frozen_string_literal: true

class BitVector
  WORD_BITS = 32

  attr_reader :range_of_bits, :integers

  def initialize(range_of_bits)
    @range_of_bits = Integer(range_of_bits)
    integers_length = @range_of_bits / WORD_BITS
    integers_length += 1 if (@range_of_bits % WORD_BITS) != 0
    @integers = Array.new(integers_length, 0)
  end

  def read_bit(index)
    i, b = split_index(index)
    mask = 1 << b
    @integers[i].anybits?(mask)
  end

  def set_bit(index)
    i, b = split_index(index)
    @integers[i] |= (1 << b)
    self
  end

  def clear_bit(index)
    i, b = split_index(index)
    @integers[i] &= ~(1 << b)
    self
  end

  def toggle_bit(index)
    i, b = split_index(index)
    @integers[i] ^= (1 << b)
    self
  end

  def values
    out = []
    (0...@range_of_bits).each do |number|
      out << number if read_bit(number)
    end
    out
  end

  def union(other_bit_vector)
    check_compat!(other_bit_vector)
    bv = BitVector.new(@range_of_bits)
    @integers.each_index do |i|
      bv.integers[i] = @integers[i] | other_bit_vector.integers[i]
    end
    bv
  end

  def intersection(other_bit_vector)
    check_compat!(other_bit_vector)
    bv = BitVector.new(@range_of_bits)
    @integers.each_index do |i|
      bv.integers[i] = @integers[i] & other_bit_vector.integers[i]
    end
    bv
  end

  def difference(other_bit_vector)
    check_compat!(other_bit_vector)
    bv = BitVector.new(@range_of_bits)
    @integers.each_index do |i|
      bv.integers[i] = @integers[i] & ~other_bit_vector.integers[i]
    end
    bv
  end

  private

  def split_index(index)
    idx = Integer(index)
    raise IndexError, 'bit index out of range' if idx.negative? || idx >= @range_of_bits

    [idx / WORD_BITS, idx % WORD_BITS]
  end

  def check_compat!(other)
    return if other.is_a?(BitVector) && other.range_of_bits == @range_of_bits

    raise ArgumentError, 'bit vectors must have the same range'
  end
end
