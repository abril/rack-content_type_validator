require 'rubygems'
require 'test/unit'
require 'rack/mock'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rack/content_type_validator'

begin
  require "redgreen"
  require "ruby-debug"
rescue LoadError
  # Not required gems.
end

