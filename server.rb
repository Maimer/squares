require 'celluloid/io'

class Server
  include Celluloid::IO
  finalizer :shutdown

  def initialize(host, port)
    puts "Starting Server at #{host}:#{port}."
    @server = TCPServer.new(host, port)

    async.run
  end

  def shutdown
      @server.close if @server
  end

  def run
    loop { async.handle_connection(@server.accept) }
  end

  def handle_connection(socket)
    _, port, host = socket.peeraddr
    user = "#{host}:#{port}"
    puts "#{user} has joined the server."

    loop do
      socket.readpartial(4096)
      socket.write()
    end
  rescue EOFError
    puts "#{user} has left server."
    socket.close
  end
end

server, port = ARGV[0] || "0.0.0.0", ARGV[1] || 1234
