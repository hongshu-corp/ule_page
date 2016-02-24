$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ule_page'
require 'capybara'
require 'capybara/dsl'
require 'site_prism'

class MyTest
  def response
    [200, { 'Content-Length' => '9' }, ['MyTestApp']]
  end
end

class MyTestApp
  def call(_env)
    MyTest.new.response
  end
end

Capybara.app = MyTestApp.new
