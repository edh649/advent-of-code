
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
    #Maybe regex, tried but didn't work great bleugh...
  end
  
  
  
  
end