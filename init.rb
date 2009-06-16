require File.join(File.dirname(__FILE__), "lib", "multisite")

if File.exist?("#{RAILS_ROOT}/config/multisite.yml")
  Multisite::Config.sites = YAML.load_file("#{RAILS_ROOT}/config/multisite.yml")
end