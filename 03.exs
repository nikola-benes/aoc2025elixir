defmodule Day03 do
  def max_joltage(batt, n, acc \\ 0) do
    if n == 1 do
      acc + Enum.max(batt)
    else
      {digit, i} =
        batt
        |> Stream.drop(-n + 1)
        |> Stream.with_index()
        |> Enum.max_by(fn {v, _} -> v end)

      max_joltage(batt |> Enum.drop(i + 1), n - 1, (acc + digit) * 10)
    end
  end
end

IO.stream(:line)
|> Stream.map(fn line ->
  batt = for <<d <- String.trim(line)>>, do: d - ?0

  [2, 12] |> Enum.map(&Day03.max_joltage(batt, &1))
end)
|> Enum.reduce(fn [a, b], [x, y] -> [a + x, b + y] end)
|> Enum.each(&IO.puts/1)
