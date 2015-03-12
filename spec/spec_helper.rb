RSpec.configure do |config|
  stdout = $stdout
  stderr = $stderr

  config.before :each, noisy: true do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  config.after :each, noisy: true do
    $stdout = stdout
    $stderr = stderr
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
