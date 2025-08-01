# frozen_string_literal: true

class Node
  attr_accessor :value, :color, :left, :right, :parent

  COLORS = %i[red black].freeze

  def initialize(value, color)
    @value = value
    validate_color!(color)
    @color = color
  end

  # Helpers for color checks
  def red?
    color == :red
  end

  def black?
    color == :black
  end

  # Flip between red and black
  def flip_color
    @color = red? ? :black : :red
  end

  private

  def validate_color!(col)
    raise ArgumentError, "Invalid color: #{col.inspect}" unless COLORS.include?(col)
  end
end
