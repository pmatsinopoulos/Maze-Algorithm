require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../models/maze', __FILE__)
require File.expand_path('../../../models/maze_element', __FILE__)
require File.expand_path('../../../models/maze_element', __FILE__)

class MazeTest < Test::Unit::TestCase

  # initialize

  def test_initialize_calls_dimensions_validation
    w = 6
    h = 7
    assert Maze.any_instance.expects(:validate_dimensions).with(w, h)
    # fire
    Maze.new(w, h)
  end

  def test_initialize_creates_a_two_dimensional_array_of_maze_elements
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze_attribute = maze.send("maze")
    (1..w).each do |i|
      (1..h).each do |j|
        assert maze_attribute[i - 1][j - 1].is_a?(MazeElement)
      end
    end
    assert maze.path_to_goal.is_a?(Array)
    assert_equal 0, maze.path_to_goal.size
  end

  def test_initialize_with_some_walls
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    maze = Maze.new(w, h, walls)
    maze_attribute = maze.send("maze")
    (1..w).each do |i|
      (1..h).each do |j|
        current_position = Position.new(i, j)
        assert maze_attribute[i - 1][j - 1].is_a?(Wall) if walls.include?(current_position)
        assert maze_attribute[i - 1][j - 1].is_a?(Free) unless walls.include?(current_position)
      end
    end
  end

  def test_initialize_with_walls_and_start
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    maze = Maze.new(w, h, walls, Position.new(1, 2))
    maze_attribute = maze.send("maze")
    (1..w).each do |i|
      (1..h).each do |j|
        current_position = Position.new(i, j)
        assert maze_attribute[i - 1][j - 1].is_a?(Wall) if walls.include?(current_position)
        assert maze_attribute[i - 1][j - 1].is_a?(Free) unless walls.include?(current_position)
      end
    end
    assert_equal 1, maze.start.w
    assert_equal 2, maze.start.h
  end

  def test_initialize_with_walls_and_start_and_goal
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    maze = Maze.new(w, h, walls, Position.new(1, 2), Position.new(4, 6))
    maze_attribute = maze.send("maze")
    (1..w).each do |i|
      (1..h).each do |j|
        current_position = Position.new(i, j)
        assert maze_attribute[i - 1][j - 1].is_a?(Wall) if walls.include?(current_position)
        assert maze_attribute[i - 1][j - 1].is_a?(Free) unless walls.include?(current_position)
      end
    end
    assert_equal 1, maze.start.w
    assert_equal 2, maze.start.h
    assert_equal 4, maze.goal.w
    assert_equal 6, maze.goal.h
  end

  def test_initialize_with_walls_and_nil_start_but_goal
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    maze = Maze.new(w, h, walls, nil, Position.new(4, 6))
    maze_attribute = maze.send("maze")
    (1..w).each do |i|
      (1..h).each do |j|
        current_position = Position.new(i, j)
        assert maze_attribute[i - 1][j - 1].is_a?(Wall) if walls.include?(current_position)
        assert maze_attribute[i - 1][j - 1].is_a?(Free) unless walls.include?(current_position)
      end
    end
    assert_equal 4, maze.goal.w
    assert_equal 6, maze.goal.h
  end

  # initialize with exceptions

  def test_initialize_with_walls_and_start_on_wall
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    assert_raise Exception do
      Maze.new(w, h, walls, Position.new(5, 6))
    end
  end

  def test_initialize_with_walls_and_goal_on_wall
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    assert_raise Exception do
      Maze.new(w, h, walls, Position.new(5, 7), Position.new(5, 6))
    end
  end

  def test_initialize_with_walls_and_start_and_goal_on_walls
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    assert_raise Exception do
      Maze.new(w, h, walls, Position.new(5, 6), Position.new(6, 7))
    end
  end

  def test_initialize_with_walls_and_nil_start_and_goal_on_wall
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    assert_raise Exception do
      Maze.new(w, h, walls, nil, Position.new(5, 6))
    end
  end

  def test_initialize_with_walls_and_start_equal_to_goal
    w = 6
    h = 7
    walls = [Position.new(1, 1), Position.new(5, 6), Position.new(6, 7)]
    assert_raise Exception do
      Maze.new(w, h, walls, Position.new(1, 3), Position.new(1, 3))
    end
  end

  # width
  def test_width
    w = 6
    h = 7
    maze = Maze.new(w, h)
    assert_equal 6, maze.width
  end

  # height
  def test_height
    w = 6
    h = 7
    maze = Maze.new(w, h)
    assert_equal 7, maze.height
  end

  # maze_element
  def test_maze_element
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze_attribute = maze.send("maze")
    position = Position.new(3, 4)
    assert_equal maze_attribute[position.w - 1][position.h - 1], maze.maze_element(position)
  end

  # start

  def test_start_set_with_a_position
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.start = Position.new(2, 3)
    maze_attribute = maze.send("maze")
    assert maze_attribute[2 - 1][3 - 1].is_a?(Free)
    assert_equal 2, maze.start.w
    assert_equal 3, maze.start.h
  end

  def test_start_set_with_coordinates
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.start = 2, 3
    maze_attribute = maze.send("maze")
    assert maze_attribute[2 - 1][3 - 1].is_a?(Free)
    assert_equal 2, maze.start.w
    assert_equal 3, maze.start.h
  end

  def test_raise_exception_if_start_set_to_wall
    w = 6
    h = 7
    walls = [Position.new(2, 3)]
    maze = Maze.new(6, 7, walls)
    assert_raise Exception do
      maze.start = 2, 3
    end
  end

  def test_raise_exception_if_start_set_to_be_equal_to_goal
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.goal = 6, 6
    assert_raise Exception do
      maze.start = 6, 6
    end
  end

  # goal

  def test_goal_set_with_a_position
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.goal = Position.new(2, 3)
    maze_attribute = maze.send("maze")
    assert maze_attribute[2 - 1][3 - 1].is_a?(Free)
    assert_equal 2, maze.goal.w
    assert_equal 3, maze.goal.h
  end

  def test_goal_set_with_coordinates
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.goal = 2, 3
    maze_attribute = maze.send("maze")
    assert maze_attribute[2 - 1][3 - 1].is_a?(Free)
    assert_equal 2, maze.goal.w
    assert_equal 3, maze.goal.h
  end

  def test_raise_exception_if_goal_set_to_wall
    w = 6
    h = 7
    walls = [Position.new(2, 3)]
    maze = Maze.new(6, 7, walls)
    assert_raise Exception do
      maze.goal = 2, 3
    end
  end

  def test_raise_exception_if_goal_set_to_be_equal_to_start
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.start = 6, 6
    assert_raise Exception do
      maze.goal = 6, 6
    end
  end

  # wall

  def test_setting_wall_with_position
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.wall= Position.new(2, 3)
    maze_attribute = maze.send("maze")
    assert maze_attribute[2 - 1][3 - 1].is_a?(Wall)
  end

  def test_setting_wall_with_coordinates
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.wall = 2, 3
    maze_attribute = maze.send("maze")
    assert maze_attribute[2 - 1][3 - 1].is_a?(Wall)
  end

  def test_raise_exception_setting_wall_on_start
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.start = 2, 3
    assert_raise Exception do
      maze.wall = 2, 3
    end
  end

  def test_raise_exception_setting_wall_on_goal
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.goal = 2, 3
    assert_raise Exception do
      maze.wall = 2, 3
    end
  end

  def test_raise_exception_setting_wall_on_start_with_goal_already_set
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.goal = 5, 6
    maze.start = 2, 3
    assert_raise Exception do
      maze.wall = 2, 3
    end
  end

  def test_raise_exception_setting_wall_on_goal_with_start_already_set
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.goal = 5, 6
    maze.start = 2, 3
    assert_raise Exception do
      maze.wall = 5, 6
    end
  end

  # free

  def test_setting_free_with_position
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.free = Position.new(2, 3)
    maze_attribute = maze.send("maze")
    assert maze_attribute[2 - 1][3 - 1].is_a?(Free)
  end

  def test_setting_free_with_coordinates
    w = 6
    h = 7
    maze = Maze.new(w, h)
    maze.free = 2, 3
    maze_attribute = maze.send("maze")
    assert maze_attribute[2 - 1][3 - 1].is_a?(Free)
  end

  # do not visit flag
  def test_do_not_visit_if_wall
    w = 6
    h = 7
    p = Position.new(5, 5)
    walls = [p]
    maze = Maze.new(6, 7, walls)
    assert maze.do_not_visit?(p)
  end

  def test_do_not_visit_if_visited
    w = 6
    h = 7
    p = Position.new(5, 5)
    maze = Maze.new(6, 7)
    me = maze.maze_element(p)
    me.visited = true
    assert maze.do_not_visit?(p)
  end

  def test_do_not_visit_if_position_nil
    w = 6
    h = 7
    maze = Maze.new(6, 7)
    assert maze.do_not_visit?(nil)
  end

  # find path to goal

  def test_find_path_to_goal_1
    w = 6
    h = 6
    walls = [Position.new(1, 3), Position.new(2, 3), Position.new(3, 3), Position.new(3, 2),
             Position.new(3, 5), Position.new(4, 5), Position.new(5, 5), Position.new(5, 3),
             Position.new(6, 5), Position.new(6, 3)]
    start = Position.new(1, 1)
    goal = Position.new(5, 6)
    maze = Maze.new(w, h, walls, start, goal)
    path_to_goal = maze.find_path_to_goal
    assert_equal [Position.new(1, 1), Position.new(1, 2), Position.new(2, 2), Position.new(2, 1),
                  Position.new(3, 1), Position.new(4, 1), Position.new(4, 2), Position.new(4, 3),
                  Position.new(4, 4), Position.new(5, 4), Position.new(6, 4), Position.new(3, 4),
                  Position.new(2, 4), Position.new(2, 5), Position.new(2, 6), Position.new(3, 6),
                  Position.new(4, 6), Position.new(5, 6)], path_to_goal
  end

  def test_find_path_to_goal_2
    w = 5
    h = 4
    walls = [Position.new(1, 3), Position.new(2, 3), Position.new(3, 3), Position.new(4, 3),
             Position.new(4, 2)]
    start = Position.new(3, 2)
    goal = Position.new(1, 4)
    maze = Maze.new(w, h, walls, start, goal)
    path_to_goal = maze.find_path_to_goal
    assert_equal [Position.new(3, 2), Position.new(2, 2), Position.new(1, 2), Position.new(1, 1),
                  Position.new(2, 1), Position.new(3, 1), Position.new(4, 1), Position.new(5, 1),
                  Position.new(5, 2), Position.new(5, 3), Position.new(5, 4), Position.new(4, 4),
                  Position.new(3, 4), Position.new(2, 4), Position.new(1, 4)], path_to_goal
  end

  def test_find_path_to_goal_3
    w = 2
    h = 2
    start = Position.new(1, 1)
    goal = Position.new(2, 2)
    maze = Maze.new(w, h, nil, start, goal)
    path_to_goal = maze.find_path_to_goal
    assert_equal [Position.new(1, 1), Position.new(1, 2), Position.new(2, 2)], path_to_goal
  end

  def test_find_path_to_goal_4
    w = 3
    h = 5
    start = Position.new(3, 1)
    goal = Position.new(1, 1)
    walls = [Position.new(2, 1), Position.new(2, 2), Position.new(2, 3), Position.new(2, 4)]
    maze = Maze.new(w, h, walls, start, goal)
    path_to_goal = maze.find_path_to_goal
    assert_equal [Position.new(3, 1), Position.new(3, 2), Position.new(3, 3),
                  Position.new(3, 4), Position.new(3, 5), Position.new(2, 5),
                  Position.new(1, 5), Position.new(1, 4), Position.new(1, 3),
                  Position.new(1, 2), Position.new(1, 1)], path_to_goal
  end

  # validate dimensions

  def test_width_and_height_validation
    assert_nothing_raised do
      Maze.new(2, 2)
    end
    assert_nothing_raised do
      Maze.new(3, 4)
    end
    assert_raise Exception do
      Maze.new(1, 2)
    end
    assert_raise Exception do
      Maze.new(2, 1)
    end
  end

end