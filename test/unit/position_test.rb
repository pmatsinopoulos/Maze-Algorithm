require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../models/position', __FILE__)

class PositionTest < Test::Unit::TestCase

  def test_initialize_with_wrong_coordinates_raises_exception
    assert_raise Exception do
      Position.new(0, 1)
    end
    assert_raise Exception do
      Position.new(1, 0)
    end
  end

  def test_position_attributes
    p = Position.new(5, 6)
    assert_equal 5, p.w
    assert_equal 6, p.h

    assert_raise Exception do
      p.w = 0
    end
    assert_raise Exception do
      p.h = 0
    end

    p.w = 8
    assert_equal 8, p.w

    p.h = 18
    assert_equal 18, p.h
  end

  def test_equality
    assert Position.new(8, 2).respond_to?("==")
    p1 = Position.new(8, 2)
    p2 = Position.new(8, 2)
    assert_equal p1, p2

    p3 = Position.new(8, 3)
    assert p1 != p3
  end

  def test_right
    p = Position.new(1, 1)
    assert p.right(1).nil?
    assert_equal p.right(2), Position.new(2, 1)
    assert_equal p.right(5), Position.new(2, 1)
  end

  def test_left
    p = Position.new(1, 4)
    assert p.left.nil?
    p = Position.new(2, 5)
    assert_equal p.left, Position.new(1, 5)
  end

  def test_top
    p = Position.new(5, 6)
    assert_nil p.top(6)
    assert_equal p.top(10), Position.new(5, 7)
  end

  def test_bottom
    p = Position.new(3, 1)
    assert_nil p.bottom
    p = Position.new(3, 5)
    assert_equal p.bottom, Position.new(3, 4)
  end
end