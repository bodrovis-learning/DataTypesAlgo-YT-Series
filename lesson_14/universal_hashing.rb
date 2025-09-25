# frozen_string_literal: true

require 'securerandom'

class UniversalHash
  # p должен быть простым и > диапазона X; берём 2^61-1 (Mersenne)
  P = (1 << 61) - 1

  def initialize(m)
    @m = m.to_i
    raise 'm must be >= 1' if @m < 1

    # a в диапазоне [1, p-1], b в [0, p-1]
    @a = SecureRandom.random_number(P - 1) + 1
    @b = SecureRandom.random_number(P)
  end

  # Основная функция: возвращает индекс корзины в [0...m-1]
  def bucket(key)
    x = key_to_int(key)
    (((@a * x) + @b) % P) % @m
  end

  def params
    { a: @a, b: @b, p: P, m: @m }
  end

  private

  # Превращаем ключ в целое число X (в пределах P) — простая и быстрая свёртка по байтам
  def key_to_int(key)
    case key
    when Integer
      key % P
    when String
      h = 0
      key.bytes.each do |b|
        # умножение по базе 256, берём мод P на каждом шаге, чтобы не раздувать число
        h = ((h * 256) + b) % P
      end
      h
    else
      # для произвольных объектов — воспользуемся их строковым представлением
      key_to_int(key.to_s)
    end
  end
end

# ---- Демонстрация ----
uh = UniversalHash.new(16) # таблица с 16 корзинами
puts "params: #{uh.params}"

keys = %w[apple banana cherry date eggplant fig grape honeydew kiwi lemon mango nectarine orange peach]
mapping = Hash.new { |h, k| h[k] = [] }

keys.each do |k|
  b = uh.bucket(k)
  mapping[b] << k
end

puts "\nBuckets (index => keys):"
mapping.keys.sort.each do |idx|
  puts "#{idx.to_s.rjust(2)} => #{mapping[idx].join(', ')}"
end
