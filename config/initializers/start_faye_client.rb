require 'faye_client'
Process.fork do
  FayeClient.start
end