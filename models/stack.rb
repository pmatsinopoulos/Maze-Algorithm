class Stack

  # public methods
  def initialize
    @stack = Array.new
  end

  def push(element)
    @stack << element
  end

  def pop
    @stack.delete_at(@stack.size - 1)
  end

  def top
    @stack[@stack.size - 1]
  end

  def size
    @stack.size
  end

  def empty?
    @stack.size == 0
  end

end