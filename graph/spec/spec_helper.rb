require 'bundler'
Bundler.require :default, :test

RSpec.configure do |config|
  config.order = :random
  config.color = true
end
