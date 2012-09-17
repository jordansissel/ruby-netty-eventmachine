require "netty-eventmachine/namespace"
require "java"

class EventMachine::Connection < org.jboss.netty.channel.SimpleChannelUpstreamHandler
  # add this interface
  include org.jboss.netty.channel.Channel
  #include org.jboss.netty.channel.ChannelHandler

  USASCII = java.nio.charset.Charset.defaultCharset
  
  public
  def initialize(*args)
    # Ensure the no-args SimpleChannelUpstreamHandler constructor is called.
    super()
  end

  # EventMachine API, 
  public
  def self.connect(bind_addr, bind_port, host, port)
    # TODO(sissel): 
  end # def EventMachine::Connection.connect

  private
  def post_init_setup(context)
    @peeraddr = context.getChannel.getRemoteAddress
    p :port => @peeraddr.getPort
    p :address => @peeraddr.getAddress
  end # def post_init_setup

  # org.jboss.netty.channel.Channel#channelConnected
  public
  def channelConnected(context, event)
    if respond_to?(:post_init)
      post_init_setup(context)
      post_init
    end
  end # def channelConnected

  # org.jboss.netty.channel.Channel#messageReceived
  public 
  def messageReceived(context, event)
    if respond_to?(:receive_data)
      #p event.getMessage.toString(USASCII)
      receive_data(event.getMessage.toString(USASCII))
    end
  end # def messageReceived

  # org.jboss.netty.channel.Channel#exceptionCaught
  public 
  def exceptionCaught(context, exception)
    puts "Exception -- " + exception.to_s
    puts "Backtrace: " + exception.cause.getStackTrace
  end # def exceptionCaught

  # org.jboss.netty.channel.Channel#channelConnected
  public
  def channelConnected(context, event)
    @channel = context.getChannel
    post_init
  end

  public # EventMachine api, post_init
  def post_init
    # Nothing by default
  end

  public # EventMachine api, receive_data
  def receive_data(data)
    puts "got data"
  end

  # This implementation of EM::Connection#get_peername doesn't return
  # a C-string representation of a sockaddr struct, because we just don't.
  # Instead, it returns an array [ address, port ]
  # 'address' will be a string of the address, and port a number
  public # EventMachine api, get_peername
  def get_peername
    if @channel.nil?
      # EM::C#get_peername returns nil on no peer.
      return nil
    end

    # ask for the channel's remote address
    socketaddr = @channel.getRemoteAddress
    return [ socketaddr.getAddress.getHostAddress, socketaddr.getPort ]
  end # def get_peername

end # class EventMachine::Connection < org.jboss.netty.channel.SimpleChannelUpstreamHandler
