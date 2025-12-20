# frozen_string_literal: true

class BitVector
  WORD_BITS = 32
  WORD_MASK = (1 << WORD_BITS) - 1

  def initialize(bit_count)
    raise ArgumentError, 'bit_count must be non-negative' if bit_count.negative?

    @bit_count = bit_count
    words = (bit_count + WORD_BITS - 1) / WORD_BITS
    @words = Array.new(words, 0)
  end

  attr_reader :bit_count

  def read_bit(index)
    check_index!(index)
    word_i, bit_i = index.divmod(WORD_BITS)
    (@words[word_i] >> bit_i).allbits?(1)
  end
  alias bit? read_bit

  def set_bit(index)
    check_index!(index)
    word_i, bit_i = index.divmod(WORD_BITS)
    @words[word_i] |= (1 << bit_i)
    @words[word_i] &= WORD_MASK
    self
  end

  def clear_bit(index)
    check_index!(index)
    word_i, bit_i = index.divmod(WORD_BITS)
    @words[word_i] &= ~(1 << bit_i)
    @words[word_i] &= WORD_MASK
    self
  end

  def toggle_bit(index)
    check_index!(index)
    word_i, bit_i = index.divmod(WORD_BITS)
    @words[word_i] ^= (1 << bit_i)
    @words[word_i] &= WORD_MASK
    self
  end

  def values
    result = []
    offset = 0

    @words.each do |w|
      word = w
      WORD_BITS.times do |i|
        result << (offset + i) if word.allbits?(1)
        word >>= 1
      end
      offset += WORD_BITS
    end

    result.select { |i| i < @bit_count }
  end

  private

  def check_index!(index)
    raise TypeError, "index must be an Integer, got #{index.class}" unless index.is_a?(Integer)
    return unless index.negative? || index >= @bit_count

    raise IndexError, "index #{index} out of range (0...#{@bit_count})"
  end
end
