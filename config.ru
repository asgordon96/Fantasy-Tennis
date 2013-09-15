# This file is used by Rack-based servers to start the application.

require 'faye'
require ::File.expand_path('../config/environment',  __FILE__)
use Rack::Deflater
use Faye::RackAdapter, :mount => '/faye',
                       :timeout => 60

run Rails.application
