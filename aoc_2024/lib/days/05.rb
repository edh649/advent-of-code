
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
    
    invalidUpdates = []
    updates.each do |update|
      updatePages = update.split(",").map do |p| p.to_i end
      if findBadPage(updatePages, rulesArr) != nil
        invalidUpdates.append(update)
      end
    end
    
    result = 0
    
    # move offending item one later
    invalidUpdates.each do |update|
      i = 0
      updatePages = update.split(",").map do |p| p.to_i end
      while i < 50000
        i += 1
        if i % 100 == 0
          updatePages.shuffle! #hail mary
        end
        badPage = findBadPage(updatePages, rulesArr)
        if badPage == nil
          result += updatePages[(updatePages.count() - 1) / 2]
          break
        end
        idx = updatePages.find_index(badPage)
        updatePages.delete_at(idx)
        updatePages.insert(idx + 1, badPage)
      end
      if i == 50000
        puts "failed to find valid update"
      end
    end
    
    return result
  end
  
end