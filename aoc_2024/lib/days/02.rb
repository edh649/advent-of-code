
class Day02
    
  def part1(input)
    safeReports = 0
    reports = input.split("\n")
    
    reports.each do |report|
        if checkLevels(report.split(" ").map { |x| x.to_i })
          safeReports += 1
        end
    end
    
    return safeReports
  end
  
  def checkLevels(levels)
    type = nil
    previousLevel = nil
    levels.each_with_index.each do |level, i|
      if previousLevel == nil
        previousLevel = level
        next
      end
      previousLevel = levels[i-1]
      
      if type == nil
        level > previousLevel ? type = "up" : type = "down"
      else
        currentType = level > previousLevel ? "up" : "down"
        if currentType != type
          return false
        end
      end
      
      diff = (level - previousLevel).abs
      if diff < 1 || diff > 3
        return false
      end
    end
    return true
  end
  
  def part2(input)
    safeReports = 0
    reports = input.split("\n")
    
    reports.each do |report|
      levels = report.split(" ").map { |x| x.to_i }
        if checkLevels(levels)
          safeReports += 1
        else
          # try removing each level and seeing if valid
          levels.each_with_index.each do |level, i|
            newLevels = levels.dup
            newLevels.delete_at(i)
            if checkLevels(newLevels)
              safeReports += 1
              break
            end
          end
        end
    end
    
    return safeReports
  end
  
end