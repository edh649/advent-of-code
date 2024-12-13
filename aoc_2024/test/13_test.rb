require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay13 < Minitest::Test
  def setup
    @day = Day13.new
  end

  def test_part1
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '13.txt')).rstrip), 480
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '13.txt')).rstrip), 875318608908
  end
end