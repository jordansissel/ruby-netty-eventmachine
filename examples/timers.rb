require "netty-3.2.4.Final.jar"
$: << "lib"
require "netty-eventmachine/em_api.rb"

class Conn < EventMachine::Connection
  def receive_data(data)
    p :received => data
  end
end

def tputs(*args)
  p Thread.current, *args
end

EventMachine.run do
  #EventMachine.start_server("0.0.0.0", 3333, Conn)
  tputs "Hello"
  1.upto(10) do |i|
    t = EventMachine::Timer.new(i * 0.1) do
      tputs "world #{i}"
    end
    t.cancel if i % 2 == 0
  end
end
