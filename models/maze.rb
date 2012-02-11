require File.expand_path('../maze_element', __FILE__)
require File.expand_path('../position', __FILE__)
require File.expand_path('../wall', __FILE__)
require File.expand_path('../free', __FILE__)

class Maze

  # A width X height 2-dimensional array of +MazeElement+ objects
  #
  # start, goal are +Position+ instances. They tell where the start and goal of maze are
  #
  # walls is an Array of +Position+ instances, which tell us which positions
  # should be +Wall+ objects.
  #
  # Note that we raise an Exception if
  #    start == goal OR
  #    any of the walls defined matches start or goal
  # Also, an exception is raised if width < 2 and height < 2
  # so, the minimum maze is 2 X 2
  #
  def initialize(width, height, walls=nil, start=nil, goal=nil)
    validate_dimensions(width, height)

    @maze = Array.new(width) do |i|
      Array.new(height) do |j|
        current_position = Position.new(i + 1, j + 1)
        if !walls.nil? && walls.include?(current_position)
          # I am being asked, to create a Wall on the current position.
          # I will not do it if this matches start or goal requirement.
          raise Exception.new("Cannot put a wall on start or goal positions") unless
                              ( start.nil? || start != current_position ) &&
                              ( goal.nil? || goal != current_position )
          Wall.new
        else
          Free.new
        end
      end
    end

    @start = start unless start.nil?
    @goal = goal   unless goal.nil?

    raise Exception.new("Cannot have start and goal on same position") unless start.nil? || goal.nil? || start != goal
  end

  # Set the +start+ point. This is a reference to the starting MazeElement.
  #
  # @param {position_or_coordinates} is either a single +Position+ object
  # or two integers, array representation, representing a width and height position.
  #
  def start=(position_or_coordinates)
    if position_or_coordinates.is_a?(Position)
      @start = position_or_coordinates
    else
      w = position_or_coordinates[0]
      h = position_or_coordinates[1]
      @start = Position.new(w, h)
    end

    raise Exception.new("Cannot put start on a wall")                  unless @maze[@start.w - 1][@start.h - 1].is_a?(Free)
    raise Exception.new("Cannot have start and goal on same position") unless (@goal.nil? || @start != @goal)
  end

  attr_reader :start

  # Similar to +start+ but for the goal of the Maze
  #
  def goal=(position_or_coordinates)
    if position_or_coordinates.is_a?(Position)
      @goal = position_or_coordinates
    else
      w = position_or_coordinates[0]
      h = position_or_coordinates[1]
      @goal = Position.new(w, h)
    end

    raise Exception.new("Cannot put goal on a wall")                   unless @maze[@goal.w - 1][@goal.h - 1].is_a?(Free)
    raise Exception.new("Cannot have start and goal on same position") unless (@start.nil? || @start != @goal)
  end

  attr_reader :goal

  # Sets a wall on the maze.
  #
  # @param {position} can be either +Position+ or and Array of coordinates with and height
  # If coordinates sent, they have to be 1-based.
  # Note that you cannot set a wall on start or goal positions
  #
  def wall=(position_or_coordinates)
    current_position = position_or_coordinates                                              if position_or_coordinates.is_a?(Position)
    current_position = Position.new(position_or_coordinates[0], position_or_coordinates[1]) if position_or_coordinates.is_a?(Array)
    raise Exception.new("This position conflicts with start and/or goal") unless ( @start.nil? || @start != current_position ) &&
                                                                                 ( @goal.nil? || @goal != current_position )
    @maze[current_position.w - 1][current_position.h - 1] = Wall.new
  end

  # Similar to +wall=+ but for +free+
  # Note that here we do not have to test for start or goal conflicts
  #
  def free=(position_or_coordinates)
    @maze[position_or_coordinates.w - 1][position_or_coordinates.h - 1] = Free.new   if position_or_coordinates.is_a?(Position)
    @maze[position_or_coordinates[0] - 1][position_or_coordinates[1] - 1] = Free.new if position_or_coordinates.is_a?(Array)
  end

  protected

  def validate_dimensions(width, height)
    raise Exception.new if width < 2 || height < 2
  end

  attr_accessor :maze

end