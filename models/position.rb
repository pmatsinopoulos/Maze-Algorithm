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
end