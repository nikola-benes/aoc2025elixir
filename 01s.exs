import Aoc

defmodule Day01 do
  def loop(state, part1, part2) do
    receive do
      {:rotate, val} ->
        new_state = Integer.mod(state + val, 100)
        to_zero = bool_to_int(new_state == 0)

        clicks = if val < 0 do
          z = abs(Integer.floor_div(state + val, 100))
          z + to_zero - bool_to_int(z > 0 and state == 0)
        else
          div(state + val, 100)
        end

        loop(new_state, part1 + to_zero, part2 + clicks)

      {:end, parent} ->
        send parent, {part1, part2}
    end
  end
end

safe = spawn_link fn -> Day01.loop(50, 0, 0) end

for line <- IO.stream(:line) do
  <<dir::utf8>> <> val = line
  {val, _} = Integer.parse(val)
  send safe, {:rotate, dir == ?L && -val || val}
end

send safe, {:end, self()}
receive do
  {part1, part2} ->
    IO.puts(part1)
    IO.puts(part2)
end
