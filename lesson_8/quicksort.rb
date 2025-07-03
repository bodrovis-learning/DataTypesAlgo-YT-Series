# frozen_string_literal: true

class QuickSortable
  attr_reader :array

  def initialize(array)
    @array = array.dup
  end

  def quicksort
    work = @array.dup

    return work if work.size <= 1

    do_quicksort!(work, 0, work.size - 1)
  end

  private

  def do_quicksort!(arr, left_idx, right_idx)
    return if left_idx >= right_idx

    pivot_idx = partition!(arr, left_idx, right_idx)

    do_quicksort!(arr, left_idx, pivot_idx - 1)
    do_quicksort!(arr, pivot_idx + 1, right_idx)

    arr
  end

  def partition!(arr, left_ptr, right_ptr)
    pivot_idx = right_ptr
    pivot     = arr[pivot_idx]
    right_ptr -= 1 # start just left of the pivot

    loop do
      left_ptr  += 1 while arr[left_ptr] < pivot
      right_ptr -= 1 while right_ptr >= left_ptr && arr[right_ptr] > pivot

      break if left_ptr >= right_ptr

      arr[left_ptr], arr[right_ptr] = arr[right_ptr], arr[left_ptr]
      left_ptr += 1
    end

    # drop pivot into its final slot
    arr[left_ptr], arr[pivot_idx] = arr[pivot_idx], arr[left_ptr]
    left_ptr
  end
end

numbers = [5, 3, 8, 4, 2, 7, 1, 10]
puts QuickSortable.new(numbers).quicksort.inspect
puts numbers.inspect
