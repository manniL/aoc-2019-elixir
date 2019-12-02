defmodule Day01 do
  @moduledoc """
  Documentation for Day01.
  """


  def part_one() do
    read_data('./inputs/day_01.txt')
    |> Stream.map(&fuel_for_module_mass/1)
    |> Enum.sum
  end

  def part_two() do
    read_data('./inputs/day_01.txt')
    |> Stream.map(&recursive_fuel_for_module_mass/1)
    |> Enum.sum
  end

  defp read_data(path) do
    path
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc ~S"""
  Fuel required to launch a given module is based on its mass.
  Specifically, to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2.

  ## Examples

      iex> Day01.fuel_for_module_mass(1969)
      654

      iex> Day01.fuel_for_module_mass(12)
      2

      iex> Day01.fuel_for_module_mass(14)
      2

      iex> Day01.fuel_for_module_mass(100756)
      33583
  """
  def fuel_for_module_mass(mass) do
    div(mass, 3) - 2
  end

  @doc ~S"""
  Fuel itself requires fuel just like a module - take its mass, divide by three, round down, and subtract 2
  However, that fuel also requires fuel, and that fuel requires fuel, and so on.
  Any mass that would require negative fuel should instead be treated as if it requires zero fuel;
  the remaining mass, if any, is instead handled by wishing really hard, which has no mass and is outside the scope of
  this calculation.
    A module of mass 14 requires 2 fuel. This fuel requires no further fuel (2 divided by 3 and rounded down is 0, which would call for a negative fuel), so the total fuel required is still just 2.
    At first, a module of mass 1969 requires 654 fuel. Then, this fuel requires 216 more fuel (654 / 3 - 2). 216 then requires 70 more fuel, which requires 21 fuel, which requires 5 fuel, which requires no further fuel. So, the total fuel required for a module of mass 1969 is 654 + 216 + 70 + 21 + 5 = 966.
        The fuel required by a module of mass 100756 and its fuel is: 33583 + 11192 + 3728 + 1240 + 411 + 135 + 43 + 12 + 2 = 50346.

  ## Examples

      iex> Day01.recursive_fuel_for_module_mass(14)
      2

      iex> Day01.recursive_fuel_for_module_mass(1969)
      966

      iex> Day01.recursive_fuel_for_module_mass(100756)
      50346
  """
  def recursive_fuel_for_module_mass(mass) do
    case fuel_for_module_mass(mass) do
      needed when needed > 0 -> needed + recursive_fuel_for_module_mass(needed)
      _ -> 0
    end
  end
end
