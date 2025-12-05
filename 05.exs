defmodule Day05 do
  def join_ranges([a..b//_, c..d//_ | rest]) when c <= b do
    join_ranges [a..max(b, d) | rest]
  end

  def join_ranges([r | rest]), do: [r | join_ranges(rest)]

  def join_ranges([]), do: []
end

import Aoc

ranges =
  for line <- IO.stream(:line) |> Stream.take_while(& &1 != "\n") do
    [from, to] =
      Regex.run(~r/(.*)-(.*)/, line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    from..to
  end

IO.stream(:line)
~> (String.trim |> String.to_integer)
|> Enum.count(fn i -> Enum.any?(ranges, & i in &1) end)
|> IO.puts

ranges
|> Enum.sort_by(& &1.first)
|> Day05.join_ranges
~> Range.size
|> Enum.sum
|> IO.puts
