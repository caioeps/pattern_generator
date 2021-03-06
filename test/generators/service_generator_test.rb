require 'test_helper'

class ServiceGeneratorTest < Rails::Generators::TestCase
  tests ServiceGenerator

  destination File.join(Rails.root)
  teardown :cleanup

  def cleanup
    FileUtils.rm_rf(File.join(Rails.root, 'app/services'))
    FileUtils.rm_rf(File.join(Rails.root, 'spec/services'))
    FileUtils.rm_rf(File.join(Rails.root, 'test/services'))
  end

  test 'correct file is generated' do
    run_generator %w(find_match)

    assert_file 'app/services/find_match_service.rb' do |content|
      assert_match /class FindMatchService/, content
      assert_match /def initialize/, content
    end
  end

  test 'correct spec file is generated' do
    run_generator %w(find_match)

    assert_file 'spec/services/find_match_service_spec.rb' do |content|
      assert_match /RSpec.describe FindMatchService, type: :service/, content
      assert_match /pending/, content
    end
  end

  test 'generates minitest file if test-framework is minitest' do
    run_generator %w(find_match --minitest)

    assert_file 'test/services/find_match_service_test.rb' do |content|
      assert_match /class FindMatchServiceTest < Minitest::Test/, content
    end
  end

  test 'generates files with no suffixes if --no-sufix option is passed' do
    run_generator %w(find_match --no-suffix)

    assert_file 'app/services/find_match.rb' do |content|
      assert_match /FindMatch/, content
      assert_match /def initialize/, content
    end

    assert_file 'spec/services/find_match_spec.rb' do |content|
      assert_match /RSpec.describe FindMatch, type: :service/, content
    end
  end
end
