
class Day05
    
  def part1(input)
    rules = input.split("\n\n")[0].split("\n")
    updates = input.split("\n\n")[1].split("\n")
    
    rulesArr = []
    rules.each do |ruleLine|
      pages = ruleLine.split("|").map do |p| p.to_i end
      if rulesArr[pages[0]] == nil
        rulesArr[pages[0]] = []
      end
      rulesArr[pages[0]].append(pages[1])
    end
    
    result = 0
    updates.each do |update|
      updatePages = update.split(",").map do |p| p.to_i end
      if findBadPage(updatePages, rulesArr) == nil
        # puts "valid " + update.to_s
        center = updatePages[(updatePages.count() - 1) / 2]
        # puts center.to_s
        result += center
      end
    end
    return result
  end
  
  def findBadPage(updatePages, rulesArr)
    updatePages.each_with_index.each do |updatePage, i|
      updatePages[i+1..-1].each do |remainingPage|
        if rulesArr[updatePage] == nil || (!rulesArr[updatePage].include?(remainingPage))
          return updatePage
        end
      end
    end
    return nil
  end
  
  def part2(input)
    rules = input.split("\n\n")[0].split("\n")
    updates = input.split("\n\n")[1].split("\n")
    
    rulesArr = []
    rules.each do |ruleLine|
      pages = ruleLine.split("|").map do |p| p.to_i end
      if rulesArr[pages[0]] == nil
        rulesArr[pages[0]] = []
      end
      rulesArr[pages[0]].append(pages[1])
    end
    
    badUpdates = []    
    updates.each do |update|
      updatePages = update.split(",").map do |p| p.to_i end
      if findBadPage(updatePages, rulesArr) != nil
        badUpdates.append(update)
      end
    end
    
    result = 0
    badUpdates.each do |update|
      badPages = update.split(",").map do |p| p.to_i end
      for i in 0..badPages.count()-1 do #inefficient but it'll do, just loop and it'll fix itself..
        badPages.each_with_index.each do |updatePage, i|
          (rulesArr[updatePage] || []).each do |pageToGoBefore|
            if badPages[0..i].include?(pageToGoBefore)
              # swap pages
              badPages[i], badPages[badPages.index(pageToGoBefore)] = badPages[badPages.index(pageToGoBefore)], badPages[i]
            end
          end
        end
      end
      # puts "valid " + update.to_s
      center = badPages[(badPages.count() - 1) / 2]
      # puts center.to_s
      result += center
    end
    return result
  end
  
end