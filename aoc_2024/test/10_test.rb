require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay10 < Minitest::Test
  def setup
    @day = Day10.new
  end

  def test_part1
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '10_1.txt')).rstrip), 1
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '10_2.txt')).rstrip), 2
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '10_3.txt')).rstrip), 4
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '10_4.txt')).rstrip), 3
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '10.txt')).rstrip), 36
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '10_b_1.txt')).rstrip), 3
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '10_b_2.txt')).rstrip), 13
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '10_b_3.txt')).rstrip), 227
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '10.txt')).rstrip), 81
  end
end