require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay03 < Minitest::Test
  def setup
    @data_a = File.read(File.join(APP_ROOT, 'examples', '03.txt')).rstrip
    @data_b = File.read(File.join(APP_ROOT, 'examples', '03_b.txt')).rstrip
    @day = Day03.new
  end

  def test_part1
    assert_equal @day.part1(@data_a), 161
  end

  def test_part2
    assert_equal @day.part2(@data_b), 48
  end
end