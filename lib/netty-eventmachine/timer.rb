require "netty-eventmachine/namespace"
require "netty-eventmachine/netty/timertask"
require "java"

class EventMachine::Timer 
  public
  def initialize(delay, &block) 
    # Only want one HashedWheelTimer instance per application.
    # TODO(sissel): Make the tick interval configurable? Default is 100ms
    # TODO(sissel): Tunable size of wheel? (Number of schedulable tasks)
    @@timer ||= org.jboss.netty.util.HashedWheelTimer.new 
    @timertask = EventMachine::Netty::TimerTask.new(&block)

    # Convert to ms
    delay_ms = delay * 1000
    @timeout = @@timer.newTimeout(@timertask, delay_ms,
                                  java.util.concurrent.TimeUnit::MILLISECONDS)
  end # def initialize

  # EventMachine::Timer#cancel
  public
  def cancel
    @timeout.cancel
  end # def cancel
end
