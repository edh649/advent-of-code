
class Day15
    
  def part1(input)
    inputs = input.split("\n\n")
    @matrix = setupMatrix(inputs[0])
    moves = inputs[1].split("\n").inject(:concat)
    moves.chars.each { |move| progress(move) }
    
    boxes = 0
    @matrix.each_with_index.each do |col, x|
      col.each_with_index.each do |row, y|
        if @matrix[x][y] == "O"
          boxes += getGps(x, y)
        end
      end
    end
    return boxes
  end
  
  def findRobotXY()
    @matrix.each_with_index.each do |col, x|
      col.each_with_index.each do |row, y|
        if @matrix[x][y] == "@"
          return [x, y]
        end
      end
    end
  end
  
  def progress(move)
    robotXY = findRobotXY()
    
    i = 0
    boxSwap = []
    valid = false
    while !valid
      i +=1
      if getLocationDirection(robotXY[0], robotXY[1], i, move) == "#"
        return # hit a wall, can't progress
      end
      if getLocationDirection(robotXY[0], robotXY[1], i, move) == "."
        # hit an empty space, progress!
        valid = true
        if boxSwap != []
          updateLocationDirection(boxSwap[0], boxSwap[1], boxSwap[2], boxSwap[3], "@")
          updateLocationDirection(robotXY[0], robotXY[1], i, move, "O")
        else
          updateLocationDirection(robotXY[0], robotXY[1], i, move, "@")
        end
        updateLocationDirection(robotXY[0], robotXY[1], 0, move, ".")
      end
      if getLocationDirection(robotXY[0], robotXY[1], i, move) == "O"
        if boxSwap == []
          boxSwap = [robotXY[0], robotXY[1], i, move]
        end
      end
    end
  end
  
  def getLocationDirection(x, y, offset, direction)
    if direction == "^"
      return @matrix[x][y + offset]
    elsif direction == "v"
      return @matrix[x][y - offset]
    elsif direction == "<"
      return @matrix[x - offset][y]
    elsif direction == ">"
      return @matrix[x + offset][y]
    end
  end
  
  def updateLocationDirection(x, y, offset, direction, value)
    if direction == "^"
      @matrix[x][y + offset] = value
    elsif direction == "v"
      @matrix[x][y - offset] = value
    elsif direction == "<"
      @matrix[x - offset][y] = value
    elsif direction == ">"
      @matrix[x + offset][y] = value
    end
  end
  
  def getGps(x, y)
    fromTop = (@matrix[0].count() - 1) - y
    fromSide = x
    return (100*fromTop) + fromSide
  end
  
  def setupMatrix(input)
    matrix = []
    lines = input.split("\n")
    lines.each_with_index.each do |line, row|
      line.chars.each_with_index.each do |char, col|
        y = lines.count() - (row + 1)
        if matrix[col] == nil
          matrix[col] = []
        end
        matrix[col][y] = char
      end
    end
    
    return matrix
  end
  
  
  def part2(input)
    inputs = input.split("\n\n")
    generateObjects(inputs[0])
    moves = inputs[1].split("\n").inject(:concat)
    moves.chars.each { |move| getRobotObject().moveDirection(move) }
    boxes = @objects.filter { |object| object.type == "box" }
    return boxes.sum { |box| box.getGps(inputs[0].split("\n").count() - 1) }
  end
  
  def generateObjects(input)
    @objects = []
    y = input.split("\n").count()
    input.split("\n").each do |line|
      y -= 1
      x = 0
      line.chars.each do |char|
        if char != "."
          @objects.append(Object.new(x, y, char, self))
        end
        x += 2
      end
    end
  end
  
  def printObjectMap()
    y = @objects.map { |object| object.y }.max
    x = @objects.map { |object| object.x }.max
    y.downto(0).each do |y|
      line = "\n"
      0.upto(x).each do |x|
        object = getObjectAtXY(x, y)
        if object == nil
          line += "."
        else
          line += object.print
        end
      end
      puts line
    end
  end
  
  def getRobotObject()
    @objects.find { |object| object.type == "robot" }
  end
  
  def getObjectAtXY(x, y)
    @objects.each do |object|
      if object.x == x && object.y == y
        return object
      end
    end
    @objects.each do |object|
      if object.x == x - 1 && object.y == y && object.width == 2
        return object
      end
    end
    return nil
  end
  
  class Object
    attr_accessor :x, :y, :width, :type, :day15
    
    def initialize(x, y, char, day15)
      @x = x
      @y = y
      if char == "#"
        @type = "wall"
        @width = 2
      elsif char == "O"
        @type = "box"
        @width = 2
      elsif char == "@"
        @type = "robot"
        @width = 1
      else
        puts "unknown object type of #{char}"
      end
      @day15 = day15
    end
    
    def print
      if @type == "wall"
        return "#"
      elsif @type == "box"
        return "O"
      elsif @type == "robot"
        return "@"
      end
    end
    
    def moveDirection(direction, commit = true)
      if direction == "^"
        return move(0, 1, commit)
      elsif direction == "v"
        return move(0, -1, commit)
      elsif direction == "<"
        return move(-1, 0, commit)
      elsif direction == ">"
        return move(1, 0, commit)
      end
    end
    
    def move(xDiff, yDiff, commit = true)
      if @type == "wall"
        return false # walls can't be moved
      end
      
      objectsToMove = []
      objectsToMove.append(@day15.getObjectAtXY(@x + xDiff, @y + yDiff))
      if @width == 2
        objectsToMove.append(@day15.getObjectAtXY(@x + 1 + xDiff, @y + yDiff))
      end
      objectsToMove.filter! { |object| object != nil && object != self }
      objectsToMove.uniq!
      objectsToMove.each do |object|
        moved = object.move(xDiff, yDiff, false)
        if moved == false
          return false
        end
        if commit # we know all can be moved, so move (if commit true)
          object.move(xDiff, yDiff, commit)
        end
      end
      
      #actually move the object
      if commit # we know all can be moved, so move (if commit true)
        @x += xDiff
        @y += yDiff
      end
      return true
    end
    
    def getGps(height)
      fromTop = (height) - y
      fromSide = x
      return (100*fromTop) + fromSide
    end
  end
  
end