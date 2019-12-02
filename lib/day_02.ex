defmodule Day02 do
  @moduledoc """
  Documentation for Day02.
  """


  def part_one() do
    read_data('./inputs/day_02.txt')
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> read_program
    |> Enum.at(0)
  end

  def part_two() do
    data = read_data('./inputs/day_02.txt')
    data
    |> brute_force_combination(19690720)
  end

  def brute_force_combination(data, desired_output, noun \\ 0, verb \\ 0) do

    all_values = for noun <- 0..99, verb <- 0..99 do
      output = data
               |> List.replace_at(1, noun)
               |> List.replace_at(2, verb)
               |> read_program
               |> Enum.at(0)

      [output, noun, verb]
    end

    all_values
    |> Enum.filter(fn [output | _] -> output == desired_output end)
    |> hd
    |> fn [_, noun, verb] -> 100 * noun + verb end.()
  end

  @doc ~S"""
  ## Examples

    iex> Day02.read_program([1,0,0,0,99])
    [2,0,0,0,99]

    iex> Day02.read_program([2,3,0,3,99])
    [2,3,0,6,99]

    iex> Day02.read_program([2,4,4,5,99,0])
    [2,4,4,5,99,9801]

    iex> Day02.read_program([1,1,1,4,99,5,6,0,99])
    [30,1,1,4,2,5,6,0,99]

  """
  def read_program(instructions, current_position \\ 0) do
    current_instructions = Enum.drop(instructions, current_position)
    case current_instructions do
      [opcode, first_input_position, second_input_position, store_at | other_instructions] ->

        first_input = Enum.at(instructions, first_input_position)
        second_input = Enum.at(instructions, second_input_position)

        case opcode do
          1 -> instructions
               |> List.replace_at(store_at, first_input + second_input)
               |> read_program(current_position + 4)
          2 -> instructions
               |> List.replace_at(store_at, first_input * second_input)
               |> read_program(current_position + 4)
          99 -> instructions
        end
      _ -> instructions
    end
  end

  defp read_data(path) do
    path
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
