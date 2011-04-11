require "netty-eventmachine/namespace"
require "java"

class EventMachine::Netty::TimerTask
  include org.jboss.netty.util.TimerTask

  def initialize(&block)
    @block = block
  end

  def run(timeout)
    @block.call
  end
end
