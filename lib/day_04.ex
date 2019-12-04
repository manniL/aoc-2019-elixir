defmodule Day04 do
  @moduledoc """
  Documentation for Day04.
  """

  def read_data(path) do
    path
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.trim
  end

  def parse_data(data) do
    data
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  def part_one(input \\ read_data('./inputs/day_04.txt')) do
    [min, max] = parse_data(input)
    min..max
    |> Stream.filter(&valid_code?/1)
    |> Enum.count
  end

  def part_two(input \\ read_data('./inputs/day_04.txt')) do
    [min, max] = parse_data(input)
    min..max
    |> Stream.filter(&strictly_valid_code?/1)
    |> Enum.count
  end

  def valid_code?(number) do
    digits_increasing?(number) and pair_of_digits?(number)
  end

  def strictly_valid_code?(number) do
    digits_increasing?(number) and strict_pair_of_digits?(number)
  end

  @doc ~S"""
  iex> Day04.pair_of_digits?(123)
  false

  iex> Day04.pair_of_digits?(11)
  true

  iex> Day04.pair_of_digits?(111)
  true

  iex> Day04.pair_of_digits?(11122)
  true

  iex> Day04.pair_of_digits?(1111)
  true

  iex> Day04.pair_of_digits?(111133)
  true

  iex> Day04.pair_of_digits?(1)
  false
  """
  def pair_of_digits?(number) do
    number
    |> Integer.digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn pair -> match?([a, a], pair) end)
  end



  @doc ~S"""
  iex> Day04.strict_pair_of_digits?(111234)
  false

  iex> Day04.strict_pair_of_digits?(11122)
  true

  iex> Day04.strict_pair_of_digits?(1111234)
  false

  iex> Day04.strict_pair_of_digits?(111133)
  true

  """

  def strict_pair_of_digits?(num) do
    num
    |> Integer.digits()
    |> Enum.chunk_by(&(&1)) # Split numbers into array of adjacent numbers
    |> Enum.any?(fn pair -> match?([a, a], pair) end)
  end

  @doc ~S"""
  iex> Day04.digits_increasing?(123)
  true

  iex> Day04.digits_increasing?(11)
  true

  iex> Day04.digits_increasing?(1)
  true

  iex> Day04.digits_increasing?(21)
  false
  """
  def digits_increasing?(number) do
    number
    |> Integer.digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [a, b] -> a > b end)
    |> Enum.empty?
  end

end
