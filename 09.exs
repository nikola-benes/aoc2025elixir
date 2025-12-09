import Aoc

for line <- IO.stream(:line) do
  line |> String.trim |> String.split(",") |> Enum.map(&String.to_integer/1)
end
|> assign_to(red)

for {[bx, by], b} <- red |> Stream.with_index |> Stream.drop(1),
     [ax, ay]     <- red |>                      Stream.take(b) do
  {[[ax, ay], [bx, by]], (abs(ax - bx) + 1) * (abs(ay - by) + 1)}
end
|> assign_to(boxes)
~> elem(1)
|> Enum.max
|> IO.puts

# assumption: green lines never touch (true for my input)

minmax = fn a, b -> if a < b, do: {a, b}, else: {b, a} end

overlapping_insides? = fn [[ax, ay], [bx, by]], [[cx, cy], [dx, dy]] ->
  [left, mid_left | _] = Enum.sort([ax, bx, cx, dx])

  [top, mid_top | _] = Enum.sort([ay, by, cy, dy])

  {left, mid_left} not in [minmax.(ax, bx), minmax.(cx, dx)] and
    {top, mid_top} not in [minmax.(ay, by), minmax.(cy, dy)]
end

lines = red |> Enum.chunk_every(2, 1, [hd(red)])

boxes
|> Stream.reject(fn {box, _} ->
  Enum.any?(lines, &overlapping_insides?.(box, &1))
end)
~> elem(1)
|> Enum.max
|> IO.puts
