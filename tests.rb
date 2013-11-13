$LOAD_PATH <<  File.expand_path('.')
require 'minitest/autorun'
require 'nouns_verbed'

class TestDataForm < Minitest::Test

  def setup
    @tracked_things = [{:id=>1, :noun_singular=>"page", :noun_plural=>"pages", :verb_base=>"write", :verb_past=>"wrote"}]
  end

  def test_
    assert_match(/wrote.*count_1.*pages/, render_new_data_form(@tracked_things))
  end

end
