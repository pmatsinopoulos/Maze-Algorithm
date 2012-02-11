require File.expand_path("../maze_element", __FILE__)

class Free < MazeElement

  attr_accessor :visited

  def visited?
    @visited
  end

end