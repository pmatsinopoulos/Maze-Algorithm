class Stack
  include Enumerable

  # public methods
  def initialize
    @stack = Array.new
  end

  attr_reader :stack

  def push(element)
    @stack << element
  end

  def pop
    return nil if empty?
    @stack.delete_at(@stack.size - 1)
  end

  def top
    return nil if empty?
    @stack[@stack.size - 1]
  end

  def size
    @stack.size
  end

  def empty?
    @stack.size == 0
  end

  def each(&block)
    @stack.each(&block)
  end

end