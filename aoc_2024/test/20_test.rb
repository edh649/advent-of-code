require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay20 < Minitest::Test
  def setup
    @day = Day20.new
  end

  def test_part1
    # assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '20.txt')).rstrip, 0), 44
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '20.txt')).rstrip, 50), 285
  end
end