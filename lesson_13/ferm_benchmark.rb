# frozen_string_literal: true

require 'benchmark'
require_relative 'mod_pow'

def fermat_passes_pure(n, rounds)
  return [0, 0] if n < 2

  pass = 0
  rounds.times do
    a = 1 + rand(n - 1)
    pass += 1 if ModPow::ModPow(a, n - 1, n) == 1
  end
  [pass, 0]
end

def fermat_passes_pure_gcd_short(n, rounds)
  return [0, 0] if n < 2

  pass = 0
  gcd_hits = 0
  rounds.times do
    a = 1 + rand(n - 1)
    g = a.gcd(n)
    if g != 1
      gcd_hits += 1
      next
    end
    pass += 1 if ModPow::ModPow(a, n - 1, n) == 1
  end
  [pass, gcd_hits]
end

def fermat_passes_coprime(n, rounds)
  return [0, 0] if n < 2

  pass = 0
  rounds.times do
    a = loop do
      x = 1 + rand(n - 1)
      break x if x.gcd(n) == 1
    end
    pass += 1 if ModPow::ModPow(a, n - 1, n) == 1
  end
  [pass, 0]
end

tests = {
  561 => 'Carmichael (3·11·17)',
  1105 => 'Carmichael (5·13·17)',
  21 => 'Composite (3·7)',
  341 => 'Composite pseudoprime base 2 (11·31)',
  1_000_003 => 'Prime (~1e6)',
  6_054_985 => 'Carmichael (5·53·73·313)'
}

@rounds = 5_000

puts "Fermat benchmark — fair (rounds per N = #{@rounds})"
puts

tests.each do |n, tag|
  puts "N=#{n} (#{tag})"

  t1 = Benchmark.realtime { @p1, @g1 = fermat_passes_pure(n, @rounds) }
  t2 = Benchmark.realtime { @p2, @g2 = fermat_passes_pure_gcd_short(n, @rounds) }
  t3 = Benchmark.realtime { @p3, @g3 = fermat_passes_coprime(n, @rounds) }

  def line(label, time, pass, gcd_hits)
    rate = pass.to_f / @rounds
    extras = gcd_hits.positive? ? ", gcd_hits=#{gcd_hits}" : ''
    puts "#{label.ljust(34)}time=#{format('%.4fs',
                                          time)}, passes=#{pass}/#{@rounds} (p≈#{format('%.3f', rate)})#{extras}"
  end

  line('pure (rand A in [1..n-1]):', t1, @p1, @g1)
  line('pure+gcd_short (best):',     t2, @p2, @g2)
  line('coprime-only (gcd=1):',      t3, @p3, @g3)

  note =
    if tag.start_with?('Carmichael')
      'ожидаемо: coprime-only ≈ 100% проходов; pure+gcd_short ловит составность за счёт gcd_hits'
    elsif tag.start_with?('Prime')
      'ожидаемо: все ≈ 100% проходов; по времени pure ≲ gcd_short ≲ coprime-only'
    elsif tag.start_with?('Composite pseudoprime')
      'ожидаемо: проходят часть раундов, но gcd_short поможет, если есть общий делитель с базой'
    else
      'ожидаемо: pure+gcd_short выигрывает — много быстрых gcd_hits; coprime-only тормозит и маскирует'
    end
  puts "  note: #{note}"
  puts
end
