require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay12 < Minitest::Test
  def setup
    @day = Day12.new
  end

  def test_part1
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '12_1.txt')).rstrip), 140
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '12_2.txt')).rstrip), 772
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '12_3.txt')).rstrip), 4*1*4

    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '12.txt')).rstrip), 1930
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '12_1.txt')).rstrip), 80
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '12_b_1.txt')).rstrip), 236
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '12_b_2.txt')).rstrip), 368
    
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '12.txt')).rstrip), 1206
  end
end