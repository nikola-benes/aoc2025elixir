defmodule Day01 do
  defp bool_to_int(true), do: 1
  defp bool_to_int(false), do: 0

  def start do
    Agent.start_link(fn -> {50, 0, 0} end, name: __MODULE__)
  end

  def rotate val do
    Agent.update(__MODULE__, fn {state, part1, part2} ->
      new_state = Integer.mod(state + val, 100)
      to_zero = bool_to_int(new_state == 0)

      clicks = if val < 0 do
        z = abs(Integer.floor_div(state + val, 100))
        z + to_zero - bool_to_int(z > 0 and state == 0)
      else
        div(state + val, 100)
      end

      {new_state, part1 + to_zero, part2 + clicks}
    end)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end
end

Day01.start()

for line <- IO.stream(:line) do
  <<dir::utf8>> <> val = line
  {val, _} = Integer.parse(val)
  Day01.rotate(dir == ?L && -val || val)
end

{_, part1, part2} = Day01.get()
IO.puts(part1)
IO.puts(part2)
