defmodule Day03 do
  @moduledoc """
  Documentation for Day03.
  """

  def read_data(path) do
    path
    |> Path.expand(__DIR__)
    |> File.read!
  end

  def parse_data(data) do
    data
    |> String.split()
    |> Enum.map(
         fn line -> line
                    |> String.split(",")
                    |> Enum.map(
                         fn move ->
                           <<dir, steps :: binary>> = move
                           offset = case dir do
                             ?U -> {0, -1}
                             ?D -> {0, 1}
                             ?L -> {-1, 0}
                             ?R -> {1, 0}
                           end
                           %{offset: offset, distance: String.to_integer(steps)}
                         end
                       )
         end
       )
  end

  @doc ~S"""
  iex> Day03.part_one("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
  159

  iex> Day03.part_one("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
  135
  """
  def part_one(input \\ read_data("./inputs/day_03.txt")) do
    input
    |> parse_data
    |> setup_wires
    |> find_intersections
    |> find_closest_intersection
  end

  @doc ~S"""
    iex> Day03.part_two("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
    610

    iex> Day03.part_two("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
    410
  """
  def part_two(input \\ read_data("./inputs/day_03.txt")) do
    input
    |> parse_data
    |> setup_wires
    |> add_intersections
    |> find_closest_by_steps
  end

  def setup_wires(input) do
    input
    |> Stream.map(fn directions -> Enum.reduce(directions, [{0, 0}], &add_coordinates/2) end)
    |> Stream.map(
         fn points ->
           points
           |> Enum.reverse
             # Remove 0,0
           |> tl
         end
       )
  end

  defp add_coordinates(%{offset: {offset_x, offset_y}, distance: distance}, points) do
    points
    |> Stream.iterate(
         fn [{previous_x, previous_y} = previous | rest] ->
           [{previous_x + offset_x, previous_y + offset_y}, previous | rest] end
       )
    |> Stream.drop(1)
    |> Stream.take(distance)
    |> Enum.at(-1)
  end

  def find_intersections(wires) do
    wires
    |> Stream.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.delete({0, 0})
  end

  def add_intersections(wires) do
    %{wires: wires, intersections: find_intersections(wires)}
  end

  def find_closest_intersection(intersections) do
    intersections
    |> Stream.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min
  end

  def find_closest_by_steps(map) do
    map.intersections
    |> Stream.map(
         fn intersection ->
           Enum.reduce(
             map.wires,
             0,
             fn wire, sum -> sum + Enum.find_index(wire, fn point -> point == intersection end) + 1 end
           )
         end
       )
    |> Enum.min
  end
end
