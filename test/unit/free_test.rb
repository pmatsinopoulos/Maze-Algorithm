require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../models/free', __FILE__)
require File.expand_path('../../../models/maze_element', __FILE__)

class FreeTest < Test::Unit::TestCase
  def test_free_is_a_maze_element
    assert Free.new.is_a?(MazeElement)
  end

  def test_free_responds_to_visited
    assert Free.new.respond_to?(:visited?)
  end

  def test_free_has_visited_attribute
    f = Free.new
    assert f.respond_to?(:visited)
    assert f.respond_to?("visited=")
  end
end