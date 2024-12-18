require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay16 < Minitest::Test
  def setup
    @day = Day16.new
  end

  def test_part1
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '16_small.txt')).rstrip), 7036
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '16_large.txt')).rstrip), 11048    
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '16_small.txt')).rstrip), 45
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '16_large.txt')).rstrip), 64    
  end
end