# frozen_string_literal: true

require_relative 'stack'

class Bracketer
  BRACKET_PAIRS = {
    40 => 41, # 40 (  41 )
    91 => 93,
    123 => 125
  }.freeze

  def check(text)
    @stack = Stack.new

    text.each_char.with_index do |current_char, i|
      code = current_char.ord

      case char_type(code)
      in :open
        @stack.push(current_char)
      in :close
        previous_char = @stack.pop

        return "No opening bracket for #{current_char} at #{i}" unless previous_char

        return "Unmatched opening bracket for #{current_char} at #{i}" if no_match_for?(previous_char.ord, code)
      else
        next
      end
    end

    if @stack.empty?
      'No issues found!'
    else
      "#{@stack.read} has no closing bracket!"
    end
  end

  private

  def char_type(code)
    if opening?(code)
      :open
    elsif closing?(code)
      :close
    else
      :unknown
    end
  end

  def opening?(code)
    BRACKET_PAIRS.keys.include?(code)
  end

  def closing?(code)
    BRACKET_PAIRS.values.include?(code)
  end

  def no_match_for?(opening, closing)
    closing != BRACKET_PAIRS[opening]
  end
end

bracketer = Bracketer.new
puts bracketer.check('Demo. (internal {demo2} [invalid])')
