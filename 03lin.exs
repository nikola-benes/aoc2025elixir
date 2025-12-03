defmodule Day03 do
  defp max_joltage(batt, b_len, stack, empty) do
    case {batt, stack} do
      {[], _} ->
        stack |> Enum.reverse() |> Integer.undigits()

      {[cur | _], [top | tail]} when top < cur and b_len > empty ->
        max_joltage(batt, b_len, tail, empty + 1)

      {[cur | rest], _} when empty > 0 ->
        max_joltage(rest, b_len - 1, [cur | stack], empty - 1)

      {[_ | rest], _} ->
        max_joltage(rest, b_len - 1, stack, 0)
    end
  end

  def max_joltage(batt, n) do
    max_joltage(batt, length(batt), [], n)
  end
end

IO.stream(:line)
|> Stream.map(fn line ->
  batt = for <<d <- String.trim(line)>>, do: d - ?0

  [2, 12] |> Enum.map(&Day03.max_joltage(batt, &1))
end)
|> Enum.reduce(fn [a, b], [x, y] -> [a + x, b + y] end)
|> Enum.each(&IO.puts/1)
