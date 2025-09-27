# frozen_string_literal: true

module RabinKarp
  BASE  = 26
  PRIME = 613
  A_ORD = 'a'.ord

  module_function

  def find_needle(haystack, needle)
    m = needle.length
    n = haystack.length

    return 0 if m.zero?
    return nil if m > n

    needle_hash = initial_hash(needle, m)
    window_hash = initial_hash(haystack, m)

    return 0 if window_hash == needle_hash && haystack.byteslice(0, m) == needle

    drop_place = mod_pow(BASE, m - 1, PRIME) # BASE^(m-1) % PRIME

    1.upto(n - m) do |i|
      drop_code = code_at(haystack, i - 1)
      new_code  = code_at(haystack, i - 1 + m)

      window_hash = rolling_hash(window_hash, drop_code, new_code, drop_place)

      return i if window_hash == needle_hash && haystack.byteslice(i, m) == needle
    end

    nil
  end

  def initial_hash(str, len)
    h = 0
    0.upto(len - 1) { |i| h = ((h * BASE) + code_at(str, i)) % PRIME }
    h
  end

  def rolling_hash(hash_code, drop_code, new_code, drop_place)
    (((hash_code + PRIME - ((drop_code * drop_place) % PRIME)) * BASE) + new_code) % PRIME
  end

  # 'a' => 0, ..., 'z' => 25
  def code_at(str, idx)
    str.getbyte(idx) - A_ORD
  end

  def mod_pow(base, exp, mod)
    res = 1
    b = base % mod
    e = exp
    while e.positive?
      res = (res * b) % mod if e.allbits?(1)
      b = (b * b) % mod
      e >>= 1
    end
    res
  end
end

p RabinKarp.find_needle('abracadabra', 'cad')  #=> 4
p RabinKarp.find_needle('abracadabra', 'xyz')  #=> nil
p RabinKarp.find_needle('aaaaa', 'aaa')        #=> 0
