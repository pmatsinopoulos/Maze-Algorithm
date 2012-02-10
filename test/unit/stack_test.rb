require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../models/stack', __FILE__)

class StackTest < Test::Unit::TestCase

  def setup
    @stack = Stack.new
  end

  def test_push
    number_of_elements_before = @stack.size
    @stack.push(1)
    number_of_elements_after = @stack.size
    assert_equal number_of_elements_before + 1, number_of_elements_after
    assert_equal 1, @stack.top
  end

  def test_pop
    number_of_elements_before = @stack.size
    @stack.push(1)
    number_of_elements_after = @stack.size
    assert_equal number_of_elements_before + 1, number_of_elements_after
    assert_equal 1, @stack.top
    assert_equal 1, @stack.pop
    assert_equal number_of_elements_after - 1, @stack.size
  end

  def test_top
    number_of_elements_before = @stack.size
    @stack.push(1)
    number_of_elements_after = @stack.size
    assert_equal number_of_elements_before + 1, number_of_elements_after
    assert_equal 1, @stack.top
  end

  def test_size
    assert @stack.empty?
    @stack.push(1)
    @stack.push(2)
    assert_equal 2, @stack.size
  end

  def test_empty
    assert @stack.empty?
    @stack.push(1)
    assert !@stack.empty?
    @stack.pop
    assert @stack.empty?
  end

end