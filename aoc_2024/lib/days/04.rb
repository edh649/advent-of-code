
class Day04
    
  def part1(input)
    lines = convertToSingleLines(input)
    
    count = 0
    lines.each do |line|
      count += line.scan("XMAS").count()
      count += line.scan("SAMX").count()
    end
    return count
  end
  
  def convertToSingleLines(input)
    horizontalLines = []
    verticalLines = []
    diagonalLinesFalling = []
    diagonalLinesRising = []
    
    lines = input.split("\n")
    height = lines.count()
    lines.each_with_index.each do |line, x|
      width = line.length()
      line.chars.each_with_index.each do |char, y|
        # assign here
        horizontalLines = setValue(horizontalLines, x, y, char)
        verticalLines = setValue(verticalLines, y, x, char)
        diagonalLinesFalling = setValue(diagonalLinesFalling, (width + (x - y)), x, char)
        diagonalLinesRising = setValue(diagonalLinesRising, (x + y), y, char)
      end
    end
    
    outputLines = []
    horizontalLines.each do |hLine| 
      if hLine != nil 
        outputLines.append(hLine.join())
      end
    end
    verticalLines.each do |vLine| 
      if vLine != nil 
        outputLines.append(vLine.join())
      end
    end
    diagonalLinesFalling.each do |dFline| 
      if dFline != nil 
        outputLines.append(dFline.join())
      end
    end
    diagonalLinesRising.each do |dRline| 
      if dRline != nil 
        outputLines.append(dRline.join())
      end
    end
    return outputLines
  end
  
  def setValue(arr, line, place, value)
    if arr[line] == nil
      arr[line] = []
    end
    arr[line][place] = value
    return arr
  end
  
  def part2(input)
    matrix = setupMatrix(input)
    
    boundX = matrix.count() - 1
    boundY = matrix[0].count() - 1
    
    count = 0
    for x in 0..boundX
      for y in 0..boundY
        
        if x+2 > boundX || y+2 > boundY
          break
        end
        
        if matrix[x][y] == "M" && matrix[x+2][y] == "M" && matrix[x+1][y+1] == "A" && matrix[x][y+2] == "S" && matrix[x+2][y+2] == "S"
          count += 1
        end
        if matrix[x][y] == "M" && matrix[x+2][y] == "S" && matrix[x+1][y+1] == "A" && matrix[x][y+2] == "M" && matrix[x+2][y+2] == "S"
          count += 1
        end
        if matrix[x][y] == "S" && matrix[x+2][y] == "M" && matrix[x+1][y+1] == "A" && matrix[x][y+2] == "S" && matrix[x+2][y+2] == "M"
          count += 1
        end
        if matrix[x][y] == "S" && matrix[x+2][y] == "S" && matrix[x+1][y+1] == "A" && matrix[x][y+2] == "M" && matrix[x+2][y+2] == "M"
          count += 1
        end
      end
    end
    return count
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
  
end