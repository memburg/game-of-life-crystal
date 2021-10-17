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
  property grid = [] of Array(Int32)
  property alive_cells = 0
  property dead_cells = 0
  property generation = 0

  def initialize(@width : Int32, @height : Int32, @alive_cells_pct : Int32, @render_time : Int32)
    @area = @width * @height
  end

  def initialise_grid
    # Set array of arrays full of 0's
    @grid = Array.new(@width) { Array.new(@height) { 0 } }
  end

  def set_alive_cells
    # Declare Y axis index
    y_axis : Int32 = 0

    loop do
      # Declare X axis index
      x_axis : Int32 = 0

      loop do
        if Random.rand(100) <= @alive_cells_pct
          @grid[y_axis][x_axis] = 1
          @alive_cells += 1
        end

        x_axis += 1
        break if x_axis == @width
      end

      y_axis += 1
      break if y_axis == @height
    end

    # Dead cells are calculated extracting
    # alive cells from grid area.
    @dead_cells = @area - @alive_cells
  end

  def print_grid
    # Clear console & print grid data
    puts "\33c\e[3JGrid size: #{@width}x#{@height}  Alive cells: #{@alive_cells}  Dead cells: #{@dead_cells}  Generation: #{@generation}\n\n"

    # Declare Y axis index
    y_axis : Int32 = 0

    loop do
      # Declare X axis index
      x_axis : Int32 = 0
      emoji_str : String = ""

      loop do
        # Concatenate emojis to emoji string
        emoji_str += @grid[y_axis][x_axis] == 0 ? '🌚' : '🌝'

        x_axis += 1
        break if x_axis == @width
      end

      puts emoji_str

      y_axis += 1
      break if y_axis == @height
    end
  end

  def recompute_cells
    # Create grid copy
    grid_copy = @grid.clone

    # Declare Y axis index
    y_axis : Int32 = 0

    loop do
      # Declare X axis index
      x_axis : Int32 = 0

      loop do
        # Current cell neighbourhood
        left : Int32 = x_axis - 1
        right : Int32 = x_axis + 1
        upper : Int32 = y_axis - 1
        bottom : Int32 = y_axis + 1

        # Adjust out of range indexes
        left = left < 0 ? @width - 1 : left
        right = right > @width - 1 ? 0 : right
        upper = upper < 0 ? @height - 1 : upper
        bottom = bottom > @height - 1 ? 0 : bottom

        alive_n : Int32 = @grid[upper][left] + @grid[upper][x_axis] + @grid[upper][right] + @grid[y_axis][left] + @grid[y_axis][right] + @grid[bottom][left] + @grid[bottom][x_axis] + @grid[bottom][right]

        if (@grid[y_axis][x_axis] == 0 && alive_n == 3)
          grid_copy[y_axis][x_axis] = 1
        elsif (@grid[y_axis][x_axis] == 1 && (alive_n == 3 || alive_n == 2))
          grid_copy[y_axis][x_axis] = 1
        else
          grid_copy[y_axis][x_axis] = 0
        end

        x_axis += 1
        break if x_axis == @width
      end

      y_axis += 1
      break if y_axis == @height
    end

    @grid = grid_copy.clone
    @generation += 1
  end

  def count_dead_alive_cells
    alive_cells : Int32 = 0
    idx : Int32 = 0

    loop do
      # Count every alive cell in each array inside main array
      alive_cells += @grid[idx].count(1)

      idx += 1
      break if idx == @height
    end

    @alive_cells = alive_cells
    @dead_cells = @area - @alive_cells
  end

  def play
    while true
      print_grid
      recompute_cells
      count_dead_alive_cells
      sleep(@render_time)
    end
  end
end

# Initialise grid
grid = Grid.new(10, 10, 30, 1)
grid.initialise_grid

# Set grid values (alive cells)
grid.set_alive_cells

# Start the Game of Life
grid.play
