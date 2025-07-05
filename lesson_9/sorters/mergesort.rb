# frozen_string_literal: true

class MergeSortable
  attr_reader :array

  def initialize(array)
    # work on a copy so we never mutate the caller’s
    @array = array.dup
  end

  # Public API – returns a new, sorted array
  def mergesort
    work = @array.dup

    return work if work.size <= 1

    do_mergesort!(work, 0, work.size - 1)
  end

  private

  # Recursively split and merge in place on `arr`
  def do_mergesort!(arr, left_idx, right_idx)
    return if left_idx >= right_idx

    mid = (left_idx + right_idx) / 2

    do_mergesort!(arr, left_idx, mid)
    do_mergesort!(arr, mid + 1, right_idx)
    merge!(arr, left_idx, mid, right_idx)

    arr
  end

  # Merge two sorted subarrays arr[left..mid] and arr[mid+1..right]
  def merge!(arr, left_idx, mid_idx, right_idx)
    left_half  = arr[left_idx..mid_idx]
    right_half = arr[(mid_idx + 1)..right_idx]

    l = 0
    r = 0
    write_idx = left_idx

    # pick the smaller head element until one half is empty
    while l < left_half.size && r < right_half.size
      if left_half[l] <= right_half[r]
        arr[write_idx] = left_half[l]
        l += 1
      else
        arr[write_idx] = right_half[r]
        r += 1
      end
      write_idx += 1
    end

    # copy any leftovers
    if l < left_half.size
      arr[write_idx..right_idx] = left_half[l..]
    elsif r < right_half.size
      arr[write_idx..right_idx] = right_half[r..]
    end
  end
end
