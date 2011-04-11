# Netty-backed EventMachien API

The goal of this project to provide an EventMachine model using Netty as the
implementation. Overall, I aim to be API compatible with EventMachine as-is with
long-term goal of replacing the current jruby eventmachine implementation.

## Example:

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
