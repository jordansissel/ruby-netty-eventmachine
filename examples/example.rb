require "netty-3.2.4.Final.jar"
$: << "lib"
require "netty-eventmachine/em_api.rb"

class Conn < EventMachine::Connection
  def receive_data(data)
    p :received => data
  end
end

EventMachine.run do
  EventMachine.start_server("0.0.0.0", 3333, Conn)
end
