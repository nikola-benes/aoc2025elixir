import Aoc
import Bitwise

defmodule Day10 do
  def solve(line) do
    {[goal | buttons], _} = line |> String.split |> Enum.split(-1)

    goal =
      goal
      |> String.replace(["[", "]"], "")
      |> to_charlist
      |> Enum.reverse
      |> Enum.reduce(0, fn c, acc -> (acc <<< 1) + bool_to_int(c == ?#) end)

    buttons =
      buttons
      |> Enum.map(fn b ->
        b
        |> String.replace(["(", ")"], "")
        |> String.split(",")
        |> Stream.map(& 1 <<< String.to_integer(&1))
        |> Enum.sum
      end)

    bfs(goal, buttons, [0], MapSet.new, 0)
  end

  # Why the @#$% does the Bitwise module have bit operations for integers but
  # not for bitstrings?!

  defp bfs(goal, buttons, queue, seen, dist) do
    dist = dist + 1

    queue
    |> Stream.flat_map(fn s -> buttons ~> bxor(s) end)
    |> Enum.reduce_while({[], seen}, fn state, {next, seen} ->
      cond do
        state == goal -> {:halt, nil}
        state in seen -> {:cont, {next, seen}}
        true -> {:cont, {[state | next], MapSet.put(seen, state)}}
      end
    end)
    |> then(fn
      {next, seen} -> bfs(goal, buttons, next |> Enum.reverse, seen, dist)
      nil -> dist
    end)
  end
end

IO.stream(:line)
~> Day10.solve
|> Enum.sum
|> IO.puts
