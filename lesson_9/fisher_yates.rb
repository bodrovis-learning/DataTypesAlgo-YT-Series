# frozen_string_literal: true

def fisher_yates(array)
  (0...(array.length - 1)).each do |i|
    j = rand(i..(array.length - 1))
    array[i], array[j] = array[j], array[i]
  end
end

array = [1, 2, 3, 4, 5, 6, 7, 8]
fisher_yates(array)
puts array.inspect
