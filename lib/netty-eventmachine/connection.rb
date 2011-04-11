require "netty-eventmachine/namespace"
require "java"

class EventMachine::Connection < org.jboss.netty.channel.SimpleChannelUpstreamHandler
  # add this interface
  include org.jboss.netty.channel.Channel

  USASCII = java.nio.charset.Charset.defaultCharset

  # org.jboss.netty.channel.Channel#messageReceived
  public 
  def messageReceived(context, event)
    puts event.getMessage
    if respond_to?(:receive_data)
      receive_data(event.getMessage.toString(USASCII))
    end
  end # def messageReceived

  # org.jboss.netty.channel.Channel#exceptionCaught
  public 
  def exceptionCaught(context, exception)
    puts "Exception -- " + exception.to_s
    puts "Backtrace: " + exception.cause.getStackTrace
  end # def exceptionCaught

  public # Eventmachine api, post_init
  def post_init; end

  public # Eventmachine api, receive_data
  def receive_data(data)
    puts "got data"
  end
end # class EventMachine::Connection < org.jboss.netty.channel.SimpleChannelUpstreamHandler
