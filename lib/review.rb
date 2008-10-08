require 'yaml'
class Review < ActiveResource::Base
  config = File.open("#{RAILS_ROOT}/config/reviewable.yml") 
  options = YAML.load(config)
  self.site = options[:url]
end