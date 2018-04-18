$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "octofart"
require "webmock/rspec"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
