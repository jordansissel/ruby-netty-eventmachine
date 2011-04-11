require "netty-eventmachine/namespace"
require "netty-eventmachine/netty/pipeline"
require "java"

require "netty-eventmachine/connection"
require "netty-eventmachine/timer"

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
      bootstrap.setPipelineFactory(EventMachine::Netty::Pipeline.new(handlerclass, *args))
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
    block.call
    # TODO(sissel): we should block until netty exits.
  end # def run

  public # EventMachine API add_timer
  def self.add_timer(delay, &block)
    return EventMachine::Timer.new(delay, &block)
  end # def add_timer

  # Implement next_tick as a timer since Netty has no notion of "ticks"
  public # EventMachine API next_tick
  def self.next_tick(&block)
    self.add_timer(0, &block)
    return nil
  end # def next_tick

  # Can't implement EM::fork_reactor, JRuby (and java) don't have fork. Why? On
  # POSIX systems, fork doesn't keep any other pthreads, so all the management
  # threads the JVM and JRuby run will be lost.
  public # EventMachine API fork_reactor
  def self.fork_reactor(&block)
    raise NotImplemented.new
  end # def fork_reactor
end
