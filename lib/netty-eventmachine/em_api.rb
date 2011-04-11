require "netty-eventmachine/namespace"
require "netty-eventmachine/netty/pipeline"
require "java"

require "netty-eventmachine/connection"

module EventMachine
  java_import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory

  public # standard EventMachine API, start_server
  def self.start_server(address, port=nil, handlerclass=nil, *args, &block)
    # handler can be a subclass of EM::Connection or a module implementing the
    # right methods

    if handlerclass.is_a?(Class)
      channelfactory = NioServerSocketChannelFactory.new(
        java.util.concurrent.Executors.newCachedThreadPool,
        java.util.concurrent.Executors.newCachedThreadPool
      )

      bootstrap = org.jboss.netty.bootstrap.ServerBootstrap.new(channelfactory)
      bootstrap.setPipelineFactory(EventMachine::Netty::Pipeline.new(handlerclass))
      # TODO(sissel): Make this tunable, maybe a 'class'-wide setting on
      # handlerclass?
      bootstrap.setOption("child.tcpNoDelay", true)
      bootstrap.setOption("child.keepAlive", true)

      # TODO(sissel): async dns would be nice.
      bootstrap.bind(java.net.InetSocketAddress.new(address, port))
    else
      puts "EM.start_server with a module as handler not supported yet."
    end
  end # def start_server

  public # EventMachine API, run
  def self.run(&block)
    # Nothing to do
    block.call
  end
end
