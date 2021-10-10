# Game of Life: A Crystal Implementation

# Grid struct
#
# @width: grid width
# @height: grid height
# @area: total cells
# @grid: an array of arrays (container of cells)
# @alive_cells_pct: percentage of alive cells during initialisation
# @render_time: refresh between iterations (in seconds)
# @alive_cells: alive cells count
# @dead_cells: dead cells count
struct Grid
  property width
  property height
  property area = 0
  property alive_cells_pct
  property render_time
  property grid = [] of Int32
  property alive_cells = 0
  property dead_cells = 0
  property generation = 0

  def initialize(@width : Int32, @height : Int32, @alive_cells_pct : Int32, @render_time : Int32)
    @area = @width * @height
  end

  def initialise_grid
    # Create array of arrays full of 0's
    @grid = Array.new(@width * @height, 0)
  end

  def set_alive_cells
    idx : Int32 = 0

    loop do
      # If random number less equals alive cells
      # percentage, then set that cell as alive.
      if Random.rand(100) <= @alive_cells_pct
        @grid[idx] = 1
        @alive_cells += 1
      end

      idx += 1
      break if idx == @area
    end

    # Dead cells are calculated extracting
    # alive cells from grid area.
    @dead_cells = @area - @alive_cells
  end

  def print_grid
    # Print grid data and clear console
    puts "\33c\e[3JGrid size: #{@width}x#{@height}  Alive cells: #{@alive_cells}  Dead cells: #{@dead_cells}  Generation: #{@generation}\n\n"

    i : Int32 = @width

    while i <= @area
      puts "| #{@grid[i - @width..i - 1].join(" ")} |"
      i += @width
    end
  end

  def recalculate_cells
    loop do
      # Print grid data and clear console
      print_grid

      sleep(@render_time)
    end
  end
end

# Initialise grid
grid = Grid.new(3, 3, 30, 2)

# Initialise board
grid.initialise_grid
grid.set_alive_cells
grid.recalculate_cells
