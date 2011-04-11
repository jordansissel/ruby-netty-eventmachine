require "netty-eventmachine/namespace"
require "java"

class EventMachine::Netty::Pipeline
  include org.jboss.netty.channel.ChannelPipelineFactory

  def initialize(handlerclass, *args)
    @handlerclass = handlerclass
    @args = args
  end # def initialize

  public # org.jboss.netty.channel.ChannelPipelineFactory#getPipeline
  def getPipeline
    p "getPipeline" => [ @handlerclass ]
    handler = @handlerclass.new(*@args)
    return org.jboss.netty.channel.Channels.pipeline(handler)
  end # def getPipeline
end # class EventMachine::Netty::Pipeline

