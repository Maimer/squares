require 'celluloid/io'
require 'pry'

class Server
  include Celluloid::IO
  finalizer :shutdown

  def initialize(host, port)
    puts "Starting Server at #{host}:#{port}."
    @server = TCPServer.new(host, port)
    @players = {}
    @games = []

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
      data = socket.readpartial(4096).split('|')
      if data && !data.empty?
        begin
          case data[0]
          when 'join'
            @players[user] = [data[1], nil]
            if @players.size % 2 == 0
              @players.each do |player, data|
                if player != user && data[1] == nil
                  @games << { orange: player,
                              blue: user,
                              orange_score: 0,
                              blue_score: 0,
                              tiles: [] }
                  @players[player][1] = @games.size - 1
                  @players[user][1] = @games.size - 1
                end
              end
            end
          when 'move'
            # check for valid move and record move
            # socket.write()
          when 'wait'
            if @players[user][1] != nil
              game = @players[user][1]
              response = ['game',
                          @games[game][orange][0],
                          @games[game][blue][0],
                          @games[game][orange_score],
                          @games[game][blue_score],
                          @games[game][tiles]].join('|')
              socket.write(response)
            else
              response = "waiting"
              socket.write(response)
            end
          end
        rescue
        end
      end
    end
  rescue EOFError
    puts "#{user} has left server."
    @games.delete_at(@players[user][1])
    @players.delete(user)
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
