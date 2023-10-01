# frozen_string_literal: true

def bin_search(arr, desired_value)
  lbound = 0
  ubound = arr.length - 1
  i = 0

  while lbound <= ubound
    i += 1
    mid = (ubound + lbound) / 2

    mid_value = arr[mid]

    if mid_value == desired_value
      return mid_value
    elsif desired_value > mid_value
      lbound = mid + 1
    else
      ubound = mid - 1
    end

    puts(i)
  end

  nil
end

arr = [1, 3, 4, 10, 15, 17, 19, 20, 21, 100, 150, 200]
puts bin_search(arr, 200)
puts arr.length
