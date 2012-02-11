require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../models/wall', __FILE__)
require File.expand_path('../../../models/maze_element', __FILE__)

class WallTest < Test::Unit::TestCase
  def test_wall_is_a_maze_element
    assert Wall.new.is_a?(MazeElement)
  end
end