defmodule PartOne do
  defmodule Point do
    defstruct [:x, :y]
  end

  defmodule Grid do
    defstruct [:data, :width, :height]
  end

  defp parse_line(line) do
    String.codepoints(line)
    |> Enum.map(&elem(Integer.parse(&1), 0))
    |> Enum.reduce([], &(&2 ++ [&1]))
  end

  defp load_input do
    grid =
      IO.read(:stdio, :eof)
      |> String.split("\n")
      |> Enum.map(&parse_line/1)
      |> Enum.reduce([], &(&2 ++ [&1]))

    %Grid{data: grid, width: length(Enum.at(grid, 0)), height: length(grid)}
  end

  @doc """
  Get the height number at the given position in the grid.
  """
  defp get_height_at(grid, %Point{x: x, y: y}) do
    Enum.at(grid.data, y)
    |> Enum.at(x)
  end

  defp put_trailheads_row(lst, [], _x, _y), do: lst

  defp put_trailheads_row(lst, [head | rest], x, y) do
    if head == 0 do
      put_trailheads_row([%Point{x: x, y: y} | lst], rest, x + 1, y)
    else
      put_trailheads_row(lst, rest, x + 1, y)
    end
  end

  @doc """
  Enumerate all the trailheads in the given data list and return
  a list of Points representing all those trailheads.
  """
  defp put_trailheads(data), do: put_trailheads([], data, 0)
  defp put_trailheads(lst, [], _y), do: lst

  defp put_trailheads(lst, [head | rest], y) do
    put_trailheads_row(lst, head, 0, y)
    |> put_trailheads(rest, y + 1)
  end

  defp put_neighbor(lst, %Point{x: x, y: y}, width, height)
       when x < 0
       when y < 0
       when x >= width
       when y >= height,
       do: lst

  defp put_neighbor(lst, neighbor, _width, _height), do: [neighbor | lst]

  @doc """
  Get all the neighbor Points of a given Point on the grid,
  where all points fall inside the grid's bounds.
  """
  defp neighbors(%Grid{width: width, height: height}, %Point{x: x, y: y}) do
    [
      %Point{x: x - 1, y: y},
      %Point{x: x + 1, y: y},
      %Point{x: x, y: y - 1},
      %Point{x: x, y: y + 1}
    ]
    |> Enum.reduce([], &put_neighbor(&2, &1, width, height))
  end

  @doc """
  Search for all the 9-height points that can be reached from the given start
  Point at height 0, following a path where each step must increase by 1
  height level.
  """
  defp search(grid, start), do: search(grid, start, 1)
  defp search(_grid, start, 10), do: start

  defp search(grid, start, desired_height) do
    neighbors(grid, start)
    |> Enum.filter(&(get_height_at(grid, &1) == desired_height))
    |> Enum.map(&search(grid, &1, desired_height + 1))
    |> List.flatten()
  end

  defp score_part_1(grid, trailhead) do
    search(grid, trailhead)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp score_part_2(grid, trailhead) do
    search(grid, trailhead)
    |> Enum.count()
  end

  def start(_type, _args) do
    grid = load_input()
    trailheads = put_trailheads(grid.data)

    # Part 1
    IO.inspect(
      trailheads
      |> Enum.map(&score_part_1(grid, &1))
      |> Enum.sum()
    )

    # Part 2
    IO.inspect(
      trailheads
      |> Enum.map(&score_part_2(grid, &1))
      |> Enum.sum()
    )

    {:ok, self()}
  end
end
