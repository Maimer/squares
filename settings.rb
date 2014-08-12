SCREEN_WIDTH = 520
SCREEN_HEIGHT = 660

SERVER = ARGV[0] || '127.0.0.1'
PORT = ARGV[1] || 1234
NAME = ARGV[2] || Randgen.first_name(length: 5 + rand(5))
