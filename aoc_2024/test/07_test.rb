require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay07 < Minitest::Test
  def setup
    @data_a = File.read(File.join(APP_ROOT, 'examples', '07.txt')).rstrip
    @data_a_custom = File.read(File.join(APP_ROOT, 'examples', '07_custom.txt')).rstrip
    @data_b = File
    .read(File.join(APP_ROOT, 'examples', '07.txt')).rstrip
    @day = Day07.new
  end

  def test_part1
    assert_equal @day.part1(@data_a), 3749
    assert_equal @day.part1(@data_a_custom), 25483
  end

  def test_part2
    assert_equal @day.part2(@data_b), 11387
  end
end