# frozen_string_literal: true

class Cacher
  def initialize
    @cache = {}
  end

  def lowest_price(product)
    if @cache.key?(product)
      puts 'cache hit!'
      @cache[product]
    else
      puts 'searching web...'
      search_web_for(product)
    end
  end

  private

  def search_web_for(product)
    data_from_web = [799, 'Jupiter Electronics']

    sleep(1)

    @cache[product] = data_from_web
    data_from_web
  end
end

cacher = Cacher.new
puts cacher.lowest_price('smartphone').inspect
puts '==='
puts cacher.lowest_price('smartphone').inspect
puts '==='
