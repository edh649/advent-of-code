
class Day02
    
  def part1(input)
    safeReports = 0
    reports = input.split("\n")
    
    reports.each do |report|
        safe = nil
        levels = report.split(" ").map { |x| x.to_i }
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
              safe = false
              break
            end
          end
          
          diff = (level - previousLevel).abs
          if diff < 1 || diff > 3
            safe = false
            break
          end
        end
        if safe == false
          next
        else
          safeReports += 1
        end
    end
    
    return safeReports
    
  end
  
  def part2(input)
  
  end
  
end