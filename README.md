#SQUARES

Created by Nicholas Lee

Squares is a multiplayer board game that is based off the classic game MetaSquares.  The game provides both the server files needed to run the full game server and the client files to connect to the server and play the game.  Currently, the game can only be played against other human opponents, but I may add a single player function to the game with AI if there is enough interest.

The rules are fairly simple.  The game is a turn based board game that has two players.  During each player's turn they place a single tile on the board.  The goal of the game is to create squares.  The larger the square made, the more points are scored.  The first player to 150 points wins the game! (With a winning margin of more than 15 points)

==========

####Hosting a Server

Hosting a server is easy and the matchmaking is handled internally on the server, so many players can connect and play at the same time without having to worry about games conflicting with each other.  If you run a server on a local network, you merely need to setup port forwarding on your router in order to play opponents that are not on your local network.  The commands for running a server are as follows:

EX: $ ruby server.rb YOUR_IP_ADDRESS YOUR_PORT

Replace YOUR_IP_ADDRESS and YOUR_PORT with your own IP address and port.

==========

####Launching the Game

In order to launch the game, you will need to either be hosting a server yourself or know the address of a server being hosted elsewhere.  If you fail to enter the correct commands when launching the game you will get an error in game telling you that the program failed to find the game server.  The commands for launching the game are as follows:

EX: $ ruby main.rb SERVER_IP_ADDRESS SERVER_PORT USERNAME

Replace SERVER_IP_ADDRESS and SERVER_PORT with the server's IP address and port.  Replace USERNAME with your desired name in game.

Once the server has matched you with an opponent you will then see both your names displayed in game.

==========

####Game Controls:

Place Tile: Left Click

Close: Escape

==========

####Sample Gameplay:

![Squares 1](https://raw.githubusercontent.com/Maimer/squares/master/screenshots/squares1.png)

####Sample Gameplay:

![Squares 2](https://raw.githubusercontent.com/Maimer/squares/master/screenshots/squares2.png)

####Sample Gameplay:

![Squares 3](https://raw.githubusercontent.com/Maimer/squares/master/screenshots/squares3.png)
