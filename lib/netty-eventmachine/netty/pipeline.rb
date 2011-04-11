require "netty-eventmachine/namespace"
require "java"

class EventMachine::Netty::Pipeline
  include org.jboss.netty.channel.ChannelPipelineFactory

  def initialize(handlerclass)
    @handlerclass = handlerclass
  end # def initialize

  public # org.jboss.netty.channel.ChannelPipelineFactory#getPipeline
  def getPipeline
    return org.jboss.netty.channel.Channels.pipeline(@handlerclass.new)
  end # def getPipeline
end # class EventMachine::Netty::Pipeline

