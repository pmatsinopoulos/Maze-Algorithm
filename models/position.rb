# Coordinates start from 1
#
# @w is the width coordinate
# @h is the height coordinate
#
class Position
  def initialize(w, h)
    raise Exception.new("Position coordinates have to be >= 1") if w < 1 || h < 1
    @w = w
    @h = h
  end

  def w
    @w
  end

  def w=(value)
    raise Exception.new("Position width has to be >=1") if value < 1
    @w = value
  end

  def h
    @h
  end

  def h=(value)
    raise Exception.new("Position height has to be >=1") if value < 1
    @h = value
  end

  def ==(b)
    @w == b.w && @h == b.h
  end

  # Returns new Position object which is on the right of self
  #
  # @param {wmax} Integer that limits movements to the right.
  #
  def right(wmax)
    return nil if @w + 1 > wmax
    return Position.new(@w + 1, @h)
  end

  def left
    return nil if @w - 1 < 1
    return Position.new(@w - 1, @h)
  end

  def top(hmax)
    return nil if @h + 1 > hmax
    return Position.new(@w, @h + 1)
  end

  def bottom
    return nil if @h - 1 < 1
    return Position.new(@w, @h - 1)
  end
end