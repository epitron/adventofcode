board = open("input.txt").each_line.map {|line| line.strip.each_char.map {|c| c == "#" } }

W, H = board.size, board.first.size

DELTAS = [
  [-1, -1], [-1, 0], [-1, 1],
  [ 0, -1],          [ 0, 1],
  [ 1, -1], [ 1, 0], [ 1, 1],
]

def transform(board)

  newboard = (0...H).map { Array(W) }

  H.times do |y|
    W.times do |x|
      neighbours = 0

      DELTAS.each do |dy, dx|
        nx = x+dx
        ny = y+dy

        if nx < W && nx >= 0 && ny < H and ny >= 0 and board[ny][nx]
          neighbours += 1          
        end
      end

      newboard[y][x] = board[y][x] ? (neighbours == 2 || neighbours == 3) : (neighbours == 3)
    end
  end

  newboard
end




print("\e[2J")


100.times do |n|
  [ [0,0], [H-1,W-1], [0,W-1], [H-1,0] ].each { |x,y| board[y][x] = true }

  print("\e[H")
  board.each { |row| puts row.map { |c| c ? "#" : "." }.join }
  print n

  sleep 0.05

  board = transform(board)
end

puts
p board.flatten.select(&:itself).count
