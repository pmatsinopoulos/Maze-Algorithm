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