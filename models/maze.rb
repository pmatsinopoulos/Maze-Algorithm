require File.expand_path('../maze_element', __FILE__)
require File.expand_path('../position', __FILE__)
require File.expand_path('../wall', __FILE__)
require File.expand_path('../free', __FILE__)
require File.expand_path('../stack', __FILE__)

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

    # This will hold the path to the goal. They will be +Position+ instances
    @path_to_goal = Array.new
  end

  attr_reader :path_to_goal

  def width
    @maze.size
  end

  def height
    @maze[0].size
  end

  def maze_element(position)
    @maze[position.w - 1][position.h - 1]
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

    raise Exception.new("Cannot put start on a wall")                  unless maze_element(@start).is_a?(Free)
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

    raise Exception.new("Cannot put goal on a wall")                   unless maze_element(@goal).is_a?(Free)
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
    current_position = position_or_coordinates
    current_position = Position.new(position_or_coordinates[0], position_or_coordinates[1]) if position_or_coordinates.is_a?(Array)
    raise Exception.new("This position conflicts with start and/or goal") unless ( @start.nil? || @start != current_position ) &&
                                                                                 ( @goal.nil? || @goal != current_position )
    @maze[current_position.w - 1][current_position.h - 1] = Wall.new
  end

  # Similar to +wall=+ but for +free+
  # Note that here we do not have to test for start or goal conflicts
  #
  def free=(position_or_coordinates)
    p = position_or_coordinates
    p = Position.new(position_or_coordinates[0], position_or_coordinates[1]) if position_or_coordinates.is_a?(Array)
    @maze[p.w - 1][p.h - 1] = Free.new
  end

  def do_not_visit?(position)
    return true if position.nil?
    me = maze_element(position)
    me.is_a?(Wall) || me.visited?
  end

  # Find the goal in a maze using a stack (depth ﬁrst search)
  # ------------------------------------------------------------
  #
  #
  def find_path_to_goal
    s = Stack.new # s will hold +Position+ objects that correspond to Frees that I have to visit, but have not visited yet
    s.push(@start)
    @path_to_goal.clear
    while !s.empty?
      current_position = s.pop
      @path_to_goal << current_position
      if current_position == @goal
        # puts "Success reaching #{@goal.w}/#{@goal.h}. Path is #{@path_to_goal.inspect}"
        s = Stack.new # just to end loop
      else
        current_element = maze_element(current_position)
        current_element.visited = true

        # need to add the neighbouring positions that can be visited
        # marking that have to visit them. Note that we are not allowed to walk
        # diagonally.
        current_top = current_position.top(height)
        current_right = current_position.right(width)
        current_bottom = current_position.bottom
        current_left = current_position.left

        s.push(current_bottom) unless do_not_visit?(current_bottom)
        s.push(current_left)   unless do_not_visit?(current_left)
        s.push(current_right)  unless do_not_visit?(current_right)
        s.push(current_top)    unless do_not_visit?(current_top)
      end
    end
    @path_to_goal
  end

  protected

  def validate_dimensions(width, height)
    raise Exception.new if width < 2 || height < 2
  end

  attr_accessor :maze

end