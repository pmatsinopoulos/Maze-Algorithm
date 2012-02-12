class Stack

  # public methods
  def initialize
    @stack = Array.new
  end

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

end