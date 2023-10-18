# frozen_string_literal: true

require_relative 'queue'

class Background
  def initialize
    @queue = Queue.new
  end

  def add(job)
    @queue.enqueue(job)
  end

  def execute
    return if @queue.empty?

    puts "Processing #{@queue.dequeue}"

    execute
  end
end

bg = Background.new
bg.add('job 1')
bg.add('job 2')
bg.add('job 3')
bg.execute
