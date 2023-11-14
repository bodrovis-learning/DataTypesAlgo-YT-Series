# frozen_string_literal: true

require_relative 'queue'

class Vertex
  attr_accessor :value, :adjacent_vertices

  def initialize(value)
    @value = value
    @adjacent_vertices = []
  end

  def add_adjacent_vertex(vertex)
    return if adjacent_vertices.include?(vertex)

    @adjacent_vertices << vertex

    vertex.add_adjacent_vertex(self)
  end

  class << self
    # Depth-first search
    def dfs_traverse(vertex, visited_vertices = {}, &)
      visited_vertices[vertex.value] = true

      yield vertex

      vertex.adjacent_vertices.each do |adjacent_vertex|
        next if visited_vertices[adjacent_vertex.value]

        dfs_traverse(adjacent_vertex, visited_vertices, &)
      end
    end

    # DFS, searching for a specific value
    def dfs(vertex, search_value, visited_vertices = {})
      return vertex if vertex.value == search_value

      visited_vertices[vertex.value] = true

      vertex.adjacent_vertices.each do |adjacent_vertex|
        next if visited_vertices[adjacent_vertex.value]

        return adjacent_vertex if adjacent_vertex.value == search_value

        vertex_searched_for = dfs(adjacent_vertex, search_value, visited_vertices)

        return vertex_searched_for if vertex_searched_for
      end

      nil
    end

    # Breadth-first search
    def bfs_traverse(starting_vertex)
      queue = Queue.new
      visited_vertices = {}

      visited_vertices[starting_vertex.value] = true

      queue.enqueue(starting_vertex)

      while queue.read
        current_vertex = queue.dequeue

        yield current_vertex

        current_vertex.adjacent_vertices.each do |adjacent_vertex|
          next if visited_vertices[adjacent_vertex.value]

          visited_vertices[adjacent_vertex.value] = true

          queue.enqueue(adjacent_vertex)
        end
      end
    end
  end
end

alice = Vertex.new('Alice')
bob = Vertex.new('Bob')
john = Vertex.new('John')
kelly = Vertex.new('Kelly')

alice.add_adjacent_vertex(bob)
bob.add_adjacent_vertex(john)
kelly.add_adjacent_vertex(alice)

Vertex.dfs_traverse(alice) { |next_v| puts next_v.value }

puts '==='

puts Vertex.dfs(alice, 'Bob').inspect

puts '==='

Vertex.bfs_traverse(alice) { |next_v| puts next_v.value }
