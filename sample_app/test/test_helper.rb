ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
<<<<<<< HEAD
=======
require "minitest/reporters"      
Minitest::Reporters.use!
>>>>>>> f7514a581dbe7d4adb3d9dada5bfd3c6ee419107

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
