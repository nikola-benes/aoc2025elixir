import Aoc

for line <- IO.stream(:line) do
  line |> String.trim |> String.split(",") |> Enum.map(&String.to_integer/1)
end
|> assign_to(red)

minmax = fn a, b -> if a < b, do: {a, b}, else: {b, a} end

normalize = fn [[ax, ay], [bx, by]] ->
  {l, r} = minmax.(ax, bx)
  {t, b} = minmax.(ay, by)
  {l, r, t, b}
end

for {[bx, by], b} <- red |> Stream.with_index |> Stream.drop(1),
     [ax, ay]     <- red |>                      Stream.take(b) do
  {normalize.([[ax, ay], [bx, by]]), (abs(ax - bx) + 1) * (abs(ay - by) + 1)}
end
|> List.keysort(1, :desc)
|> assign_to(boxes)
|> hd
|> elem(1)
|> IO.puts

# assumption: green lines never touch (true for my input)

overlapping_insides? = fn {l1, r1, t1, b1}, {l2, r2, t2, b2} ->
  r1 > l2 and r2 > l1 and b1 > t2 and b2 > t1
end

lines = red |> Stream.chunk_every(2, 1, [hd(red)]) |> Enum.map(normalize)

boxes
|> Stream.reject(fn {box, _} ->
  Enum.any?(lines, &overlapping_insides?.(box, &1))
end)
|> Enum.at(0)
|> elem(1)
|> IO.puts
