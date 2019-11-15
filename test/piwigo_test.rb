require "test_helper"

class PiwigoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Piwigo::VERSION
  end

end
