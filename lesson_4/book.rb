# frozen_string_literal: true

require 'digest'

class Book
  include Comparable

  attr_reader :uid, :title

  def initialize(title)
    @uid = Digest::SHA2.hexdigest(title)
    @title = title
  end

  def <=>(other)
    # uid.to_i(16) <=> other.uid.to_i(16)
    title <=> other.title
  end
end
