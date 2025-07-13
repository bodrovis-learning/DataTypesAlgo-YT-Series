# frozen_string_literal: true

class Node
  attr_accessor :data, :next_node, :previous_node, :product, :price

  def initialize(data)
    @data          = data
    @next_node     = nil
    @previous_node = nil

    # Only attempt to extract product/price if we got a Hash
    return unless data.is_a?(Hash)

    @product = data[:key] || data['key']
    @price   = data[:data] || data['data']
  end
end
