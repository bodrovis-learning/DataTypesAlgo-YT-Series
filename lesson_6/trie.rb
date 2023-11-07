# frozen_string_literal: true

require_relative 'node'

class Trie
  attr_reader :root

  def initialize
    @root = Node.new
  end

  def insert(word)
    # TODO: process word

    insert_word(word).children[:*] = nil
  end

  def search(word)
    word.each_char.inject(@root) do |current_node, char|
      children = current_node.children

      break unless children[char]

      children[char]
    end
  end

  def autocomplete(prefix)
    current_node = search(prefix)

    return unless current_node

    all_words_at(current_node)
  end

  def all_words_at(node, word = '', words = [])
    current_node = node || @root

    current_node.children.each do |key, child_node|
      key == :* ? words.append(word) : all_words_at(child_node, word + key, words)
    end

    words
  end

  private

  def insert_word(word)
    word.each_char.inject(@root) do |current_node, char|
      children = current_node.children

      children[char] || add_node(children, char)
    end
  end

  def add_node(node, char)
    new_node = Node.new

    node[char] = new_node

    new_node
  end
end

trie = Trie.new

trie.insert('cat')
trie.insert('bat')
trie.insert('battle')
trie.insert('car')

puts trie.root.inspect

puts '==='

puts trie.search('cat').inspect

puts '==='

puts trie.autocomplete('b').inspect
