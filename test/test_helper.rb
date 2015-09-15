ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# VCR config
require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb

  c.ignore_request do |r|
    URI(r.uri).query == 'wsdl'
  end
end

# Mocha
require 'mocha/mini_test'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

class ActionController::TestCase
  setup :login_user

  def login_user
    AppSession.new(@controller.session).logged_in_as "mark"
    @controller.stubs(:current_user_name).returns("Mark")
  end

  def logout
    AppSession.new(@controller.session).logged_out
  end
end
