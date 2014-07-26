require 'celluloid/io'
require 'pry'

class Server
  include Celluloid::IO
  finalizer :shutdown

  def initialize(host, port)
    puts "Starting Server at #{host}:#{port}."
    @server = TCPServer.new(host, port)
    @games = {}

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
      data = socket.readpartial(4096)
      data = data.split('|')
      if data && !data.empty?
        begin
          case data[0]
          when 'join'
            binding.pry
          when 'move'

          end
        rescue
        end


      # socket.write()
      end
    end
  rescue EOFError
    puts "#{user} has left server."
    socket.close
  end
end

server = ARGV[0] || "127.0.0.1"
port = ARGV[1] || 1234

supervisor = Server.supervise(server, port.to_i)
trap("INT") do
  supervisor.terminate
  exit
end

sleep
