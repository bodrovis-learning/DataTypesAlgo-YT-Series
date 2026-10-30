# frozen_string_literal: true

require 'fileutils'

class BTree
  attr_accessor :root, :max_node_size

  def initialize(root = nil)
    @root = root
    @max_node_size = 4
  end

  # Returns: [found(Boolean), node_file(String), index(Integer)]
  def search(search_value, node = nil)
    node_file = node || @root
    node_data = read_node_file(node_file)

    values   = node_data[:values]
    children = node_data[:children]

    index = 0
    current_value = nil
    child_to_follow = nil

    while index < values.length
      current_value = values[index]

      return [true, node_file, index] if current_value == search_value

      if search_value < current_value
        return [false, node_file, index] unless children

        child_to_follow = children[index]
        break

      end

      index += 1
    end

    # if search_value is greater than all values:
    if current_value && search_value > current_value
      return [false, node_file, index] unless children

      child_to_follow = children[-1]

    end

    search(search_value, child_to_follow)
  end

  # File format:
  # line 1: parent filename or "None"
  # line 2: "1,2,3," (values with trailing comma)
  # line 3: "a.csv,b.csv," (children with trailing comma) OR missing/blank => no children
  def read_node_file(node_file)
    lines = File.read(node_file).lines.map(&:chomp)

    parent = lines[0] || 'None'

    values_line = (lines[1] || '').sub(/,\z/, '')
    values =
      if values_line.empty?
        []
      else
        values_line.split(',').map(&:to_i)
      end

    children = nil
    if lines.length >= 3
      children_line = (lines[2] || '').sub(/,\z/, '')
      unless children_line.empty?
        children = children_line.split(',')
        children = nil if children.empty? || children[0].to_s.empty?
      end
    end

    { parent: parent, values: values, children: children }
  end

  def insert(value)
    # if tree is empty:
    if @root.nil?
      create_root(value)
      return
    end

    search_result = search(value)

    # if value is already in tree:
    return if search_result[0]

    node_file = search_result[1]
    insert_into_node(node_file, value)
  end

  def insert_into_node(node_file, value)
    node_data = read_node_file(node_file)

    values   = node_data[:values]
    children = node_data[:children]
    parent   = node_data[:parent]

    values << value
    values.sort!

    if values.length > @max_node_size
      split_node(node_file, parent, values, children)
    else
      write_to_node_file(node_file, parent, values, children)
    end
  end

  def split_node(node_file, parent, values, children = nil)
    FileUtils.rm_f(node_file)

    median_index = @max_node_size / 2
    left_node_filename  = "#{values[0]}.csv"
    right_node_filename = "#{values[median_index + 1]}.csv"

    parent_node_filename =
      if parent == 'None'
        "#{values[median_index]}.csv"
      else
        parent
      end

    # Split children if present
    if children
      left_children  = children[0...(median_index + 1)]
      right_children = children[(median_index + 1)..]
    else
      left_children = nil
      right_children = nil
    end

    write_to_node_file(left_node_filename, parent_node_filename,
                       values[0...median_index], left_children)
    write_to_node_file(right_node_filename, parent_node_filename,
                       values[(median_index + 1)..], right_children)

    if parent == 'None'
      new_parent = write_to_node_file(
        parent_node_filename,
        'None',
        [values[median_index]],
        [left_node_filename, right_node_filename]
      )
      @root = new_parent
    else
      # add new left/right into parent's children where the old node was
      parent_data = read_node_file(parent_node_filename)
      parent_children = parent_data[:children] || []
      index_of_node_file = parent_children.index(node_file)

      # If something went sideways and we can't find it, fall back to append.
      updated_children = if index_of_node_file.nil?
                           parent_children + [left_node_filename, right_node_filename]
                         else
                           parent_children[0...index_of_node_file] +
                             [left_node_filename, right_node_filename] +
                             parent_children[(index_of_node_file + 1)..]
                         end

      write_to_node_file(parent_node_filename,
                         parent_data[:parent],
                         parent_data[:values],
                         updated_children)

      # Insert the center value into the parent node:
      insert_into_node(parent_node_filename, values[median_index])
    end

    # Update left/right children's parent pointers
    left_children&.each do |child|
      child_data = read_node_file(child)
      write_to_node_file(child, left_node_filename,
                         child_data[:values], child_data[:children])
    end

    return unless right_children

    right_children.each do |child|
      child_data = read_node_file(child)
      write_to_node_file(child, right_node_filename,
                         child_data[:values], child_data[:children])
    end
  end

  def write_to_node_file(node_file, parent, values, children = nil)
    values_string = values.join(',')
    values_string += ',' unless values.empty?

    children_string = nil
    children_string = "#{children.join(',')}," if children && !children.empty?

    File.open(node_file, 'w') do |writer|
      writer.write("#{parent}\n")
      writer.write(values_string)
      writer.write("\n#{children_string}") if children_string
    end

    node_file
  end

  def create_root(value)
    filename = 'root.csv'
    File.open(filename, 'w') do |writer|
      writer.write("None\n")
      writer.write("#{value},")
    end
    @root = filename
  end
end
